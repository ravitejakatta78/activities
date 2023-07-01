// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_time_table.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeTableList _$TimeTableListFromJson(Map<String, dynamic> json) =>
    TimeTableList(
      json['status'] as String?,
      json['message'] as String?,
      (json['data'] as List<dynamic>?)
          ?.map((e) => TimeTable.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TimeTableListToJson(TimeTableList instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

TimeTable _$TimeTableFromJson(Map<String, dynamic> json) => TimeTable(
      json['id'] as String?,
      json['school_id'] as String?,
      json['class_id'] as String?,
      json['section_id'] as String?,
      json['day_id'] as String?,
      json['faculty_id'] as String?,
      json['session_name'] as String?,
      json['session_time'] as String?,
      json['created_by'] as String?,
      json['created_on'] as String?,
      json['updated_by'] as String?,
      json['updated_on'] as String?,
      json['class_name'] as String?,
      json['section_name'] as String?,
      json['faculity_name'] as String?,
    );

Map<String, dynamic> _$TimeTableToJson(TimeTable instance) => <String, dynamic>{
      'id': instance.id,
      'school_id': instance.schoolId,
      'class_id': instance.classId,
      'section_id': instance.sectionId,
      'day_id': instance.dayId,
      'faculty_id': instance.facultyId,
      'session_name': instance.sessionName,
      'session_time': instance.sessionTime,
      'created_by': instance.createdBy,
      'created_on': instance.createdOn,
      'updated_by': instance.updatedBy,
      'updated_on': instance.updatedOn,
      'class_name': instance.className,
      'section_name': instance.sectionName,
      'faculity_name': instance.faculityName,
    };
