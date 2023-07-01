// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject_list_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubjectListData _$SubjectListDataFromJson(Map<String, dynamic> json) =>
    SubjectListData(
      status: json['status'] as String?,
      subjectList: (json['subjectList'] as List<dynamic>?)
          ?.map((e) => SubjectList.fromJson(e as Map<String, dynamic>))
          .toList(),
      classList: (json['classList'] as List<dynamic>?)
          ?.map((e) => ClassList.fromJson(e as Map<String, dynamic>))
          .toList(),
      faculityList: (json['faculityList'] as List<dynamic>?)
          ?.map((e) => FaculityList.fromJson(e as Map<String, dynamic>))
          .toList(),
      studentList: (json['studentList'] as List<dynamic>?)
          ?.map((e) => StudentList.fromJson(e as Map<String, dynamic>))
          .toList(),
      examList: (json['examList'] as List<dynamic>?)
          ?.map((e) => ExamsList.fromJson(e as Map<String, dynamic>))
          .toList(),
      sectionList: (json['sectionList'] as List<dynamic>?)
          ?.map((e) => SectionsList.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Student.fromJson(e as Map<String, dynamic>))
          .toList(),
      user_details: json['user_details'] == null
          ? null
          : UserDetails.fromJson(json['user_details'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SubjectListDataToJson(SubjectListData instance) =>
    <String, dynamic>{
      'status': instance.status,
      'subjectList': instance.subjectList,
      'classList': instance.classList,
      'faculityList': instance.faculityList,
      'studentList': instance.studentList,
      'examList': instance.examList,
      'sectionList': instance.sectionList,
      'data': instance.data,
      'message': instance.message,
      'user_details': instance.user_details,
    };

ClassList _$ClassListFromJson(Map<String, dynamic> json) => ClassList(
      classId: json['class_id'] as String?,
      className: json['class_name'] as String?,
      faculityName: json['faculity_name'] as String?,
    );

Map<String, dynamic> _$ClassListToJson(ClassList instance) => <String, dynamic>{
      'class_id': instance.classId,
      'class_name': instance.className,
      'faculity_name': instance.faculityName,
    };

SubjectList _$SubjectListFromJson(Map<String, dynamic> json) => SubjectList(
      id: json['id'] as String?,
      schoolId: json['school_id'] as String?,
      subjectName: json['subject_name'] as String?,
    );

Map<String, dynamic> _$SubjectListToJson(SubjectList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'school_id': instance.schoolId,
      'subject_name': instance.subjectName,
    };
