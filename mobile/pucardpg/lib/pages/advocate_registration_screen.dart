import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:digit_components/digit_components.dart';
import 'package:digit_components/widgets/atoms/digit_toaster.dart';
import 'package:digit_components/widgets/digit_card.dart';
import 'package:digit_components/widgets/widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pucardpg/blocs/auth-bloc/authbloc.dart';
import 'package:pucardpg/blocs/file-picker-bloc/file_picker.dart';
import 'package:pucardpg/mixin/app_mixin.dart';
import 'package:pucardpg/model/litigant_model.dart';
import 'package:pucardpg/routes/routes.dart';
import 'package:pucardpg/widget/back_button.dart';
import 'package:pucardpg/widget/help_button.dart';
import 'package:pucardpg/widget/page_heading.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

@RoutePage()
class AdvocateRegistrationScreen extends StatefulWidget with AppMixin{

  AdvocateRegistrationScreen({super.key});

  @override
  AdvocateRegistrationScreenState createState() => AdvocateRegistrationScreenState();

}

class AdvocateRegistrationScreenState extends State<AdvocateRegistrationScreen> {

  bool fileSizeExceeded = false;
  bool extensionError = false;
  String? fileName;
  String? documentFilename;
  Uint8List? documentBytes;
  FilePickerResult? result;
  PlatformFile? pickedFile;
  File? fileToDisplay;

  @override
  void initState() {
    super.initState();
  }

