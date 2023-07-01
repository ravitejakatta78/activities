import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:publicschool_app/model/subject/subject_list_data.dart';
import 'package:publicschool_app/utilities/fonts.dart';
import 'package:publicschool_app/utilities/ps_colors.dart';

class ClassItem extends StatelessWidget{
  ClassList classList;
   ClassItem({required this.classList}) ;

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
        padding: const EdgeInsets.all(10),
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            RichText(
              text:  TextSpan(
                  text: 'Class : ',
                  style:  TextStyle(
                      color: PSColors.text_color, fontSize: 14),
                  children: <TextSpan>[
                    TextSpan(text: classList.className,style: TextStyle(fontSize: 15,fontFamily: WorkSans.medium,color:PSColors.text_black_color)
                    )
                  ]
              ),
            ),
            const SizedBox(height: 6,),
            RichText(
              text:  TextSpan(
                  text: 'Faculty Name : ',
                  style:  TextStyle(
                      color: PSColors.text_color, fontSize: 14),
                  children: <TextSpan>[
                    TextSpan(text: classList.faculityName,style:  TextStyle(fontSize: 12,fontFamily: WorkSans.regular,color:PSColors.text_black_color )
                    )
                  ]
              ),
            ),


          ],
        ),
      ),
    );
  }

}