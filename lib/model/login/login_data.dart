import 'package:json_annotation/json_annotation.dart';
part 'login_data.g.dart';

@JsonSerializable()
class LoginData{
  String? username;
  String? password;
  String? action;

  LoginData(this.username, this.password,this.action);
  Map<String,dynamic> toMap(){
    return{
      'username':username,
      'password':password,
      'action': action

    };

  }

  factory LoginData.fromJson(Map<String,dynamic> json) => _$LoginDataFromJson(json);

  Map<String,dynamic> toJson()=> _$LoginDataToJson(this);
}