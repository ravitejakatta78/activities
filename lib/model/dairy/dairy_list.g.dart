// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dairy_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DairyList _$DairyListFromJson(Map<String, dynamic> json) => DairyList(
      json['status'] as String?,
      json['message'] as String?,
      (json['data'] as List<dynamic>?)
          ?.map((e) => Dairy.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DairyListToJson(DairyList instance) => <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

Dairy _$DairyFromJson(Map<String, dynamic> json) => Dairy(
      json['id'] as String?,
      json['school_id'] as String?,
      json['class_id'] as String?,
      json['section_id'] as String?,
      json['dairy_date'] as String?,
      json['subject_id'] as String?,
      json['task_description'] as String?,
      json['created_by'] as String?,
      json['class_name'] as String?,
      json['section_name'] as String? ?? '',
      json['subject_name'] as String?,
    );

Map<String, dynamic> _$DairyToJson(Dairy instance) => <String, dynamic>{
      'id': instance.id,
      'school_id': instance.schoolId,
      'class_id': instance.classId,
      'section_id': instance.sectionId,
      'dairy_date': instance.dairyDate,
      'subject_id': instance.subjectId,
      'task_description': instance.taskDescription,
      'created_by': instance.createdBy,
      'class_name': instance.className,
      'section_name': instance.sectionName,
      'subject_name': instance.subjectName,
    };
