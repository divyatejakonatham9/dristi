// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advocate_clerk_registration_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClerkImpl _$$ClerkImplFromJson(Map<String, dynamic> json) => _$ClerkImpl(
      id: json['id'] as String?,
      tenantId: json['tenantId'] as String?,
      applicationNumber: json['applicationNumber'] as String?,
      status: json['status'] as String?,
      stateRegnNumber: json['stateRegnNumber'] as String?,
      advocateType: json['advocateType'] as String?,
      organisationID: json['organisationID'] as String?,
      individualId: json['individualId'] as String?,
      isActive: json['isActive'] as bool?,
      workflow: json['workflow'] == null
          ? null
          : Workflow.fromJson(json['workflow'] as Map<String, dynamic>),
      documents: (json['documents'] as List<dynamic>?)
          ?.map((e) => Document.fromJson(e as Map<String, dynamic>))
          .toList(),
      additionalDetails: json['additionalDetails'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ClerkImplToJson(_$ClerkImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenantId': instance.tenantId,
      'applicationNumber': instance.applicationNumber,
      'status': instance.status,
      'stateRegnNumber': instance.stateRegnNumber,
      'advocateType': instance.advocateType,
      'organisationID': instance.organisationID,
      'individualId': instance.individualId,
      'isActive': instance.isActive,
      'workflow': instance.workflow,
      'documents': instance.documents,
      'additionalDetails': instance.additionalDetails,
    };

_$AdvocateClerkRegistrationRequestImpl
    _$$AdvocateClerkRegistrationRequestImplFromJson(
            Map<String, dynamic> json) =>
        _$AdvocateClerkRegistrationRequestImpl(
          requestInfo: AdvocateRequestInfo.fromJson(
              json['RequestInfo'] as Map<String, dynamic>),
          clerks: (json['clerks'] as List<dynamic>)
              .map((e) => Clerk.fromJson(e as Map<String, dynamic>))
              .toList(),
        );

Map<String, dynamic> _$$AdvocateClerkRegistrationRequestImplToJson(
        _$AdvocateClerkRegistrationRequestImpl instance) =>
    <String, dynamic>{
      'RequestInfo': instance.requestInfo,
      'clerks': instance.clerks,
    };

_$AdvocateClerkRegistrationResponseImpl
    _$$AdvocateClerkRegistrationResponseImplFromJson(
            Map<String, dynamic> json) =>
        _$AdvocateClerkRegistrationResponseImpl(
          responseInfo: json['responseInfo'] == null
              ? const ResponseInfoSearch(status: "")
              : ResponseInfoSearch.fromJson(
                  json['responseInfo'] as Map<String, dynamic>),
          clerks: (json['clerks'] as List<dynamic>)
              .map((e) => Clerk.fromJson(e as Map<String, dynamic>))
              .toList(),
        );

Map<String, dynamic> _$$AdvocateClerkRegistrationResponseImplToJson(
        _$AdvocateClerkRegistrationResponseImpl instance) =>
    <String, dynamic>{
      'responseInfo': instance.responseInfo,
      'clerks': instance.clerks,
    };
