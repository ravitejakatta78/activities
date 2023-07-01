
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:publicschool_app/di/app_injector.dart';
import 'package:publicschool_app/di/i_time_table.dart';
import 'package:publicschool_app/model/leave/leaves_list.dart';
import 'package:publicschool_app/utilities/constants.dart';

import '../../../model/time_table/get_time_table.dart';
import '../../../utilities/fonts.dart';
import '../../../utilities/ps_colors.dart';

class  TimeTableItem extends StatelessWidget {
  TimeTable? timeTable;
   String? userId;
   String? colorData;
   Function(int type,TimeTable timeTable)?  onCallback;
   TimeTableItem({this.timeTable,this.userId,this.onCallback,this.colorData});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      child: Row(
        children: [
          Expanded(
            flex: 2,
              child: Text(timeTable!.sessionTime.toString(),style:
              TextStyle(color: PSColors.text_color,
                  fontFamily: WorkSans.semiBold,fontSize: 13))),
          Expanded(
              flex: 8,
              child: Slidable(
                actionPane: SlidableStrechActionPane(),
                actionExtentRatio: 0.29,
                secondaryActions: [
                  SizedBox(
                    height: 45,
                    width: 45,
                    child: ElevatedButton(onPressed: (){
                   onCallback!(1,timeTable!);

                    }, style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                    ),
                        child: Image.asset('assets/images/edit.png')),
                  ),
                  SizedBox(
                    height: 45,
                    width: 45,
                    child: ElevatedButton(onPressed: (){
                      onCallback!(2,timeTable!);
                    }, style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                    ),
                        child: Image.asset('assets/images/delete.png')),
                  ),
                ],
                child: Container(
                  padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color:HexColor(colorData!),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(timeTable!.sessionName.toString(),style: TextStyle(color: Colors.white,
                    fontFamily: WorkSans.semiBold,fontSize: 16),),
                    SizedBox(height: 5,),
                    Text('${timeTable!.className.toString()+ "-" +timeTable!.sectionName.toString() }',style:
                    TextStyle(color: Colors.white, fontFamily: WorkSans.regular,fontSize: 13),),
                    SizedBox(height: 5,),
                    Text(timeTable!.faculityName.toString(),style: TextStyle(color: Colors.white,
                        fontFamily: WorkSans.semiBold,fontSize: 16),),
                  ],
                )),
              )),
        ],
      ),

    );
  }

   DateTime convertDate(String dateValue){

     DateTime parseDate = new DateFormat("dd-MMM-yyyy").parse(dateValue);
     var inputDate = DateTime.parse(parseDate.toString());
     var outputFormat = DateFormat('dd-MM-yyyy');
     var outputDate = outputFormat.format(inputDate);
      return parseDate;
   }

}