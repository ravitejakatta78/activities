
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:publicschool_app/helper/logger/logger.dart';
import 'package:publicschool_app/pages/dairy/widgets/dairy_item.dart';

import '../../common/widgets/container_widget/container_widget.dart';

part 'dairy_list.g.dart';


@JsonSerializable(fieldRename: FieldRename.snake)
class DairyList{
  String? status;
  String? message;
  List<Dairy>? data;

  DairyList(this.status, this.message, this.data);
  factory DairyList.fromJson(Map<String,dynamic> json) => _$DairyListFromJson(json);

}
@JsonSerializable(fieldRename: FieldRename.snake)
class Dairy {

  String? id;
  String? schoolId;
  String? classId;
  String? sectionId;
  String? dairyDate;
  String? subjectId;
  String? taskDescription;
  String? createdBy;
  String? className;
  @JsonKey(defaultValue: "")
  String? sectionName;
  String? subjectName;

  Dairy(
      this.id,
      this.schoolId,
      this.classId,
      this.sectionId,
      this.dairyDate,
      this.subjectId,
      this.taskDescription,
      this.createdBy,
      this.className,
      this.sectionName,
      this.subjectName);


  factory Dairy.fromJson(Map<String,dynamic> json) => _$DairyFromJson(json);

}
class DairyContainer extends ContainerWithWidget {
  List<Dairy>? dairyList;
  String? stringDate;
  String? userId;
  Function(int type,Dairy? dairy)? onCallBack;
  DairyContainer({this.stringDate,this.userId,this.onCallBack,required this.dairyList});
  @override
  Widget? getContainer() {
    printLog("dairyList length ", dairyList!.length);
    return (dairyList!=null)?DairyItem(dairyList: dairyList,stringDate:stringDate,userId: userId,onCallback: onCallBack,):Text('No Data');
  }

}
