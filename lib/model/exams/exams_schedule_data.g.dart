// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exams_schedule_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamsScheduleData _$ExamsScheduleDataFromJson(Map<String, dynamic> json) =>
    ExamsScheduleData(
      json['status'] as String?,
      (json['examScheduleList'] as List<dynamic>?)
          ?.map((e) => ExamScheduleList.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['exam_name'] as String?,
      json['class_name'] as String?,
      json['exam_start_date'] as String?,
      json['exam_end_date'] as String?,
      json['message'] as String?,
    );

Map<String, dynamic> _$ExamsScheduleDataToJson(ExamsScheduleData instance) =>
    <String, dynamic>{
      'status': instance.status,
      'examScheduleList': instance.examScheduleList,
      'exam_name': instance.exam_name,
      'class_name': instance.class_name,
      'exam_start_date': instance.exam_start_date,
      'exam_end_date': instance.exam_end_date,
      'message': instance.message,
    };

ExamScheduleList _$ExamScheduleListFromJson(Map<String, dynamic> json) =>
    ExamScheduleList(
      json['id'] as String?,
      json['exam_date'] as String?,
      json['subject_name'] as String?,
    );

Map<String, dynamic> _$ExamScheduleListToJson(ExamScheduleList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'exam_date': instance.examDate,
      'subject_name': instance.subjectName,
    };
