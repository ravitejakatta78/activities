import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:publicschool_app/helper/logger/logger.dart';
import 'package:publicschool_app/pages/dairy/widgets/dairy_item.dart';

import '../../common/widgets/container_widget/container_widget.dart';
import '../../pages/Fees/widgets/fees_item.dart';

part 'fee_types_list.g.dart';


@JsonSerializable(fieldRename: FieldRename.snake)
class FeesTypesList{
  String? status;
  List<FeeTypes>? data;

  FeesTypesList(this.status, this.data);
  factory FeesTypesList.fromJson(Map<String,dynamic> json) => _$FeesTypesListFromJson(json);

}

@JsonSerializable(fieldRename: FieldRename.snake)
class FeeTypes {
  int? id;
  int? schoolId;
  int? classId;
  int? feeType;
  String? feeName;
  int? feeAmount;
  int? feeStatus;
  int? createdBy;
  String? createdOn;
  FeeTypes(this.id, this.schoolId, this.classId, this.feeType, this.feeName,
      this.feeAmount, this.feeStatus, this.createdBy, this.createdOn);

  factory FeeTypes.fromJson(Map<String,dynamic> json) => _$FeeTypesFromJson(json);







}