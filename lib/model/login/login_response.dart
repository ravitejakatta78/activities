import 'package:json_annotation/json_annotation.dart';
part 'login_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class LoginResponse {
   final String? status;
   final UserDetails? userDetails;
   final String? message;

  LoginResponse({this.status , this.userDetails,this.message});
   factory LoginResponse.fromJson(Map<String,dynamic> json) => _$LoginResponseFromJson(json);

}
@JsonSerializable(fieldRename: FieldRename.snake)
class UserDetails {
  String? usersid;
  String? userName;
  String? firstName;
  String? lastName;
  String? email;
  String? mobile;
  String? roleId;
  String? gender;
  String? imgUrl;
  String? schoolId;
  String? schoolName;
  String? schoolAddress;
  String? schoolEmail;
  String? schoolMobile;
  String? faculityId;
  String? roleName;
  String? token;

  UserDetails(
      this.usersid,
      this.userName,
      this.firstName,
      this.lastName,
      this.email,
      this.mobile,
      this.roleId,
      this.gender,
      this.imgUrl,
      this.schoolId,
      this.schoolName,
      this.schoolAddress,
      this.schoolEmail,
      this.schoolMobile,
      this.roleName,
      this.token,
      this.faculityId);

  factory UserDetails.fromJson(Map<String,dynamic> json) => _$UserDetailsFromJson(json);
  Map<String,dynamic> toJson()=> _$UserDetailsToJson(this);

}