import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:publicschool_app/di/app_injector.dart';
import 'package:publicschool_app/di/i_register_dashboard.dart';
import 'package:publicschool_app/utilities/ps_colors.dart';

class SplashScreen extends StatefulWidget {

  @override
  SplashSreenState  createState() => SplashSreenState();

}
class SplashSreenState extends State<SplashScreen> {

  void initState() {
    super.initState();
    Timer(Duration(seconds: 5),
            ()=>Get.to(AppInjector.instance.dashboard)
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: PSColors.app_color,
      child: Image.network('https://kyzens.com/dev/eschool/web/mobile-images/startup-images/img-3.png'),

    );

  }

}