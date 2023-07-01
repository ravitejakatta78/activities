import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'sections_data.g.dart';
@JsonSerializable(fieldRename: FieldRename.snake)
class SectionsList {
  String? sectionId;
  String? sectionName;

  SectionsList({this.sectionId,this.sectionName});
  factory SectionsList.fromJson(Map<String,dynamic> json) => _$SectionsListFromJson(json);
}