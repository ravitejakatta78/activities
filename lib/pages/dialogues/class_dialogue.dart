import 'dart:math';

import 'package:flutter/material.dart';
import 'package:publicschool_app/common/widgets/dropdown/custom_dropdown.dart';
import 'package:publicschool_app/common/widgets/textfield/my_text_field.dart';
import 'package:publicschool_app/helper/logger/logger.dart';
import 'package:publicschool_app/model/subject/faculity_list.dart';

import '../../utilities/ps_colors.dart';
import '../subject/bloc/subject_list_bloc.dart';

class AddClass extends StatelessWidget {
  SubjectListBloc listBloc;
  List<FaculityList> facultyList;
  AddClass({required this.listBloc,required this.facultyList});
  @override
  Widget build(BuildContext context) {
    List<String> value=[];
    if(facultyList!=[]){
     // listBloc.faculty_name.add('${facultyList[0].id!},${facultyList[0].faculityName!}');
      for(int i=0;i<facultyList.length;i++){
        value.add('${facultyList[i].id!},${facultyList[i].faculityName!}');
      }
    }
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18.0))),
      contentPadding: const EdgeInsets.all(20.0),
      backgroundColor: Colors.white,
      content: Container(
        height: 200,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            children: [
              MyTextField(hintText: 'Class Name',
                  inputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  onChange: (value){
                  listBloc.className.add(value);
                  },),
              const SizedBox(height: 20,),
              StreamBuilder<String>(
                initialData: null,
                stream: listBloc.facultyName,
                builder: (context, snapshot) {
                  return CustomDropdown(
                    hint: 'Select Faculty',
                    dropdownItems: value,
                    value: snapshot.data,
                    onChanged: (value) {
                      listBloc.faculty_name.add(value!);
                    },
                  );
                }
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.0),
                                side: BorderSide(color: PSColors.app_color))
                        )
                    ),
                    child:Text('Cancel',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: PSColors.app_color),),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 20,),
                  ElevatedButton(
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(PSColors.app_color),
                        backgroundColor: MaterialStateProperty.all<Color>(PSColors.app_color),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.0),
                                side:BorderSide(color: PSColors.app_color))
                        )
                    ),
                    child: const Text('Submit',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.white),),

                    onPressed: () {
                      listBloc.class_submit.add(null);
                      Navigator.pop(context);
                    },
                  )


                ],
              )
            ],
          ),
        ),
      ),

    );
  }

}