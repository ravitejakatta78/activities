
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:publicschool_app/common/widgets/textfield/my_text_field.dart';
import 'package:publicschool_app/di/app_injector.dart';
import '../../common/widgets/bottom_sheet/bottom_sheet.dart';
import '../../common/widgets/dropdown/custom_dropdown.dart';
import '../../helper/logger/logger.dart';
import '../../model/subject/faculity_list.dart';
import '../../model/subject/subject_list_data.dart';
import '../../repositories/menu_list/subject_api.dart';
import '../../utilities/ps_colors.dart';
import '../subject/bloc/subject_list_bloc.dart';

class AddFacultys extends StatefulWidget {
  FaculityList? facultyList;
   AddFacultys({this.facultyList});

  @override
  AddFacultyState createState() => AddFacultyState();
}

class AddFacultyState  extends State<AddFacultys>{
  SubjectListBloc? bloc;
  File? imageFile;
  final List<String> gender = ['Male', 'Female', 'Others'];

  @override
  void initState() {
    super.initState();
    if(widget.facultyList==null){
      bloc=SubjectListBloc('Faculty',AppInjector.instance.userDataStore,SubjectService(AppInjector.instance.userDataStore));
      bloc?.getFacultyList('subjectList');
     // bloc?.gender.add(gender[0]);

    }else {
      bloc=SubjectListBloc('Faculty',AppInjector.instance.userDataStore,SubjectService(AppInjector.instance.userDataStore));

      bloc?.getFacultyList('subjectList');
     // bloc?.gender.add(gender[0]);
    //bloc?.gender.add(widget.facultyList!.gender!);
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PSColors.app_color,
        centerTitle: true,
        title: const Text('Faculty',style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: StreamBuilder<List<SubjectList>>(
              initialData: [],
              stream: bloc?.subjectList,
            builder: (context, s) {
              List<String> value = [];
                if(s.data!.isNotEmpty){
                 // bloc?.subject.add('${s.data![0].id!},${s.data![0].subjectName!}');
                  for (int i = 0; i < s.data!.length; i++) {
                    value.add('${s.data![i].id!},${s.data![i].subjectName!}');
                  }
                }

              return (s.data!.isNotEmpty)?Column(
                children: [
                  GestureDetector(onTap: () {
                    openBottomSheet(onCallback:(file) async {
                      Navigator.pop(context);
                      if(file=='Cam'){
                        imageFile=await getImageFromCamera();
                      }else {
                        imageFile=await getImageFromGallery();
                      }
                      bloc?.image.add(imageFile);
                      printLog("file", file);
                    },);

                  }, child: StreamBuilder<File?>(
                        initialData: null,
                        stream: bloc?.image_File,
                        builder: (c,s){
                         return  ClipOval(
                           child: SizedBox.fromSize(
                             size: Size.fromRadius(60), // Image radius
                             child: (s.data!=null)?Image.file
                               (s.data!,fit: BoxFit.fill):Image.asset('assets/images/photo.png',
                                 width: 50, height: 50, fit: BoxFit.fill),
                           ),
                         ) ;
                        },
                       )
                  ),
                  const SizedBox(height: 20,),
                  TextField(
                      textInputAction: TextInputAction.next,
                      maxLines:1,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        hintText: 'Name',
                      ),
                      onChanged: (value){
                        bloc?.faculty_name.add(value);
                      }
                  ),
                  const SizedBox(height: 20,),
                  TextField(
                      maxLines:1,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        hintText: 'Qualification',
                      ),
                      onChanged: (value){
                        bloc?.facultyQulfyName.add(value);
                      }
                  ),
                  const SizedBox(height: 20,),
                  TextField(
                      maxLines:1,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        hintText: 'Email',
                      ),
                      onChanged: (value){
                        bloc?.facultyMail.add(value);
                      }
                  ),
                  const SizedBox(height: 20,),
                  TextField(
                      textInputAction: TextInputAction.next,
                      maxLength: 10,
                      maxLines: 1,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        hintText: 'Mobile Number',
                      ),
                      onChanged: (value){
                        bloc?.facultyMobile.add(value);
                      }
                  ),
                  const SizedBox(height: 20,),
                  TextField(
                      textInputAction: TextInputAction.done,
                      maxLines: 1,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        hintText: 'Address',
                      ),
                      onChanged: (value){
                        bloc?.facultyAddress.add(value);
                      }
                  ),
                  const SizedBox(height: 20,),
                  StreamBuilder<String>(
                      initialData: null,
                      stream: bloc?.subject_name,
                      builder: (context, snapshot) {
                        return  CustomDropdown(
                          hint: 'Select Subject',
                          dropdownItems: value,
                          buttonWidth: 500,
                          value: snapshot.data,
                          onChanged: (value) {
                            bloc?.subject.add(value!);
                          },
                        ) ;
                      }
                  ),
                  const SizedBox(height: 20,),
                  StreamBuilder<String>(
                      initialData: null,
                      stream: bloc?.gender_name,
                      builder: (context, b) {
                        return  CustomDropdown(
                          hint: 'Select Gender',
                          dropdownItems: gender,
                          buttonWidth: 500,
                          value: b.data,
                          onChanged: (String? value) {
                            bloc?.gender.add(value!);
                            printLog("selectedValue", b.data);
                          },
                        ) ;
                      }
                  ),
                  const SizedBox(height: 20,),
                  Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.white),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.0),
                                side:BorderSide(color: PSColors.app_color))
                        )
                    ),
                    child:Text('Cancel', style: TextStyle(fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: PSColors.app_color),),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 20,),
                  ElevatedButton(
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            PSColors.app_color),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            PSColors.app_color),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.0),
                                side: BorderSide(color: PSColors.app_color))
                        )
                    ),
                    child: const Text('Submit', style: TextStyle(fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),),

                    onPressed: () {
                      bloc!.faculty_submit.add(null);
                    },
                  ),
                  ],
                ),
        ]
        ):SizedBox();
            }
          ),
    ),
      )
    );
  }
}