
import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:publicschool_app/pages/time_table/widgets/timetable_item.dart';

import '../../common/widgets/container_widget/container_widget.dart';
import '../../pages/leaves/widgets/leave_item.dart';

part 'get_time_table.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TimeTableList {
  String? status;
  String? message;
  List<TimeTable>? data;

  TimeTableList(this.status, this.message, this.data);
  factory TimeTableList.fromJson(Map<String,dynamic> json) => _$TimeTableListFromJson(json);

}
@JsonSerializable(fieldRename: FieldRename.snake)
class TimeTable{
  String? id;
  String? schoolId;
  String? classId;
  String? sectionId;
  String? dayId;
  String? facultyId;
  String? sessionName;
  String? sessionTime;
  String? createdBy;
  String? createdOn;
  String? updatedBy;
  String? updatedOn;
  String? className;
  String? sectionName;
  String? faculityName;


  TimeTable(this.id, this.schoolId, this.classId, this.sectionId, this.dayId, this.facultyId, this.sessionName, this.sessionTime, this.createdBy,
      this.createdOn, this.updatedBy, this.updatedOn, this.className, this.sectionName,this.faculityName);
  factory TimeTable.fromJson(Map<String,dynamic> json) => _$TimeTableFromJson(json);


}

class TimeTableContainer extends ContainerWithWidget {
  TimeTable? timeTable;
  String? userId;
  String colorData;
  Function(int type,TimeTable? leave)? onCallBack;
  TimeTableContainer({this.timeTable,this.userId,required this.colorData,this.onCallBack});
  @override
  Widget? getContainer() {
    return (timeTable!=null)?TimeTableItem(timeTable: timeTable,userId: userId,onCallback: onCallBack,colorData: colorData,):Text('No Data');
  }

}

