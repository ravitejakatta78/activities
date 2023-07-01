
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:intl/intl.dart';
import 'package:publicschool_app/model/leave/leaves_list.dart';
import 'package:publicschool_app/utilities/constants.dart';

import '../../../utilities/fonts.dart';
import '../../../utilities/ps_colors.dart';

class  LeaveItem extends StatelessWidget {
   Leave? leave;
   String? userId;
   Function(int type,Leave? leave)?  onCallback;
   LeaveItem({this.leave,this.userId,this.onCallback});

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height:50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage('assets/images/calender.png'),
                      //fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top:10.0),
                    child: Center(child: Text(DateFormat('dd').format(convertDate(leave!.startDate!)),style:  TextStyle(fontSize: 16,fontFamily: WorkSans.semiBold,color:PSColors.red_color ))),
                  )
                ),
                SizedBox(height: 10,),
                Text(DateFormat('MMM yyyy').format(convertDate(leave!.startDate!)),style: TextStyle(fontSize: 14,fontFamily: WorkSans.semiBold,color: PSColors.text_color),)

              ],
            ),
          ),
          SizedBox(width: 40,),
          Expanded(
            flex: 8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                RichText(
                  text:  TextSpan(
                      children: [
                         WidgetSpan(
                           child: Image.asset((leave!.leaveType=="Annual Leave")?'assets/images/vacation.png':(leave!.leaveType=="Sick Leave")?'assets/images/sick.png':'assets/images/vacation.png',width: 14,height: 14,),
                        ),
                        TextSpan(text: "   ${leave!.leaveType}",style:  TextStyle(fontSize: 12,fontFamily: WorkSans.semiBold,color:PSColors.text_color )
                        )
                      ]
                  ),
                ),
                SizedBox(height: 10,),
                RichText(
                  text:  TextSpan(
                      text: 'Name : ',
                      style:  TextStyle(
                          color: PSColors.hint_text_color, fontSize: 12),
                      children: <TextSpan>[
                        TextSpan(text: leave!.facultyName!,style:  TextStyle(fontSize: 12,fontFamily: WorkSans.semiBold,color:PSColors.text_color )
                        )
                      ]
                  ),
                ),
                SizedBox(height: 10,),

                RichText(
                  text:  TextSpan(
                      text: 'Duration : ',
                      style:  TextStyle(
                          color: PSColors.hint_text_color, fontSize: 12),
                      children: <TextSpan>[
                        TextSpan(text: (leave!.startDate!=leave!.endDate!)?daysBetweenDates(convertDate(leave!.startDate!),convertDate(leave!.endDate!)).toString()+" days ":leave!.leaveRange!,style:  TextStyle(fontSize: 12,fontFamily: WorkSans.semiBold,color:PSColors.text_color )
                        )
                      ]
                  ),
                ),

                SizedBox(height: 10,),
                RichText(
                  text:  TextSpan(
                      text: 'Date : ',
                      style:  TextStyle(
                          color: PSColors.hint_text_color, fontSize: 12),
                      children: <TextSpan>[
                        TextSpan(text:leave!.startDate,style:  TextStyle(fontSize: 12,fontFamily: WorkSans.semiBold,color:PSColors.yellow_color )),
                          (leave!.endDate!=null)?TextSpan(text: " - ${leave!.endDate}",style:  TextStyle(fontSize: 12,fontFamily: WorkSans.semiBold,color:PSColors.yellow_color )


                ):TextSpan(text: "",style:  TextStyle(fontSize: 14,fontFamily: WorkSans.regular,color:PSColors.yellow_color )


                          )
                      ]
                  ),
                ),
                SizedBox(height: 10,),
                RichText(
                  text:  TextSpan(
                      text: 'Status : ',
                      style:  TextStyle(
                          color: PSColors.hint_text_color, fontSize: 12),
                      children: <TextSpan>[
                        TextSpan(text: leave!.leaveStatusText,style:  TextStyle(fontSize: 12,fontFamily: WorkSans.semiBold,color:PSColors.text_color )
                        )
                      ]
                  ),
                ),
                SizedBox(height: 10,),
                RichText(
                  text:  TextSpan(
                      text: 'Notes : ',
                      style:  TextStyle(
                          color: PSColors.hint_text_color, fontSize: 12),
                      children: <TextSpan>[
                        TextSpan(text: (leave!.leaveReason!=null)?leave!.leaveReason:"",style:  TextStyle(fontSize: 12,fontFamily: WorkSans.semiBold,color:PSColors.text_color )
                        )
                      ]
                  ),
                ),
                SizedBox(height: 15,),
                (userId==Constants.school)?
                (leave!.leaveStatus=="1")?Row(
                      children: [
                       GestureDetector(
                           onTap: (){
                            onCallback!(2,leave);
                           },
                           child: Icon(Icons.check_circle_outline,color: Colors.green,size: 30,)),
                        SizedBox(width: 20,),
                        GestureDetector(
                            onTap: (){
                              onCallback!(3,leave);
                            },
                            child: Icon(Icons.highlight_remove_outlined,color: Colors.red,size: 30,)),
                      ],
                    ):SizedBox()
                    :SizedBox(),



                Divider(thickness: 1.5)


              ],
            ),
          ),
        ],
      ),

    );
  }
   int daysBetweenDates(DateTime from, DateTime to) {
     from = DateTime(from.year, from.month, from.day);
     to = DateTime(to.year, to.month, to.day);
     return (to.difference(from).inHours / 24).round();

   }

   DateTime convertDate(String dateValue){

     DateTime parseDate = new DateFormat("dd-MMM-yyyy").parse(dateValue);
     var inputDate = DateTime.parse(parseDate.toString());
     var outputFormat = DateFormat('dd-MM-yyyy');
     var outputDate = outputFormat.format(inputDate);
      return parseDate;
   }

}