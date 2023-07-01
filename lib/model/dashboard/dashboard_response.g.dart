// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardResponse _$DashboardResponseFromJson(Map<String, dynamic> json) =>
    DashboardResponse(
      status: json['status'] as String?,
      data: json['data'] == null
          ? null
          : DashboardDetails.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$DashboardResponseToJson(DashboardResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
      'message': instance.message,
    };

DashboardDetails _$DashboardDetailsFromJson(Map<String, dynamic> json) =>
    DashboardDetails(
      (json['features'] as List<dynamic>?)
          ?.map((e) => Features.fromJson(e as Map<String, dynamic>))
          .toList(),
      AttendanceStatics.fromJson(
          json['attendanceStatics'] as Map<String, dynamic>),
      (json['scroolImages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      (json['attendanceFeatures'] as List<dynamic>?)
          ?.map((e) => AttendanceFeatures.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DashboardDetailsToJson(DashboardDetails instance) =>
    <String, dynamic>{
      'features': instance.features,
      'attendanceStatics': instance.attendanceStatics,
      'scroolImages': instance.scroolImages,
      'attendanceFeatures': instance.attendanceFeatures,
    };

AttendanceStatics _$AttendanceStaticsFromJson(Map<String, dynamic> json) =>
    AttendanceStatics(
      json['totalStudents'] as int?,
      json['totalFaculty'] as int?,
      json['attendedStudents'] as int?,
      json['attendedFaculty'] as int?,
    );

Map<String, dynamic> _$AttendanceStaticsToJson(AttendanceStatics instance) =>
    <String, dynamic>{
      'totalStudents': instance.totalStudents,
      'totalFaculty': instance.totalFaculty,
      'attendedStudents': instance.attendedStudents,
      'attendedFaculty': instance.attendedFaculty,
    };

Features _$FeaturesFromJson(Map<String, dynamic> json) => Features(
      json['id'] as String?,
      json['name'] as String?,
      json['image'] as String?,
      json['bg_color'] as String?,
    );

Map<String, dynamic> _$FeaturesToJson(Features instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'bg_color': instance.bg_color,
    };

AttendanceFeatures _$AttendanceFeaturesFromJson(Map<String, dynamic> json) =>
    AttendanceFeatures(
      json['id'] as String?,
      json['name'] as String?,
      json['image'] as String?,
    );

Map<String, dynamic> _$AttendanceFeaturesToJson(AttendanceFeatures instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
    };
