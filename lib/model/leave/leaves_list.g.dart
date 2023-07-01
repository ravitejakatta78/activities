// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaves_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeavesList _$LeavesListFromJson(Map<String, dynamic> json) => LeavesList(
      json['status'] as String?,
      json['message'] as String?,
      (json['data'] as List<dynamic>?)
          ?.map((e) => Leave.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LeavesListToJson(LeavesList instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

Leave _$LeaveFromJson(Map<String, dynamic> json) => Leave(
      json['id'] as String?,
      json['school_id'] as String?,
      json['faculty_id'] as String?,
      json['leave_type'] as String?,
      json['start_date'] as String?,
      json['end_date'] as String?,
      json['leave_range'] as String?,
      json['leave_reason'] as String?,
      json['leave_status'] as String?,
      json['leave_comments'] as String?,
      json['created_on'] as String?,
      json['updated_on'] as String?,
      json['updated_by'] as String?,
      json['leave_status_text'] as String?,
      json['faculty_name'] as String?,
      json['leave_request_id'] as String?,
      json['role_id'] as int?,
      json['reg_date'] as String?,
    );

Map<String, dynamic> _$LeaveToJson(Leave instance) => <String, dynamic>{
      'id': instance.id,
      'school_id': instance.schoolId,
      'faculty_id': instance.facultyId,
      'faculty_name': instance.facultyName,
      'leave_request_id': instance.leaveRequestId,
      'leave_type': instance.leaveType,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'leave_range': instance.leaveRange,
      'leave_reason': instance.leaveReason,
      'leave_status': instance.leaveStatus,
      'leave_comments': instance.leaveComments,
      'created_on': instance.createdOn,
      'updated_on': instance.updatedOn,
      'updated_by': instance.updatedBy,
      'reg_date': instance.regDate,
      'leave_status_text': instance.leaveStatusText,
      'role_id': instance.roleId,
    };
