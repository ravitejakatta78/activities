import 'package:json_annotation/json_annotation.dart';
part 'dashboard_data.g.dart';
@JsonSerializable()
class DashboardData{
  String? action;
  String? usersid;

  DashboardData(this.action, this.usersid);
  Map<String,dynamic> toMap(){
    return{
      'action':action,
      'usersid':usersid,

    };

  }

  factory DashboardData.fromJson(Map<String,dynamic> json) => _$DashboardDataFromJson(json);

  Map<String,dynamic> toJson()=> _$DashboardDataToJson(this);
}