// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fees_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeesList _$FeesListFromJson(Map<String, dynamic> json) => FeesList(
      json['status'] as int?,
      (json['data'] as List<dynamic>?)
          ?.map((e) => Fees.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FeesListToJson(FeesList instance) => <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };

Fees _$FeesFromJson(Map<String, dynamic> json) => Fees(
      json['fee_id'] as String?,
      json['student_name'] as String?,
      json['class_name'] as String?,
      json['section_name'] as String?,
      json['class_id'] as String?,
      json['section_id'] as String?,
      json['paid_date'] as String?,
      json['fee_type'] as String?,
      json['amount'] as String?,
    );

Map<String, dynamic> _$FeesToJson(Fees instance) => <String, dynamic>{
      'fee_id': instance.feeId,
      'student_name': instance.studentName,
      'class_name': instance.className,
      'section_name': instance.sectionName,
      'class_id': instance.classId,
      'section_id': instance.sectionId,
      'paid_date': instance.paidDate,
      'fee_type': instance.feeType,
      'amount': instance.amount,
    };
