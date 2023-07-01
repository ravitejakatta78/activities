
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:publicschool_app/helper/logger/logger.dart';

import '../../../utilities/ps_colors.dart';

void sessionsBottomSheet({Function(String? string)? onCallback,int? radioValue}){

  showModalBottomSheet(context: Get.context!, builder: (BuildContext context){
   
    return StatefulBuilder(
        builder: (BuildContext context, setState) => Container(
        color: PSColors.bg_color,
        height: 90,
        alignment: Alignment.center,

         child:  Row(
           mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
             Radio(
               value: 0,
               groupValue: radioValue,
               activeColor: PSColors.app_color,
               onChanged: (int? value) {
                 setState(() {
                   onCallback!("1");
                   radioValue = value!;
                   Navigator.pop(context);
                 });

               },
             ),
             Text('Morning', style: TextStyle(fontSize:18 ,color: PSColors.text_color),
             ),
             Radio(
               value: 1,
               groupValue: radioValue,
               activeColor: PSColors.app_color,
               onChanged: (int? value) {
                 setState(() {
                   radioValue = value!;
                   onCallback!("2");
                   Navigator.pop(context);

                 });

               },
             ),
             Text(
               'Afternoon',
               style:TextStyle(fontSize:18 ,color: PSColors.text_color),
             ),
           ],
         ),

    ),
    );
  });
}

