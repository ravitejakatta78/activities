
import 'package:json_annotation/json_annotation.dart';
part 'faculty_list_data.g.dart';

@JsonSerializable()
class FacultyListData{
  final String? status;
  final String? message;
  final List<FacultyAttendanceHistory>? data;
   FacultyListData({this.status,this.data,this.message});
   factory FacultyListData.fromJson(Map<String,dynamic> json) => _$FacultyListDataFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class FacultyAttendanceHistory {
  String? id;
  String faculityId;
  String? attendanceStatus;
  String? schoolId;
  String? attendanceDate;
  String? login;
  String? logout;
  String? createdOn;
  String? createdBy;
  String? updatedOn;
  String? updatedBy;
  String? faculityName;
  String? userId;

  FacultyAttendanceHistory(this.id, this.faculityId, this.attendanceStatus,
      this.schoolId, this.attendanceDate, this.login, this.logout,
      this.createdOn, this.createdBy, this.updatedOn, this.updatedBy,
      this.faculityName, this.userId);

  factory FacultyAttendanceHistory.fromJson(Map<String,dynamic> json) => _$FacultyAttendanceHistoryFromJson(json);

}
