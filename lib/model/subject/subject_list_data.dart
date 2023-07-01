import 'package:flutter/src/widgets/framework.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:publicschool_app/common/widgets/container_widget/container_widget.dart';
import 'package:publicschool_app/model/sections/sections_data.dart';
import 'package:publicschool_app/model/subject/student.dart';
import 'package:publicschool_app/model/subject/student_list.dart';
import 'package:publicschool_app/pages/subject/widgets/class_item.dart';

import '../../pages/subject/widgets/subject_item.dart';
import '../exams/exams_data.dart';
import '../login/login_response.dart';
import 'faculity_list.dart';
part 'subject_list_data.g.dart';

@JsonSerializable()
class SubjectListData{
  final String? status;
  final List<SubjectList>? subjectList;
  final List<ClassList>? classList;
  final List<FaculityList>? faculityList;
  final List<StudentList>? studentList;
  final List<ExamsList>? examList;
  final List<SectionsList>? sectionList;
  final List<Student>? data;
  final String? message;
  final UserDetails? user_details;

  SubjectListData({this.status , this.subjectList,this.classList,this.faculityList,
    this.studentList,this.examList,this.sectionList,this.message,this.data,this.user_details});
  factory SubjectListData.fromJson(Map<String,dynamic> json) => _$SubjectListDataFromJson(json);

}

@JsonSerializable(fieldRename: FieldRename.snake)
class ClassList {
  String? classId;
  String? className;
  String? faculityName;
  ClassList({this.classId, this.className, this.faculityName});
  factory ClassList.fromJson(Map<String,dynamic> json) => _$ClassListFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class SubjectList {
  String? id;
  String? schoolId;
  String? subjectName;
  SubjectList({this.id, this.schoolId, this.subjectName});
  factory SubjectList.fromJson(Map<String,dynamic> json) => _$SubjectListFromJson(json);

}

class SubjectContainer extends ContainerWithWidget {
  SubjectList? subjectList;
  SubjectContainer({this.subjectList});
  @override
  Widget? getContainer() {
   return SubjectItem(subject:subjectList);
  }

}

class ClassContainer extends ContainerWithWidget {
  ClassList classList;
  ClassContainer({required this.classList});
  @override
  Widget? getContainer() {
    return ClassItem(classList:classList);

  }

}