

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:publicschool_app/di/app_injector.dart';
import 'package:publicschool_app/di/i_student_exams.dart';
import 'package:publicschool_app/model/exams/exams_data.dart';
import '../../../utilities/fonts.dart';
import '../../../utilities/ps_colors.dart';

class Exam extends StatelessWidget {
  ExamsList examsList;
  String? userId;
  Function(int type,ExamsList examsList)? onCallBack;
  Exam({required this.examsList,this.userId,this.onCallBack});
  @override
  Widget build(BuildContext context) {

   return  GestureDetector(
     onTap: (){
       Get.to(AppInjector.instance.examsScheduleList('',examsList));
     },
     child: Slidable(
       actionPane: SlidableStrechActionPane(),
       actionExtentRatio: 0.15,
       secondaryActions: [
         IconSlideAction(
           closeOnTap: true,
           caption: "",
           color: Colors.transparent,foregroundColor: PSColors.app_color,
           iconWidget: Container(padding: EdgeInsets.only(top: 20),
             child: Image.asset('assets/images/edit.png',height: 35,width: 35,),),
           onTap: (){
             Get.to(AppInjector.instance.examDetails("",examsList));
           },
         ),
         IconSlideAction(
           closeOnTap: true,
           caption: "",
           color: Colors.transparent,foregroundColor: PSColors.red_color,
           iconWidget: Container(padding: EdgeInsets.only(top: 20),child: Image.asset('assets/images/delete.png',height: 35,width: 35,),),
           onTap: (){
             showDialog(context: context, builder: (BuildContext context){
               return  AlertDialog(
                 title: Text("Are you sure want to Delete Exam ?" ,style: TextStyle(fontSize: 18,fontFamily: WorkSans.bold,color: PSColors.text_black_color),),
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
                       onCallBack!(2,examsList);
                       Navigator.pop(context);

                     },
                   ),




                 ],
               );
             });

           },
         ),

       /*  SizedBox(
           height: 45,
           width: 45,
           child: ElevatedButton(onPressed: (){

           }, style: ElevatedButton.styleFrom(
             shape: const CircleBorder(),
           ),
               child: Image.asset('assets/images/edit.png')),
         ),
         SizedBox(
           height: 45,
           width: 45,
           child: ElevatedButton(onPressed: (){
             Get.to(AppInjector.instance.examDetails("",examsList));
           }, style: ElevatedButton.styleFrom(
             shape: const CircleBorder(),
           ),
               child: Icon(Icons.add)),
         ),
         SizedBox(
           height: 45,
           width: 45,
           child: ElevatedButton(onPressed: (){
             onCallBack!(2,examsList);
           }, style: ElevatedButton.styleFrom(
             shape: const CircleBorder(),
           ),
               child: Image.asset('assets/images/delete.png')),
         ),*/
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
                   text: 'Class Name : ',
                   style:  TextStyle(fontSize: 12,fontFamily: WorkSans.regular,color:PSColors.text_color ),
                   children: <TextSpan>[
                     TextSpan(text:"${(examsList.sectionName!.isNotEmpty)?(examsList.className!+"-"+examsList.sectionName!):examsList.className!}",style:  TextStyle(fontSize: 14,fontFamily: WorkSans.semiBold,color:PSColors.text_black_color ))
                   ]
               ),
             ),
             SizedBox(height: 8,),
             RichText(
               text:  TextSpan(
                   text: 'Exam Name : ',
                   style:  TextStyle(fontSize: 12,fontFamily: WorkSans.regular,color:PSColors.text_color ),
                   children: <TextSpan>[
                     TextSpan(text: examsList.examName,style:  TextStyle(fontSize: 14,fontFamily: WorkSans.semiBold,color:PSColors.text_black_color ))
                   ]
               ),
             ),
             SizedBox(height: 8,),
             Row(
               children: [
                 Expanded(flex: 5,child: RichText(
                   text:  TextSpan(
                       text: 'Start date : ',
                       style:  TextStyle(fontSize: 12,fontFamily: WorkSans.regular,color:PSColors.text_color ),
                       children: <TextSpan>[
                         TextSpan(text: examsList.examStartDate,style:  TextStyle(fontSize: 14,fontFamily: WorkSans.semiBold,color:PSColors.text_black_color ))
                       ]
                   ),
                 ),),
                 Expanded(flex: 5,child: RichText(
                   text:  TextSpan(
                       text: 'End date : ',
                       style:  TextStyle(fontSize: 12,fontFamily: WorkSans.regular,color:PSColors.text_color ),
                       children: <TextSpan>[
                         TextSpan(text: examsList.examEndDate,style:  TextStyle(fontSize: 14,fontFamily: WorkSans.semiBold,color:PSColors.text_black_color ))
                       ]
                   ),
                 ),),
               ],
             ),



            /* SizedBox(height: 12,),
             Row(
               mainAxisAlignment: MainAxisAlignment.end,
               children: [
                 SizedBox(
                   width: 40,
                   height: 40,
                   // width:MediaQuery.of(context).size.width*0.12,
                   // height: MediaQuery.of(context).size.height*0.12,
                   child: ElevatedButton(
                     style: ElevatedButton.styleFrom(
                         shape: const CircleBorder(),
                         primary: Colors.white,
                         padding: EdgeInsets.all(6)
                     ),
                     child:  Icon(Icons.add, size: 20, color: PSColors.app_color,),
                     onPressed: () {
                       Get.to(AppInjector.instance.examDetails("",examsList));

                     },
                   ),
                 ),
                 SizedBox(width: 8,),
                 SizedBox(
                   width: 40,
                   height: 40,
                   // width:MediaQuery.of(context).size.width*0.12,
                   // height: MediaQuery.of(context).size.height*0.12,
                   child: ElevatedButton(
                     style: ElevatedButton.styleFrom(
                         shape: const CircleBorder(),
                         primary: Colors.white,
                         padding: EdgeInsets.all(6)
                     ),
                     child:  Icon(
                       Icons.delete_outline, size: 20, color: PSColors.red_color,),
                     onPressed: () {

                       onCallBack!(2,examsList);

                     },
                   ),
                 ),

               ],
             )*/

           ],

         ),


        ),
     ),
   );
  }
  
}

class DismissiblePane {

}