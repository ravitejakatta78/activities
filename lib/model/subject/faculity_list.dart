import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../common/widgets/container_widget/container_widget.dart';
import '../../pages/faculty/widgets/faculty_item.dart';
import '../../pages/subject/widgets/faculty_item.dart';
part 'faculity_list.g.dart';
@JsonSerializable(fieldRename: FieldRename.snake)
class FaculityList{
  String? id;
  String? faculityName;
  String? address;
  String? qualification;
  String? subjectId;
  String? schoolId;
  String? email;
  String? mobile;
  String? gender;
  String? faculityPic;

  FaculityList(
      this.id,
      this.faculityName,
      this.address,
      this.qualification,
      this.subjectId,
      this.schoolId,
      this.email,
      this.mobile,
      this.gender,
      this.faculityPic);

  factory FaculityList.fromJson(Map<String,dynamic> json) => _$FaculityListFromJson(json);

}

class FacultyContainer extends ContainerWithWidget {
  FaculityList? facultyList;
  Function(int type,FaculityList facultyList)?  onCallback;
  FacultyContainer({this.facultyList,this.onCallback});
  @override
  Widget? getContainer() {
    return (facultyList!=null)?FacultyItem(facultyList:facultyList,onCallback: onCallback,):Text('No data');
  }

}