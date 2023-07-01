
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:publicschool_app/app/arch/bloc_provider.dart';
import 'package:publicschool_app/pages/faculty/bloc/add_faculty_bloc.dart';
import '../../../common/widgets/bottom_sheet/bottom_sheet.dart';
import '../../../common/widgets/dropdown/custom_dropdown.dart';
import '../../../helper/logger/logger.dart';
import '../../../model/subject/faculity_list.dart';
import '../../../model/subject/subject_list_data.dart';
import '../../../utilities/ps_colors.dart';

class AddFaculty extends StatefulWidget {
  FaculityList? facultyList;
   AddFaculty({this.facultyList});

  @override
  AddFacultyState createState() => AddFacultyState();
}

class AddFacultyState  extends State<AddFaculty>{
  AddFacultyBloc? bloc;
  File? imageFile;
  final List<String> gender = ['Male', 'Female', 'Others'];

  @override
  void initState() {
    super.initState();
    bloc=BlocProvider.of(context);
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
                 // bloc?.addSubjectName.add('${s.data![0].id!},${s.data![0].subjectName!}');
                  for (int i = 0; i < s.data!.length; i++) {
                    value.add('${s.data![i].id!},${s.data![i].subjectName!}');
                  }
                }

              return Column(
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
                  StreamBuilder<String>(
                    initialData: "",
                    stream: bloc!.facultyName,
                    builder: (context, snapshot) {
                      return TextField(
                          textInputAction: TextInputAction.next,
                          maxLines:1,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            hintText: 'Name',
                          ),
                          controller:TextEditingController.fromValue(TextEditingValue(
                              text: snapshot.data!,
                              selection: TextSelection.collapsed(
                                  offset: snapshot.data!.length))),
                          onChanged: (value){
                            bloc?.addFacultyName.add(value);
                          }
                      );
                    }
                  ),
                  const SizedBox(height: 20,),
                  StreamBuilder<String>(
                    initialData: "",
                    stream: bloc!.facultyQulfyName,
                    builder: (context, snapshot) {
                      return TextField(
                          maxLines:1,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            hintText: 'Qualification',
                          ),
                          controller:TextEditingController.fromValue(TextEditingValue(
                              text: snapshot.data!,
                              selection: TextSelection.collapsed(
                                  offset: snapshot.data!.length))),
                          onChanged: (value){
                            bloc?.addFacultyQulfyName.add(value);
                          }
                      );
                    }
                  ),
                  const SizedBox(height: 20,),
                  StreamBuilder<String>(
                    initialData: '',
                    stream: bloc!.facultyMail,
                    builder: (context, snapshot) {
                      return TextField(
                          maxLines:1,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            hintText: 'Email',
                          ),
                          controller:TextEditingController.fromValue(TextEditingValue(
                              text: snapshot.data!,
                              selection: TextSelection.collapsed(
                                  offset: snapshot.data!.length))),
                          onChanged: (value){
                            bloc?.addFacultyMail.add(value);
                          }
                      );
                    }
                  ),
                  const SizedBox(height: 20,),
                  StreamBuilder<String>(
                    initialData: "",
                    stream: bloc!.facultyMobile,
                    builder: (context, snapshot) {
                      return TextField(
                          textInputAction: TextInputAction.next,
                          maxLength: 10,
                          maxLines: 1,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            hintText: 'Mobile Number',
                          ),
                          controller:TextEditingController.fromValue(TextEditingValue(
                              text: snapshot.data!,
                              selection: TextSelection.collapsed(
                                  offset: snapshot.data!.length))),

                          onChanged: (value){
                            bloc?.addFacultyMobile.add(value);
                          }
                      );
                    }
                  ),
                  const SizedBox(height: 20,),
                  StreamBuilder<String>(
                    initialData: "",
                    stream: bloc!.facultyAddress,
                    builder: (context, snapshot) {
                      return TextField(
                          textInputAction: TextInputAction.done,
                          maxLines: 1,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            hintText: 'Address',
                          ),
                          controller:TextEditingController.fromValue(TextEditingValue(
                              text: snapshot.data!,
                              selection: TextSelection.collapsed(
                                  offset: snapshot.data!.length))),

                          onChanged: (value){
                            bloc?.addFacultyAddress.add(value);
                          }
                      );
                    }
                  ),
                  const SizedBox(height: 20,),
                  StreamBuilder<String>(
                      initialData: null,
                      stream: bloc?.subjectName,
                      builder: (context, snapshot) {
                        return CustomDropdown(
                          hint: 'Select Subject',
                          dropdownItems: value,
                          buttonWidth: 500,
                          value: snapshot.data,
                          onChanged: (value) {
                            bloc?.addSubjectName.add(value!);
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
        );
            }
          ),
    ),
      )
    );
  }
}