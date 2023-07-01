// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exams_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamsList _$ExamsListFromJson(Map<String, dynamic> json) => ExamsList(
      json['exam_id'] as String?,
      json['class_name'] as String?,
      json['class_id'] as String?,
      json['exam_name'] as String?,
      json['exam_start_date'] as String?,
      json['exam_end_date'] as String?,
      json['section_name'] as String?,
      json['section_id'] as String?,
    );

Map<String, dynamic> _$ExamsListToJson(ExamsList instance) => <String, dynamic>{
      'exam_id': instance.examId,
      'class_name': instance.className,
      'class_id': instance.classId,
      'exam_name': instance.examName,
      'exam_start_date': instance.examStartDate,
      'exam_end_date': instance.examEndDate,
      'section_name': instance.sectionName,
      'section_id': instance.sectionId,
    };
