// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exams_marks.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamsMarksData _$ExamsMarksDataFromJson(Map<String, dynamic> json) =>
    ExamsMarksData(
      json['status'] as String?,
      json['exam_details'] == null
          ? null
          : ExamDetails.fromJson(json['exam_details'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ExamsMarksDataToJson(ExamsMarksData instance) =>
    <String, dynamic>{
      'status': instance.status,
      'exam_details': instance.examDetails,
    };

ExamDetails _$ExamDetailsFromJson(Map<String, dynamic> json) => ExamDetails(
      json['exam_id'] as String?,
      json['exam_name'] as String?,
      json['total_marks'],
      (json['subject_marks'] as List<dynamic>?)
          ?.map((e) => SubjectMarks.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ExamDetailsToJson(ExamDetails instance) =>
    <String, dynamic>{
      'exam_id': instance.examId,
      'exam_name': instance.examName,
      'total_marks': instance.totalMarks,
      'subject_marks': instance.subjectMarks,
    };

SubjectMarks _$SubjectMarksFromJson(Map<String, dynamic> json) => SubjectMarks(
      json['subject_id'] as String?,
      json['subject_name'] as String?,
      json['marks'],
    );

Map<String, dynamic> _$SubjectMarksToJson(SubjectMarks instance) =>
    <String, dynamic>{
      'subject_id': instance.subjectId,
      'subject_name': instance.subjectName,
      'marks': instance.marks,
    };
