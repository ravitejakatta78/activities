import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
part 'dashboard_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class DashboardResponse {
  final String? status;
  final DashboardDetails? data;
  final String? message;

  DashboardResponse({this.status , this.data,this.message});
  factory DashboardResponse.fromJson(Map<String,dynamic> json) => _$DashboardResponseFromJson(json);


}
@JsonSerializable()
class DashboardDetails {

  List<Features>? features;
  AttendanceStatics attendanceStatics;
  List<String>? scroolImages;
  List<AttendanceFeatures>? attendanceFeatures;

  DashboardDetails(
      this.features,
      this.attendanceStatics,this.scroolImages,this.attendanceFeatures

    );

  factory DashboardDetails.fromJson(Map<String,dynamic> json) => _$DashboardDetailsFromJson(json);
  Map<String,dynamic> toJson()=> _$DashboardDetailsToJson(this);

}
@JsonSerializable()
class AttendanceStatics {
  int? totalStudents;
  int? totalFaculty;
  int? attendedStudents;
  int? attendedFaculty;

  AttendanceStatics(this.totalStudents, this.totalFaculty,
      this.attendedStudents, this.attendedFaculty);

  factory AttendanceStatics.fromJson(Map<String,dynamic> json) => _$AttendanceStaticsFromJson(json);
  Map<String,dynamic> toJson()=> _$AttendanceStaticsToJson(this);

}
@JsonSerializable()
class Features {
  String? id;
  String? name;
  String? image;
  String? bg_color;

  Features(this.id, this.name, this.image,this.bg_color);

  factory Features.fromJson(Map<String,dynamic> json) => _$FeaturesFromJson(json);
  Map<String,dynamic> toJson()=> _$FeaturesToJson(this);

}

@JsonSerializable()
class AttendanceFeatures {
  String? id;
  String? name;
  String? image;

  AttendanceFeatures(this.id, this.name, this.image);

  factory AttendanceFeatures.fromJson(Map<String,dynamic> json) => _$AttendanceFeaturesFromJson(json);
  Map<String,dynamic> toJson()=> _$AttendanceFeaturesToJson(this);

}