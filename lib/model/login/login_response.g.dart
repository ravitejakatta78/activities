// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      status: json['status'] as String?,
      userDetails: json['user_details'] == null
          ? null
          : UserDetails.fromJson(json['user_details'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'user_details': instance.userDetails,
      'message': instance.message,
    };

UserDetails _$UserDetailsFromJson(Map<String, dynamic> json) => UserDetails(
      json['usersid'] as String?,
      json['user_name'] as String?,
      json['first_name'] as String?,
      json['last_name'] as String?,
      json['email'] as String?,
      json['mobile'] as String?,
      json['role_id'] as String?,
      json['gender'] as String?,
      json['img_url'] as String?,
      json['school_id'] as String?,
      json['school_name'] as String?,
      json['school_address'] as String?,
      json['school_email'] as String?,
      json['school_mobile'] as String?,
      json['role_name'] as String?,
      json['token'] as String?,
      json['faculity_id'] as String?,
    );

Map<String, dynamic> _$UserDetailsToJson(UserDetails instance) =>
    <String, dynamic>{
      'usersid': instance.usersid,
      'user_name': instance.userName,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'mobile': instance.mobile,
      'role_id': instance.roleId,
      'gender': instance.gender,
      'img_url': instance.imgUrl,
      'school_id': instance.schoolId,
      'school_name': instance.schoolName,
      'school_address': instance.schoolAddress,
      'school_email': instance.schoolEmail,
      'school_mobile': instance.schoolMobile,
      'faculity_id': instance.faculityId,
      'role_name': instance.roleName,
      'token': instance.token,
    };
