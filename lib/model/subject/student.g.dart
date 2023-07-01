// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Student _$StudentFromJson(Map<String, dynamic> json) => Student(
      json['student_id'] as String?,
      json['student_name'] as String?,
      json['roll_number'] as String?,
      json['student_img'] as String?,
      json['attendance_status'] as int?,
      json['attendance_date'] as String?,
    );

Map<String, dynamic> _$StudentToJson(Student instance) => <String, dynamic>{
      'student_id': instance.studentId,
      'student_name': instance.studentName,
      'roll_number': instance.rollNumber,
      'student_img': instance.studentImg,
      'attendance_status': instance.attendanceStatus,
      'attendance_date': instance.attendanceDate,
    };
