import 'package:flutter/material.dart';
import 'package:publicschool_app/common/widgets/sch_button/sch_button.dart';
import 'package:publicschool_app/utilities/ps_colors.dart';

class ContainerAction extends StatelessWidget {
  final String? title;
  final Color? color;
  final VoidCallback? onTap;

  Color get _safeColor => color ?? PSColors.app_color;

  ContainerAction({this.title, this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return SCHCustomButton(
      title: title,
      backgroundColor: _safeColor,
      onTap: () {
        var f = onTap;
        if (f != null) f();
      },
    );
  }
}

abstract class ContainerWithWidget {
  Widget? getContainer();
}

abstract class ContainerWithAction extends ContainerWithWidget {
  List<ContainerAction> actions = [];

  Widget? additionalWidget;


}