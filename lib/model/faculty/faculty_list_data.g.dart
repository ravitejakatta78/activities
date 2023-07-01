// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faculty_list_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FacultyListData _$FacultyListDataFromJson(Map<String, dynamic> json) =>
    FacultyListData(
      status: json['status'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) =>
              FacultyAttendanceHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$FacultyListDataToJson(FacultyListData instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

FacultyAttendanceHistory _$FacultyAttendanceHistoryFromJson(
        Map<String, dynamic> json) =>
    FacultyAttendanceHistory(
      json['id'] as String?,
      json['faculity_id'] as String,
      json['attendance_status'] as String?,
      json['school_id'] as String?,
      json['attendance_date'] as String?,
      json['login'] as String?,
      json['logout'] as String?,
      json['created_on'] as String?,
      json['created_by'] as String?,
      json['updated_on'] as String?,
      json['updated_by'] as String?,
      json['faculity_name'] as String?,
      json['user_id'] as String?,
    );

Map<String, dynamic> _$FacultyAttendanceHistoryToJson(
        FacultyAttendanceHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'faculity_id': instance.faculityId,
      'attendance_status': instance.attendanceStatus,
      'school_id': instance.schoolId,
      'attendance_date': instance.attendanceDate,
      'login': instance.login,
      'logout': instance.logout,
      'created_on': instance.createdOn,
      'created_by': instance.createdBy,
      'updated_on': instance.updatedOn,
      'updated_by': instance.updatedBy,
      'faculity_name': instance.faculityName,
      'user_id': instance.userId,
    };
