

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:publicschool_app/di/app_injector.dart';
import 'package:publicschool_app/di/i_student_exams.dart';
import 'package:publicschool_app/model/exams/exams_data.dart';
import '../../../model/fees/fees_list.dart';
import '../../../utilities/fonts.dart';
import '../../../utilities/ps_colors.dart';

class FeesItem extends StatelessWidget {
  Fees? feesList;
  String? userId;
  Function(int type,Fees feesList)? onCallBack;
  FeesItem({this.feesList,this.userId,this.onCallBack});
  @override
  Widget build(BuildContext context) {

    return  GestureDetector(
      onTap: (){

      },
      child: Slidable(
        actionPane: SlidableStrechActionPane(),
        actionExtentRatio: 0.15,
        secondaryActions: [
          // IconSlideAction(
          //   closeOnTap: true,
          //   caption: "",
          //   color: Colors.transparent,foregroundColor: PSColors.app_color,
          //   iconWidget: Container(padding: EdgeInsets.only(top: 20),
          //     child: Image.asset('assets/images/edit.png',height: 35,width: 35,),),
          //   onTap: (){
          //   },
          // ),
          IconSlideAction(
            closeOnTap: true,
            caption: "",
            color: Colors.transparent,foregroundColor: PSColors.red_color,
            iconWidget: Container(padding: EdgeInsets.only(top: 20),child: Image.asset('assets/images/delete.png',height: 35,width: 35,),),
            onTap: (){
              showDialog(context: context, builder: (BuildContext context){
                return  AlertDialog(
                  title: Text("Are you sure want to Delete Fee ?" ,style: TextStyle(fontSize: 18,fontFamily: WorkSans.bold,color: PSColors.text_black_color),),
                  actions: [
                    ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.0),
                                  side:BorderSide(color: PSColors.app_color))
                          )
                      ),
                      child:  Text('No',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color:PSColors.app_color ),),

                      onPressed: () {

                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 10,),
                    ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(PSColors.app_color),
                          backgroundColor: MaterialStateProperty.all<Color>(PSColors.app_color),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.0),
                                  side: BorderSide(color: PSColors.app_color))
                          )
                      ),
                      child:const Text('Yes',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color:Colors.white ),),
                      onPressed: () async{
                        onCallBack!(2,feesList!);
                      },
                    ),

                  ],
                );
              });

            },
          ),

        ],
        child: Container(
          margin: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              border: Border.all(
                color: PSColors.app_color.withOpacity(0.50),
              ),
              borderRadius: BorderRadius.all(Radius.circular(9))
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text:  TextSpan(
                    text: 'Student Name : ',
                    style:  TextStyle(fontSize: 12,fontFamily: WorkSans.regular,color:PSColors.text_color ),
                    children: <TextSpan>[
                      TextSpan(text:feesList!.studentName!,style:  TextStyle(fontSize: 14,fontFamily: WorkSans.semiBold,color:PSColors.text_black_color ))
                    ]
                ),
              ),
              SizedBox(height: 8,),
              RichText(
                text:  TextSpan(
                    text: 'Exam Name : ',
                    style:  TextStyle(fontSize: 12,fontFamily: WorkSans.regular,color:PSColors.text_color ),
                    children: <TextSpan>[
                      TextSpan(text: feesList!.className,style:  TextStyle(fontSize: 14,fontFamily: WorkSans.semiBold,color:PSColors.text_black_color ))
                    ]
                ),
              ),
              SizedBox(height: 8,),
              RichText(
                text:  TextSpan(
                    text: 'Section Name : ',
                    style:  TextStyle(fontSize: 12,fontFamily: WorkSans.regular,color:PSColors.text_color ),
                    children: <TextSpan>[
                      TextSpan(text: feesList!.sectionName,style:  TextStyle(fontSize: 14,fontFamily: WorkSans.semiBold,color:PSColors.text_black_color ))
                    ]
                ),
              ),
              SizedBox(height: 8,),
              RichText(
                text:  TextSpan(
                    text: 'Fee Type : ',
                    style:  TextStyle(fontSize: 12,fontFamily: WorkSans.regular,color:PSColors.text_color ),
                    children: <TextSpan>[
                      TextSpan(text: feesList!.feeType,style:  TextStyle(fontSize: 14,fontFamily: WorkSans.semiBold,color:PSColors.text_black_color ))
                    ]
                ),
              ),
              SizedBox(height: 8,),
              RichText(
                text:  TextSpan(
                    text: 'Fee Amount : ',
                    style:  TextStyle(fontSize: 12,fontFamily: WorkSans.regular,color:PSColors.text_color ),
                    children: <TextSpan>[
                      TextSpan(text: feesList!.amount,style:  TextStyle(fontSize: 14,fontFamily: WorkSans.semiBold,color:PSColors.text_black_color ))
                    ]
                ),
              ),
              SizedBox(height: 8,),
              RichText(
                text:  TextSpan(
                    text: 'Paid Date : ',
                    style:  TextStyle(fontSize: 12,fontFamily: WorkSans.regular,color:PSColors.text_color ),
                    children: <TextSpan>[
                      TextSpan(text: feesList!.paidDate,style:  TextStyle(fontSize: 14,fontFamily: WorkSans.semiBold,color:PSColors.text_black_color ))
                    ]
                ),
              ),
              SizedBox(height: 8,),



            ],

          ),


        ),
      ),
    );
  }

}

class DismissiblePane {

}