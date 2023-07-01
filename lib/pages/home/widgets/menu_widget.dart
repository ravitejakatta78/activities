import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:publicschool_app/di/app_injector.dart';
import 'package:publicschool_app/di/i_faculity_attendance.dart';
import 'package:publicschool_app/di/i_leave_management.dart';
import 'package:publicschool_app/di/i_stuAttendace.dart';
import 'package:publicschool_app/di/i_student_dairy.dart';
import 'package:publicschool_app/di/i_student_exams.dart';
import 'package:publicschool_app/di/i_student_fees.dart';
import 'package:publicschool_app/di/i_subject_list.dart';
import 'package:publicschool_app/di/i_time_table.dart';
import 'package:publicschool_app/pages/attendance/student_attendance.dart';
import 'package:publicschool_app/utilities/fonts.dart';
import 'package:publicschool_app/utilities/ps_colors.dart';

import '../../../model/dashboard/dashboard_response.dart';



Widget MenuWidget(List<Features>? menu){
  return   GridView.count(
      padding: EdgeInsets.all(2),
  crossAxisCount: 4,
  childAspectRatio: (2 / 1.9),
  crossAxisSpacing: 3,
  mainAxisSpacing: 10,
  shrinkWrap: true,
  children: List.generate(menu!.length, (index) {
        return  GestureDetector(
        onTap: (){
          (menu[index].name=='Students')?
          Get.to(AppInjector.instance.studentExamsList(0)):
          (menu[index].name=='Exams')?
          Get.to(AppInjector.instance.studentExamsList(1)):(menu[index].name=='Dairy')?
          Get.to(AppInjector.instance.studentDairyPage):(menu[index].name=='Fees')?
          Get.to(AppInjector.instance.studentFeesPage):Get.to(AppInjector.instance.subjects(menu[index].name!));

        },
        child: Container(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                SizedBox(
                    height: 35,
                    width: 35,
                    child:CachedNetworkImage(
                      imageUrl: menu[index].image!,
                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                          CircularProgressIndicator(value: downloadProgress.progress),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )),
                const SizedBox(height: 10,),
                Text(menu[index].name!,textAlign:TextAlign.center,
                  style:  TextStyle(fontSize: 12,fontFamily: WorkSans.regular,color:PSColors.text_color),),
              ],
            )),
      ); },

  ) );
}


Widget AttendanceWidget(List<AttendanceFeatures>? menu){
  return   GridView.count(
      padding: EdgeInsets.all(2),
  crossAxisCount: 4,
  childAspectRatio: (2 / 1.6),
  crossAxisSpacing: 3,
  mainAxisSpacing: 10,
  shrinkWrap: true,
  children: List.generate(menu!.length, (index) {
      return  GestureDetector(
        onTap: (){
          (menu[index].name=='Students')?
          Get.to(AppInjector.instance.stuAttendance(menu[index].name!)):(menu[index].name=='Faculty')?
          Get.to(AppInjector.instance.facultyAttendance(menu[index].name!)):(menu[index].name=='Leaves')?
          Get.to(AppInjector.instance.leaveManagement):(menu[index].name=='Time Table')?
          Get.to(AppInjector.instance.timeTablePage(menu[index].name!)):SizedBox();

        },
        child: Container(
            child: Column(
              children: [
                SizedBox(
                    height: 30,
                    width: 30,
                    child: CachedNetworkImage(
                      imageUrl: menu[index].image!,
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),),
                const SizedBox(height: 10,),
                Text(menu[index].name!,textAlign:TextAlign.center,
                  style:  TextStyle(fontSize: 12,fontFamily: WorkSans.regular,color:PSColors.text_color),),
              ],
            )),
      ); },

  ));

}