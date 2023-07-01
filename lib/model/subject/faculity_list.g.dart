// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faculity_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FaculityList _$FaculityListFromJson(Map<String, dynamic> json) => FaculityList(
      json['id'] as String?,
      json['faculity_name'] as String?,
      json['address'] as String?,
      json['qualification'] as String?,
      json['subject_id'] as String?,
      json['school_id'] as String?,
      json['email'] as String?,
      json['mobile'] as String?,
      json['gender'] as String?,
      json['faculity_pic'] as String?,
    );

Map<String, dynamic> _$FaculityListToJson(FaculityList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'faculity_name': instance.faculityName,
      'address': instance.address,
      'qualification': instance.qualification,
      'subject_id': instance.subjectId,
      'school_id': instance.schoolId,
      'email': instance.email,
      'mobile': instance.mobile,
      'gender': instance.gender,
      'faculity_pic': instance.faculityPic,
    };
