import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:publicschool_app/helper/logger/logger.dart';
import 'package:publicschool_app/pages/dialogues/faculty_dialogue.dart';
import 'package:publicschool_app/pages/dialogues/student_dialogue.dart';
import 'package:publicschool_app/pages/dialogues/subject_dialogue.dart';
import 'package:publicschool_app/utilities/fonts.dart';

import '../../../model/subject/subject_list_data.dart';
import '../../../utilities/ps_colors.dart';

class SubjectItem extends StatelessWidget{
  SubjectList? subject;

   SubjectItem({this.subject});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5,right: 5),
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
          height: 74,
          padding: EdgeInsets.all(10),
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
          child:Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Expanded(

                  flex: 6,
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 2,color: PSColors.app_color)
                        ),

                        child: Text(
                          (subject!.subjectName!=null)?(subject!.subjectName!.isNotEmpty)?
                          _getInitials(subject!.subjectName!):'':'',
                          style: TextStyle(color: PSColors.text_color, fontSize: 11,fontFamily: WorkSans.semiBold),
                        ),
                      ),
                      SizedBox(width: 40,),
                      Text("${subject!.subjectName}",style: TextStyle(fontSize: 15,fontFamily: WorkSans.semiBold,color: PSColors.text_black_color)),

                    ],
                  )
              ),
              SizedBox(width: 10,),
              Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 48,
                    width: 48,
                    child: Card(
                      elevation: 1,
                      child:  Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 12,
                        color: HexColor("#333333"),

                      ),

                    ),
                  ))
            ],
          )

      ),
    );

  }


  String _getInitials(String user) {
    printLog("user", user);
    if(user.length>0){
      var buffer = StringBuffer();
      var split = user.split(" ");
      for (var s in split) buffer.write(s[0]);

      return buffer.toString().substring(0, split.length);
    }else return '';

  }

}
void doNothing(BuildContext context) {



}
