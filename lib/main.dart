import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:publicschool_app/di/app_injector.dart';
import 'package:publicschool_app/utilities/ps_colors.dart';


void main() {
  runApp( MaterialApp(home: AppInjector.instance.app));
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: PSColors.app_color, // status bar color
  ));

}


