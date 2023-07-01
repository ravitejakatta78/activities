import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:publicschool_app/utilities/ps_colors.dart';
import 'package:toast/toast.dart';

void ToastMessage (String msg){
  Toast.show(msg, duration: Toast.lengthShort, gravity:  Toast.bottom,backgroundColor:PSColors.app_color,webTexColor: Colors.white,
  backgroundRadius: 20);

}

