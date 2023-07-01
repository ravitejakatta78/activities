import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/cupertino.dart';

part 'exams_schedule_data.g.dart';

@JsonSerializable()
class ExamsScheduleData {
  String? status;
  List<ExamScheduleList>? examScheduleList;
  String? exam_name;
  String? class_name;

  ExamsScheduleData(this.status, this.examScheduleList, this.exam_name,
      this.class_name, this.exam_start_date, this.exam_end_date, this.message);

  String? exam_start_date;
  String? exam_end_date;
  String? message;



  factory ExamsScheduleData.fromJson(Map<String,dynamic> json) => _$ExamsScheduleDataFromJson(json);


}
@JsonSerializable(fieldRename: FieldRename.snake)
class ExamScheduleList {
  String? id;
  String? examDate;
  String? subjectName;

  ExamScheduleList(this.id, this.examDate, this.subjectName);

  factory ExamScheduleList.fromJson(Map<String,dynamic> json) => _$ExamScheduleListFromJson(json);


}