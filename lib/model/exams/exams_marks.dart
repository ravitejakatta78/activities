
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
part 'exams_marks.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ExamsMarksData {
  String? status;
  ExamDetails? examDetails;
  ExamsMarksData(this.status, this.examDetails);
  factory ExamsMarksData.fromJson(Map<String,dynamic> json) => _$ExamsMarksDataFromJson(json);

}
@JsonSerializable(fieldRename: FieldRename.snake)
class ExamDetails {
  String? examId;
  String? examName;
  dynamic totalMarks;
  List<SubjectMarks>? subjectMarks;
  ExamDetails(this.examId, this.examName, this.totalMarks, this.subjectMarks);

  factory ExamDetails.fromJson(Map<String,dynamic> json) => _$ExamDetailsFromJson(json);

}
@JsonSerializable(fieldRename: FieldRename.snake)
class SubjectMarks {
  String? subjectId;
  String? subjectName;
  dynamic marks;

  SubjectMarks(this.subjectId, this.subjectName, this.marks);
  factory SubjectMarks.fromJson(Map<String,dynamic> json) => _$SubjectMarksFromJson(json);


}