  void pickFile() async {
    try {
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'png'],
        allowMultiple: false,
        withData: true,
      );
      if (result != null) {
        final file = File(result!.files.single.path!);
        final fileSize = await file.length(); // Get file size in bytes
        const maxFileSize = 5 * 1024 * 1024; // 5MB in bytes

        if (!['pdf', 'jpg', 'png', 'jpeg'].contains(result!.files.single.extension)) {
          setState(() {
            extensionError = true;
          });
        } else {
          if (fileSize <= maxFileSize) {
            context.read<AuthBloc>().userModel.documentType = result!.files.single.extension;
            fileName = '1 File Uploaded';
            pickedFile = result!.files.single;
            documentFilename = result!.files.single.name;
            documentBytes = result!.files.single.bytes;
            if (pickedFile != null) {
              context.read<FileBloc>().add(FileEvent.upload(pickedFile: pickedFile!, type: 'bar'));
            }
            setState(() {
              fileToDisplay = file;
              extensionError = false;
              fileSizeExceeded = false;
            });
          } else {
            setState(() {
              extensionError = false;
              fileSizeExceeded = true;
            });
          }
        }
      }
    } catch(e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DigitBackButton(),
                        DigitHelpButton()],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PageHeading(
                            heading: 'Advocate Verification',
                            subHeading: 'To ensure the authenticity of your profile, please provide the following details for us to verify',
                            headingStyle: widget.theme.text24W700(),
                            subHeadingStyle: widget.theme.text14W400Rob(),
                          ),
                          DigitTextField(
                            label: 'BAR registration number',
                            isRequired: true,
                            onChange: (val) {
                              context.read<AuthBloc>().userModel.barRegistrationNumber = val;
                            },
                            inputFormatter: [
                              FilteringTextInputFormatter.allow(
                                  RegExp("[a-zA-Z0-9\\/\\']"))
                            ],
                            textCapitalization: TextCapitalization.characters,
                          ),
                          const SizedBox(height: 20,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: DigitTextField(
                                  label: 'Upload BAR council ID',
                                  controller: TextEditingController(text: fileName ?? ''),
                                  isRequired: true,
                                  readOnly: true,
                                  hintText: 'No File selected',
                                  onChange: (val) { },
                                ),
                              ),
                              const SizedBox(width: 10,),
                              BlocListener<FileBloc, FileState>(
                                bloc: context.read<FileBloc>(),
                                listener: (context, state) {
                                  state.maybeWhen(
                                    orElse: (){},
                                    barFailed: (error){
                                      DigitToast.show(context,
                                        options: DigitToastOptions(
                                          error,
                                          true,
                                          widget.theme.theme(),
                                        ),
                                      );
                                    },
                                    uploadBarSuccess: (fileStoreId) {
                                      context.read<AuthBloc>().userModel.fileStore = fileStoreId;
                                      context.read<AuthBloc>().userModel.documentFilename = documentFilename;
                                      context.read<AuthBloc>().userModel.documentBytes = documentBytes;
                                    }
                                  );
                                },
                                child: SizedBox(
                                  height: 44,
                                  width: 120,
                                  child: Container(
                                    constraints: const BoxConstraints(maxHeight: 50, minHeight: 40),
                                    child: OutlinedButton(
                                      onPressed: () {
                                        pickFile();
                                      },
                                      style: OutlinedButton.styleFrom(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.zero,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Flexible(
                                                child: Icon(
                                                  Icons.file_upload,
                                                  color: widget.theme.colorScheme.secondary,
                                                )),
                                            const SizedBox(width: 2),
                                            Text(
                                              "Upload",
                                              style: DigitTheme.instance.mobileTheme.textTheme.headlineSmall
                                                  ?.apply(
                                                color: widget.theme.colorScheme.secondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 8,),
                          if (fileSizeExceeded) // Show text line in red if file size exceeded
                            const Text(
                              'File Size Limit Exceeded. Upload a file below 5MB.',
                              style: TextStyle(color: Colors.red),
                            ),
                          if (extensionError) // Show text line in red if file size exceeded
                            const Text(
                              'Please select a valid file format. Upload documents in the following formats: JPG, PNG or PDF.',
                              style: TextStyle(color: Colors.red),
                            ),
                          if (pickedFile != null) ...[
                            const SizedBox(height: 20),
                            if (pickedFile!.extension == 'pdf')
                              Stack(
                                children: [
                                  Container(
                                    height: 300,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius:  const BorderRadius.all(Radius.circular(21))
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20), // Image border
                                      child: SizedBox(
                                          child: SfPdfViewer.file(
                                            fileToDisplay!,
                                            onTap: (pdfDetails) {
                                              if (fileToDisplay != null) {
                                                OpenFilex.open(fileToDisplay!.path);
                                              }
                                            },
                                          )
                                      ),
                                    ),

                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: Color(0XFF0B4B66),
                                          borderRadius:  BorderRadius.only(
                                              topRight: Radius.circular(4),
                                              bottomLeft: Radius.circular(4)
                                          )
                                      ),
                                      child: IconButton(
                                        icon: Icon(Icons.close),
                                        color: Colors.white,
                                        onPressed: () {
                                          setState(() {
                                            pickedFile = null;
                                            fileName = null;
                                            context.read<AuthBloc>().userModel.fileStore = null;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (pickedFile!.extension != 'pdf')
                              GestureDetector(
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 300,
                                      width: 500,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey),
                                          borderRadius:  const BorderRadius.all(Radius.circular(21))
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20), // Image border
                                        child: SizedBox.fromSize(
                                          size: Size.fromRadius(16), // Image radius
                                          child: Image.file(
                                            fileToDisplay!,
                                            filterQuality: FilterQuality.high,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            color: Color(0XFF0B4B66),
                                            borderRadius:  BorderRadius.only(
                                                topRight: Radius.circular(4),
                                                bottomLeft: Radius.circular(4)
                                            )
                                        ),
                                        child: IconButton(
                                          icon: Icon(Icons.close),
                                          color: Colors.white,
                                          onPressed: () {
                                            setState(() {
                                              pickedFile = null;
                                              fileName = null;
                                              context.read<AuthBloc>().userModel.fileStore = null;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  if (pickedFile!.extension != 'pdf') {
                                    OpenFilex.open(fileToDisplay!.path);
                                  }
                                },
                              ),
                          ],
                        ],
                      ),
                    ),
                    // Expanded(child: Container(),),
                  ],
                ),
              ),
            ),
            const Divider(height: 0, thickness: 2,),
            DigitCard(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
              child: DigitElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    if (context.read<AuthBloc>().userModel.userType == 'ADVOCATE') {
                      if((context.read<AuthBloc>().userModel.barRegistrationNumber == null || context.read<AuthBloc>().userModel.barRegistrationNumber!.isEmpty)
                          && (fileName == null || fileName!.isEmpty)) {
                        DigitToast.show(context,
                          options: DigitToastOptions(
                            "Please fill the details",
                            true,
                            widget.theme.theme(),
                          ),
                        );
                        return;
                      }
                      if((context.read<AuthBloc>().userModel.barRegistrationNumber == null || context.read<AuthBloc>().userModel.barRegistrationNumber!.isEmpty)
                          && (fileName != null || fileName!.isNotEmpty)) {
                        DigitToast.show(context,
                          options: DigitToastOptions(
                            "Please fill the BAR registration number",
                            true,
                            widget.theme.theme(),
                          ),
                        );
                        return;
                      }
                      if((context.read<AuthBloc>().userModel.barRegistrationNumber != null || context.read<AuthBloc>().userModel.barRegistrationNumber!.isNotEmpty)
                          && (fileName == null || fileName!.isEmpty)) {
                        DigitToast.show(context,
                          options: DigitToastOptions(
                            "Please upload the BAR council ID",
                            true,
                            widget.theme.theme(),
                          ),
                        );
                        return;
                      }
                    }
                    AutoRouter.of(context)
                        .push(TermsAndConditionsRoute());
                    },
                  child: Text('Next',  style: widget.theme.text20W700()?.apply(color: Colors.white, ),)
              ),
            ),
          ],
        ),
    );
  }
}