import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:publicschool_app/di/app_injector.dart';
import 'package:publicschool_app/di/i_faculity_attendance.dart';
import 'package:publicschool_app/di/i_stuAttendace.dart';
import 'package:publicschool_app/di/i_student_dairy.dart';
import 'package:publicschool_app/di/i_student_exams.dart';
import 'package:publicschool_app/di/i_subject_list.dart';
import 'package:publicschool_app/pages/attendance/student_attendance.dart';
import 'package:publicschool_app/utilities/fonts.dart';
import 'package:publicschool_app/utilities/ps_colors.dart';

import '../../../model/dashboard/dashboard_response.dart';



Widget FacultyMenuWidget(List<Features>? menu){
  return  GridView.count(
      padding: EdgeInsets.all(10),
  crossAxisCount: 3,
  childAspectRatio: (2 / 2.5),
  crossAxisSpacing: 3,
  mainAxisSpacing: 10,
  shrinkWrap: true,
  children: List.generate(menu!.length, (index) {
        return  GestureDetector(
        onTap: (){
          (menu[index].name=='Exams')?
          Get.to(AppInjector.instance.studentExamsList(1)): (menu[index].name=='Dairy')? Get.to(AppInjector.instance.studentDairyPage):Get.to(AppInjector.instance.subjects(menu[index].name!));

        },
        child:  Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: HexColor(menu[index].bg_color!),
          elevation: 3,
          shadowColor: Colors.blueGrey,
          child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 35,
                      width: 35,
                      child: CachedNetworkImage(
                        imageUrl: menu[index].image!,
                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                            CircularProgressIndicator(value: downloadProgress.progress),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),),
                  const SizedBox(height: 20,),
                  Text(menu[index].name!,textAlign:TextAlign.center,
                    style:  TextStyle(fontSize: 14,fontFamily: WorkSans.semiBold,color:Colors.white),),
                ],
              )),
        ),
      ); },

       )
  );
}

