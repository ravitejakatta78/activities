import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:publicschool_app/common/widgets/container_widget/container_widget.dart';
import '../../pages/students/widgets/student_item.dart';
part 'student_list.g.dart';
@JsonSerializable(fieldRename: FieldRename.snake)
class StudentList {
  String? id;
  String? schoolId;
  String? roleId;
  String? status;
  String? firstName;
  String? lastName;
  String? gender;
  String? dob;
  String? address;
  String? rollNumber;
  String? bloodGroup;
  String? religion;
  String? studentClass;
  String? studentSection;
  String? admissionId;
  String? studentImage;
  String? parentId;
  String? createdBy;
  String? updatedBy;
  String? createdOn;
  String? updatedOn;
  String? regDate;
  String? studentImg;
  String? parentName;
  String? parentTypeText;
  String occupation;
  String? email;
  String? mobile;
  String? className;
  String? sectionName;
  String? parentUserId;


  StudentList(this.id, this.schoolId, this.roleId, this.status, this.firstName, this.lastName, this.gender,
      this.dob, this.address, this.rollNumber, this.bloodGroup, this.religion, this.studentClass, this.studentSection, this.admissionId, this.studentImage,
      this.parentId, this.createdBy, this.updatedBy, this.createdOn, this.updatedOn, this.regDate, this.studentImg,this.parentName,this.parentTypeText,
      this.occupation,this.mobile,this.email,this.className,this.sectionName,this.parentUserId);

  factory StudentList.fromJson(Map<String,dynamic> json) => _$StudentListFromJson(json);

}
class StudentListContainer extends ContainerWithWidget {
  StudentList? studentList;
  Function(int type,StudentList studentList)?  onCallback;
  StudentListContainer({this.studentList,this.onCallback});
 @override
  Widget? getContainer() {
    return (studentList!=null)?StudentItem(studentList:studentList,onCallback: onCallback,):Text('No Data');

  }
  
  
}