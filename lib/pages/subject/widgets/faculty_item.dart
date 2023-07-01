import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:publicschool_app/model/subject/faculity_list.dart';
import 'package:publicschool_app/pages/dialogues/faculty_dialogue.dart';
import 'package:publicschool_app/pages/dialogues/student_dialogue.dart';
import 'package:publicschool_app/utilities/fonts.dart';

import '../../../utilities/ps_colors.dart';

class FacultyItems extends StatelessWidget{
  FaculityList facultyList;
   FacultyItems({required this.facultyList});

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

        child:Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          secondaryActions: [
            IconSlideAction(
              closeOnTap: true,
              caption: "",
              color: Colors.transparent,foregroundColor: PSColors.app_color,
              iconWidget: Container(padding: EdgeInsets.only(top: 20),
                child: Image.asset('assets/images/edit.png',height: 35,width: 35,),),
              onTap: (){
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
                          // onCallBack!(2,examsList);
                          Navigator.pop(context);

                        },
                      ),




                    ],
                  );
                });

              },
            ),


          ],
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
              height: 140,
              child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 1,child:SizedBox(
                    height: 85,
                    width: 85,
                    child: ClipOval(

                      child: CachedNetworkImage(
                        height: 85,
                        width: 85,
                        imageUrl: ((facultyList.faculityPic!=null)?facultyList.faculityPic.toString():
                        'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg'),
                        errorWidget: (context, url, error) => CircleAvatar(
                            radius: 30,
                            backgroundColor: PSColors.bg_color,
                            child: Image(image: AssetImage('assets/images/logo.png'),)),
                      )/*CircleAvatar(
                        radius: 40,
                        backgroundImage:
                        NetworkImage((facultyList.faculityPic!=null)?facultyList.faculityPic.toString():
                        'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg'),
                        backgroundColor: Colors.transparent,
                      )*/,
                    ),
                  )),
                  SizedBox(width: 10,),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:  [
                        Text(facultyList.faculityName!,style:  TextStyle(fontSize: 15,fontFamily: WorkSans.bold,color: PSColors.text_black_color)),
                        const SizedBox(height: 5,),
                        Text(facultyList.subjectId!,style: TextStyle(fontSize: 12,fontFamily: WorkSans.regular,color: PSColors.text_color)),
                        const SizedBox(height: 5,),
                        Text((facultyList.gender=="1")?'Male':'Female',style: TextStyle(fontSize: 12,fontFamily: WorkSans.regular,color: PSColors.text_color)),
                        const SizedBox(height: 5,),
                        Text(facultyList.email!,style: TextStyle(fontSize: 12,fontFamily: WorkSans.regular,color: PSColors.text_color)),
                        const SizedBox(height: 5,),
                        Text(facultyList.mobile!,style: TextStyle(fontSize: 12,fontFamily: WorkSans.regular,color: PSColors.text_color)),


                      ],
                    ),
                  ),
                  SizedBox(width: 10,),
                  const Expanded(
                      flex: 1,
                      child: Icon(Icons.arrow_forward_ios,size: 20,))
                ],
              )

          ),
        )



    );
  }

}
