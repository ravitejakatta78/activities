
import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../common/widgets/container_widget/container_widget.dart';
import '../../pages/leaves/widgets/leave_item.dart';

part 'leaves_list.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class LeavesList {
  String? status;
  String? message;
  List<Leave>? data;

  LeavesList(this.status, this.message, this.data);
  factory LeavesList.fromJson(Map<String,dynamic> json) => _$LeavesListFromJson(json);

}
@JsonSerializable(fieldRename: FieldRename.snake)
class Leave {
  String? id;
  String? schoolId;
  String? facultyId;
  String? facultyName;
  String? leaveRequestId;
  String? leaveType;
  String? startDate;
  String? endDate;
  String? leaveRange;
  String? leaveReason;
  String? leaveStatus;
  String? leaveComments;
  String? createdOn;
  String? updatedOn;
  String? updatedBy;
  String? regDate;
  String? leaveStatusText;
  int? roleId;


  Leave(
      this.id,
      this.schoolId,
      this.facultyId,
      this.leaveType,
      this.startDate,
      this.endDate,
      this.leaveRange,
      this.leaveReason,
      this.leaveStatus,
      this.leaveComments,
      this.createdOn,
      this.updatedOn,
      this.updatedBy,
      this.leaveStatusText,
      this.facultyName,
      this.leaveRequestId,
      this.roleId,
      this.regDate);

  factory Leave.fromJson(Map<String,dynamic> json) => _$LeaveFromJson(json);
}
class LeaveListContainer extends ContainerWithWidget {
  Leave? leave;
  String? userId;
  Function(int type,Leave? leave)? onCallBack;
  LeaveListContainer({this.leave,this.userId,this.onCallBack});
  @override
  Widget? getContainer() {
    return LeaveItem(leave:leave,userId:userId,onCallback:onCallBack);
  }

}

