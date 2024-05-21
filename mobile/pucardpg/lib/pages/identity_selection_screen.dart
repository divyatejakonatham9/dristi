import 'package:auto_route/auto_route.dart';
import 'package:digit_components/digit_components.dart';
import 'package:digit_components/widgets/digit_card.dart';
import 'package:digit_components/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pucardpg/mixin/app_mixin.dart';
import 'package:pucardpg/model/litigant_model.dart';
import 'package:pucardpg/routes/routes.dart';
import 'package:pucardpg/widget/back_button.dart';
import 'package:pucardpg/widget/help_button.dart';
import 'package:pucardpg/widget/page_heading.dart';

@RoutePage()
class IdentitySelectionScreen extends StatefulWidget with AppMixin {

  IdentitySelectionScreen({super.key});

  @override
  IdentitySelectionScreenState createState() => IdentitySelectionScreenState();
}

class IdentitySelectionScreenState extends State<IdentitySelectionScreen> {

  String? selectedOption;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PageHeading(
                            heading: "Verify your Identity",
                            subHeading: "Before diving in, we'll need to verify your identity for account setup ",
                            headingStyle: widget.theme.text24W700(),
                            subHeadingStyle: widget.theme.text14W400Rob(),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey, // Change the color as per your requirement
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                            ),
                            child: RadioListTile(
                              title: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  'Aadhaar (Recommended)',
                                  style: widget.theme.text20W700(),
                                ),
                              ),
                              subtitle: Text(
                                'An instant verification that will provide a verified status against your profile',
                                style: widget.theme.text12W400(),
                              ),
                              value: 'AADHAR',
                              groupValue: selectedOption,
                              contentPadding: EdgeInsets.zero,
                              onChanged: (value) {
                                setState(() {
                                  selectedOption = value;
                                });
                              },
                              fillColor: MaterialStatePropertyAll(widget.theme.defaultColor),
                            ),
                          ),
                          const SizedBox(height: 15,),
                          const SizedBox(height: 25,),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey, // Change the color as per your requirement
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                            ),
                            child: RadioListTile(
                              title: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  'Other ID',
                                  style: widget.theme.text20W700(),
                                ),
                              ),
                              subtitle: Text(
                                'Manual verification by uploading government ID',
                                style: widget.theme.text12W400(),
                              ),
                              value: 'OTHER',
                              groupValue: selectedOption,
                              contentPadding: EdgeInsets.zero,
                              onChanged: (value) {
                                setState(() {
                                  selectedOption = value;
                                });
                              },
                              fillColor: MaterialStatePropertyAll(widget.theme.defaultColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Expanded(child: Container(),),
                  ],
                ),
              ),
            ),
            const Divider(
              height: 0,
              thickness: 2,
            ),
            DigitCard(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
              child: DigitElevatedButton(
                  onPressed: () {
                    if (selectedOption == 'AADHAR') {
                      AutoRouter.of(context)
                          .push(AadharVerificationRoute());
                    } else if (selectedOption == 'OTHER') {
                      AutoRouter.of(context)
                          .push(OtherIdVerificationRoute());
                    }
                  },
                  child: Text(
                    'Continue',
                    style: widget.theme.text20W700()?.apply(
                      color: Colors.white,
                    ),
                  )),
            ),
            // ),
          ],
        ));
  }
}