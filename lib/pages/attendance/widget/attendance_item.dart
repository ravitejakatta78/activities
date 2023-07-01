
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:publicschool_app/di/i_faculity_attendance.dart';
import 'package:publicschool_app/model/faculty/faculty_list_data.dart';

import '../../../di/app_injector.dart';
import '../../../utilities/fonts.dart';
import '../../../utilities/ps_colors.dart';

Widget AttendanceItem(FacultyAttendanceHistory facultyAttendanceHistory){
  return Container(
    margin: const EdgeInsets.only(left: 5,right: 5,bottom: 10),
    decoration:  BoxDecoration(
      color: PSColors.app_color.withOpacity(0.30),
      borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          topLeft: Radius.circular(10)
      ),
    ),
    child: Container(
      margin: const EdgeInsets.only(left: 1,right: 1,top: 0.0,bottom: 0.9),
      decoration:  const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            bottomRight: const Radius.circular(10),
            bottomLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            topLeft: const Radius.circular(10)
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Stack(
        children: [
          Positioned(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                Expanded(
                  child: Column(
                    children: [
                      Text("In Time ",style:  TextStyle(fontSize: 12,fontFamily: WorkSans.regular,color:PSColors.text_black_color )),

                      Text( (facultyAttendanceHistory.login!=null)?DateFormat('dd-MMM-yy HH:mm:ss').format(convertDate(facultyAttendanceHistory.login.toString())):"",style:  TextStyle(fontSize: 12,fontFamily: WorkSans.regular,color:PSColors.text_black_color ))


            ]
                  ),
                ),

                const SizedBox(height: 10,),
                Expanded(
                child: Column(
                    children: [
                      Text("Out Time ",style:  TextStyle(fontSize: 12,fontFamily: WorkSans.regular,color:PSColors.text_black_color )),

                      Text( (facultyAttendanceHistory.logout!=null)?DateFormat('dd-MMM-yy HH:mm:ss').format(convertDate(facultyAttendanceHistory.logout.toString())):"",style:  TextStyle(fontSize: 12,fontFamily: WorkSans.regular,color:PSColors.text_black_color ))


                    ]
                )),

              ],
            ),
          ),

        ],
      ),
    ),
  );
}

DateTime convertDate(String dateValue){

  DateTime parseDate = new DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateValue);
  var inputDate = DateTime.parse(parseDate.toString());
  var outputFormat = DateFormat('dd-MM-yyyy');
  var outputDate = outputFormat.format(inputDate);
  return parseDate;
}
