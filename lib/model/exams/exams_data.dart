import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../common/widgets/container_widget/container_widget.dart';
import '../../pages/exams/widgets/exam.dart';
import '../../pages/subject/widgets/faculty_item.dart';
part 'exams_data.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ExamsList{
  String? examId;
  String? className;
  String? classId;
  String? examName;
  String? examStartDate;
  String? examEndDate;
  String? sectionName;
  String? sectionId;

  ExamsList(this.examId, this.className, this.classId, this.examName,
      this.examStartDate, this.examEndDate,this.sectionName,this.sectionId);
  factory ExamsList.fromJson(Map<String,dynamic> json) => _$ExamsListFromJson(json);

}

class ExamContainer extends ContainerWithWidget {
 ExamsList examList;
  String? userId;
  Function(int type,ExamsList? exams)? onCallBack;
  ExamContainer({required this.examList,this.userId,this.onCallBack});
  @override
  Widget? getContainer() {

    return Exam(examsList: examList);

  }

}