import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:publicschool_app/helper/logger/logger.dart';
import 'package:publicschool_app/pages/dairy/widgets/dairy_item.dart';

import '../../common/widgets/container_widget/container_widget.dart';
import '../../pages/Fees/widgets/fees_item.dart';

part 'fees_list.g.dart';


@JsonSerializable(fieldRename: FieldRename.snake)
class FeesList{
  int? status;
  List<Fees>? data;

  FeesList(this.status, this.data);
  factory FeesList.fromJson(Map<String,dynamic> json) => _$FeesListFromJson(json);

}

@JsonSerializable(fieldRename: FieldRename.snake)
class Fees {
  String? feeId;
  String? studentName;
  String? className;
  String? sectionName;
  String? classId;
  String? sectionId;
  String? paidDate;
  String? feeType;
  String? amount;

  Fees(this.feeId, this.studentName, this.className, this.sectionName,this.classId,this.sectionId,
      this.paidDate, this.feeType, this.amount);

  factory Fees.fromJson(Map<String,dynamic> json) => _$FeesFromJson(json);

}
class FeesContainer extends ContainerWithWidget {
  Fees? feesList;
  String? userId;
  Function(int type,Fees? feesList)? onCallBack;
  FeesContainer({this.feesList,this.userId,this.onCallBack});
  @override
  Widget? getContainer() {
    return (feesList!=null)?FeesItem(feesList: feesList,userId: userId,onCallBack: onCallBack,):Text('No Data');
  }

}