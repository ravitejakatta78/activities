// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fee_types_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeesTypesList _$FeesTypesListFromJson(Map<String, dynamic> json) =>
    FeesTypesList(
      json['status'] as String?,
      (json['data'] as List<dynamic>?)
          ?.map((e) => FeeTypes.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FeesTypesListToJson(FeesTypesList instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };

FeeTypes _$FeeTypesFromJson(Map<String, dynamic> json) => FeeTypes(
      json['id'] as int?,
      json['school_id'] as int?,
      json['class_id'] as int?,
      json['fee_type'] as int?,
      json['fee_name'] as String?,
      json['fee_amount'] as int?,
      json['fee_status'] as int?,
      json['created_by'] as int?,
      json['created_on'] as String?,
    );

Map<String, dynamic> _$FeeTypesToJson(FeeTypes instance) => <String, dynamic>{
      'id': instance.id,
      'school_id': instance.schoolId,
      'class_id': instance.classId,
      'fee_type': instance.feeType,
      'fee_name': instance.feeName,
      'fee_amount': instance.feeAmount,
      'fee_status': instance.feeStatus,
      'created_by': instance.createdBy,
      'created_on': instance.createdOn,
    };
