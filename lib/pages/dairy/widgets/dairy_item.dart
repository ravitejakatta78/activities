
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
import 'package:publicschool_app/helper/logger/logger.dart';
import 'package:publicschool_app/model/dairy/dairy_list.dart';
import 'package:publicschool_app/model/leave/leaves_list.dart';
import 'package:publicschool_app/utilities/constants.dart';

import '../../../model/time_table/get_time_table.dart';
import '../../../utilities/fonts.dart';
import '../../../utilities/ps_colors.dart';

class  DairyItem extends StatelessWidget {
   List<Dairy>? dairyList;
   String? stringDate;
   String? userId;
   List<Dairy>? dairys=[];
   Function(int type,Dairy dairy)?  onCallback;
   DairyItem({this.dairyList,this.stringDate,this.userId,this.onCallback});

   @override
  Widget build(BuildContext context) {
    for(int i=0;i<dairyList!.length;i++) {
      if (dairyList![i].dairyDate == stringDate)
        dairys!.add(dairyList![i]);
    }

    return Container(
      margin: EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (dairys!.isNotEmpty)?Text('${DateFormat('dd-MMM-yy').format(convertDate(stringDate!))+" - "+dairys![0].className!+" "+(dairys?[0].sectionName != null?dairys![0].sectionName!:'')}',style:
          TextStyle(color: PSColors.text_color,
              fontFamily: WorkSans.semiBold,fontSize: 16)):Text('${DateFormat('dd-MMM-yy').format(convertDate(stringDate!))}',style:
          TextStyle(color: PSColors.text_color,
              fontFamily: WorkSans.semiBold,fontSize: 16)),
          SizedBox(height: 10,),
          (dairys!=null)?(dairys!.isNotEmpty)?ListView.builder(
              itemCount: dairys!.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (c,s){
                return  (userId==dairys![s].createdBy)?Slidable(
                  actionPane: SlidableStrechActionPane(),
                  actionExtentRatio: 0.29,
                  secondaryActions: [
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: ElevatedButton(onPressed: (){
                        if(userId==dairys![s].createdBy)
                        onCallback!(1,dairys![s]);

                      }, style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                      ),
                          child: Image.asset('assets/images/edit.png')),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: ElevatedButton(onPressed: (){
                        if(userId==dairys![s].createdBy)
                         onCallback!(2,dairys![s]);

                      }, style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                      ),
                          child: Image.asset('assets/images/delete.png')),
                    ),
                  ],
                  child: getChildData(context,s),
                ):getChildData(context,s);
              }):SizedBox():SizedBox()

        ],
      ),

    );
  }

  Widget getChildData(BuildContext context,int s){
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color:Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dairys![s].subjectName.toString(),style: TextStyle(color: PSColors.text_color,
                fontFamily: WorkSans.semiBold,fontSize: 16),),
            SizedBox(height: 5,),
            Text('${dairys![s].taskDescription.toString() }',style:
            TextStyle(color:PSColors.text_color, fontFamily: WorkSans.regular,fontSize: 13),),
          ],
        ));
  }

   DateTime convertDate(String dateValue){

     DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(dateValue);
     var inputDate = DateTime.parse(parseDate.toString());
     var outputFormat = DateFormat('dd-MM-yyyy');
     var outputDate = outputFormat.format(inputDate);
      return parseDate;
   }

}