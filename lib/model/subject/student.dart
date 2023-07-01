import 'package:json_annotation/json_annotation.dart';
part 'student.g.dart';
@JsonSerializable(fieldRename: FieldRename.snake)
class Student {
  String? studentId;
  String? studentName;
  String? rollNumber;
  String? studentImg;
  int? attendanceStatus;
  String? attendanceDate;
  Student(this.studentId, this.studentName, this.rollNumber, this.studentImg,
      this.attendanceStatus, this.attendanceDate);


  factory Student.fromJson(Map<String,dynamic> json) => _$StudentFromJson(json);

  Map toJson() =>{
    'student_id':studentId,
    'student_name':studentName,
    'roll_number':rollNumber,
    'student_img':studentImg,
    'attendance_status':attendanceStatus,
    'attendance_date':attendanceDate




  };
}