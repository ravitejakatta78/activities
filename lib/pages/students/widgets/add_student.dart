import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:intl/intl.dart';
import 'package:publicschool_app/app/arch/bloc_provider.dart';
import 'package:publicschool_app/common/widgets/load_container/load_container.dart';
import 'package:publicschool_app/helper/logger/logger.dart';
import 'package:publicschool_app/model/subject/subject_list_data.dart';
import 'package:toast/toast.dart';
import '../../../common/widgets/bottom_sheet/bottom_sheet.dart';
import '../../../common/widgets/dropdown/custom_dropdown.dart';
import '../../../di/app_injector.dart';
import '../../../model/sections/sections_data.dart';
import '../../../repositories/menu_list/subject_api.dart';
import '../../../utilities/ps_colors.dart';
import '../bloc/add_student_bloc.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({Key? key}) : super(key: key);
  @override
  AddStudentState createState() => AddStudentState();
}
class AddStudentState extends State<AddStudent> {
  AddStudentBloc? bloc;
  File? studentImageFile;
  final List<String> gender = ['Male', 'Female', 'Others'];
  final List<String> parentType = ['Mother', 'Father', 'Guardian'];
  @override
  void initState() {
    super.initState();
    bloc=BlocProvider.of(context);
   // bloc?.gender.add(gender[0]);
   // bloc?.addParentType.add(parentType[0]);
  }
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: PSColors.app_color,
          centerTitle: true,
          title: const Text('Add Student', style: TextStyle(color: Colors.white),),
        ),
        body: LoaderContainer(
          stream: bloc!.isLoading,
          child: Container(
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: StreamBuilder<List<ClassList>>(
                  initialData: [],
                  stream: bloc?.classList,
                  builder: (context, s) {
                    List<String> value = [];
                    if (s.data!.isNotEmpty) {
                      /*bloc?.class1.add(
                          '${s.data![0].className!}');*/
                      for (int i = 0; i < s.data!.length; i++) {
                        value.add('${s.data![i].className!}');
                      }
                    }
                    return  Column(
                        children: [
                          const Text(
                              'Student Info',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 25)),
                          GestureDetector(onTap: () {
                            openBottomSheet(onCallback: (file) async {
                              Navigator.pop(context);
                              if (file == 'Cam') {
                                studentImageFile = await getImageFromCamera();
                              } else {
                                studentImageFile = await getImageFromGallery();
                              }
                              bloc?.stuImage.add(studentImageFile);
                            },);
                          }, child: StreamBuilder<File?>(
                            initialData: null,
                            stream: bloc?.stuImage_File,
                            builder: (c, s) {
                              return ClipOval(
                                child: SizedBox.fromSize(
                                  size: Size.fromRadius(60), // Image radius
                                  child: (s.data != null) ? Image.file(
                                      s.data!, fit: BoxFit.fill) : Image.asset(
                                      'assets/images/photo.png',
                                      width: 120, height: 120, fit: BoxFit.fill),
                                ),
                              );
                            },
                          )
                          ),
                          const SizedBox(height: 20,),
                          StreamBuilder<String>(
                            initialData: '',
                            stream: bloc!.stuFirstName,
                            builder: (context, snapshot) {
                              return TextField(
                                  textInputAction: TextInputAction.next,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    hintText: 'First Name',
                                  ),
                                  controller:TextEditingController.fromValue(TextEditingValue(
                                      text: snapshot.data!,
                                      selection: TextSelection.collapsed(
                                          offset: snapshot.data!.length))),
                                  onChanged: (value) {
                                    bloc?.addStuFirstName.add(value);
                                  }
                              );
                            }
                          ),
                          const SizedBox(height: 20,),
                          StreamBuilder<String>(
                            initialData: '',
                            stream: bloc!.stuLastName,
                            builder: (context, snapshot) {
                              return TextField(
                                  textInputAction: TextInputAction.next,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    hintText: 'Last Name',
                                  ),
                                  controller:  TextEditingController.fromValue(TextEditingValue(
                                      text: snapshot.data!,
                                      selection: TextSelection.collapsed(
                                          offset: snapshot.data!.length))),

                                  onChanged: (value) {
                                    bloc?.addStuLastName.add(value);
                                  }
                              );
                            }
                          ),
                          const SizedBox(height: 20,),

                          StreamBuilder<String>(
                            initialData: "",
                              stream: bloc?.studentDOB,
                              builder:(c,s)=>
                                  TextField(
                                    decoration:  const InputDecoration(
                                      hintText: 'Date of Birth',
                                      suffixIcon: Icon(Icons.calendar_month),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black, width: 1)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black, width: 1)),
                                    ),
                                    controller:  TextEditingController.fromValue(TextEditingValue(
                                        text: s.data!,
                                        selection: TextSelection.collapsed(
                                            offset: s.data!.length))),
                                    keyboardType: TextInputType.none,
                                    onTap: () async {
                                      // bloc!.getDate(1);
                                      var pickedDate = await DatePicker.showSimpleDatePicker(
                                        context,
                                        firstDate: DateTime(1960),
                                        lastDate: DateTime(2100),
                                        dateFormat: "dd-MMMM-yyyy",
                                        locale: DateTimePickerLocale.en_us,
                                        looping: true,);
                                      if (pickedDate != null) {
                                        var text = DateFormat("yyyy-MM-dd").format(pickedDate);
                                        printLog("text", text);
                                        bloc?.stuDOB.add(text);
                                      }
                                    },

                                  )
                          ),

                          const SizedBox(height: 20,),
                          StreamBuilder<String>(
                            initialData: "",
                            stream: bloc!.stuRollNo,
                            builder: (context, snapshot) {
                              return TextField(
                                  maxLines: 1,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    hintText: 'Roll Number',
                                  ),
                                  controller:  TextEditingController.fromValue(TextEditingValue(
                                      text: snapshot.data!,
                                      selection: TextSelection.collapsed(
                                          offset: snapshot.data!.length))),

                                  onChanged: (value) {
                                    bloc?.addStuRollNo.add(value);
                                  }
                              );
                            }
                          ),
                          const SizedBox(height: 20,),
                          StreamBuilder<String>(
                            initialData: '',
                            stream: bloc!.stuAdmissionID,
                            builder: (context, snapshot) {
                              return TextField(
                                  textInputAction: TextInputAction.next,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    hintText: 'Admission ID',
                                  ),
                                  controller: TextEditingController.fromValue(TextEditingValue(
                                      text: snapshot.data!,
                                      selection: TextSelection.collapsed(
                                          offset: snapshot.data!.length))),
                                  onChanged: (value) {
                                    bloc?.addStuAdmissionID.add(value);
                                  }
                              );
                            }
                          ),
                          const SizedBox(height: 20,),
                          StreamBuilder<String>(
                            initialData: '',
                            stream: bloc!.stuAddress,
                            builder: (context, snapshot) {
                              return TextField(
                                  textInputAction: TextInputAction.done,
                                  autocorrect: true,
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    hintText: 'Address',
                                  ),
                                  controller:  TextEditingController.fromValue(TextEditingValue(
                                      text: snapshot.data!,
                                      selection: TextSelection.collapsed(
                                          offset: snapshot.data!.length))),
                                  onChanged: (value) {
                                    bloc?.addStuAddress.add(value);
                                  }
                              );
                            }
                          ),
                          const SizedBox(height: 20,),
                          StreamBuilder<String>(
                              initialData: null,
                              stream: bloc?.class_name,
                              builder: (context, snapshot) {
                                return  CustomDropdown(
                                  hint: 'Select Class',
                                  dropdownItems: value,
                                  buttonWidth: 500,
                                  buttonHeight: 60,
                                  value: snapshot.data,
                                  onChanged: (value) {
                                    for (int i = 0; i < s.data!.length; i++) {
                                      if (value == s.data![i].className!) {

                                        bloc?.getSections(s.data![i].classId!);
                                        bloc?.addClassId.add(s.data![i].classId!);
                                        bloc?.class1.add(value!);
                                        break;
                                      }
                                    }
                                  },
                                );
                              }
                          ),
                          const SizedBox(height: 20,),
                          StreamBuilder<List<SectionsList>>(
                              initialData: [],
                              stream: bloc?.sectionsList,
                              builder: (context, s) {
                                List<String> value = [];
                                if (s.data!.isNotEmpty) {
                                 // bloc?.section.add(s.data![0].sectionName!);
                                  for (int i = 0; i < s.data!.length; i++) {
                                    value.add(s.data![i].sectionName!);
                                  }
                                  value = value.toSet().toList();
                                }
                                return (value.isNotEmpty) ? StreamBuilder<String>(
                                    initialData: null,
                                    stream: bloc?.section_name,
                                    builder: (context, snapshot) {
                                      return  CustomDropdown(
                                        hint: 'Select Section',
                                        dropdownItems: value,
                                        buttonWidth: 500,
                                        buttonHeight: 60,
                                        value: snapshot.data,
                                        onChanged: (value) {
                                          for (int i = 0; i < s.data!.length; i++) {
                                            if (value == s.data![i].sectionName!) {
                                              bloc?.section.add(s.data![i].sectionName!);
                                              bloc?.addSectionId.add(s.data![i].sectionId!);
                                              break;
                                            }
                                          }
                                        },
                                      );
                                    }
                                ) : SizedBox();
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
                                  buttonHeight: 60,
                                  value: b.data,
                                  onChanged: (String? value) {
                                    bloc?.gender.add(value!);
                                  },
                                ) ;
                              }
                          ),
                          const SizedBox(height: 20,),
                          const Text(
                              'Parent Info',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 25)),
                          const SizedBox(height: 10,),

                          StreamBuilder<String>(
                            initialData: '',
                            stream: bloc!.parentName,
                            builder: (context, snapshot) {
                              return TextField(
                                  textInputAction: TextInputAction.next,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    hintText: 'Name',
                                  ),
                                  controller:  TextEditingController.fromValue(TextEditingValue(
                                      text: snapshot.data!,
                                      selection: TextSelection.collapsed(
                                          offset: snapshot.data!.length))),

                                  onChanged: (value) {
                                    bloc?.addParentName.add(value);
                                  }
                              );
                            }
                          ),
                          const SizedBox(height: 20,),
                          StreamBuilder<String>(
                              initialData: null,
                              stream: bloc?.parentType,
                              builder: (context, b) {
                                return  CustomDropdown(
                                  hint: 'Parent Type',
                                  dropdownItems: parentType,
                                  buttonWidth: 500,
                                  buttonHeight: 60,
                                  value: b.data,
                                  onChanged: (String? value) {
                                    bloc?.addParentType.add(value!);
                                  },
                                ) ;
                              }
                          ),
                          const SizedBox(height: 20,),
                          StreamBuilder<String>(
                            initialData: '',
                            stream: bloc!.occupation,
                            builder: (context, snapshot) {
                              return TextField(
                                  maxLines: 1,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    hintText: 'Occupation',
                                  ),
                                  controller: TextEditingController.fromValue(TextEditingValue(
                                      text: snapshot.data!,
                                      selection: TextSelection.collapsed(
                                          offset: snapshot.data!.length))),

                                  onChanged: (value) {
                                    bloc?.addOccupation.add(value);
                                  }
                              );
                            }
                          ),
                          const SizedBox(height: 20,),
                          StreamBuilder<String>(
                            initialData: '',
                            stream: bloc!.parentEmail,
                            builder: (context, snapshot) {
                              return TextField(
                                  maxLines: 1,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    hintText: 'Email',
                                  ),
                                  controller:  TextEditingController.fromValue(TextEditingValue(
                                      text: snapshot.data!,
                                      selection: TextSelection.collapsed(
                                          offset: snapshot.data!.length))),

                                  onChanged: (value) {
                                    bloc?.addParentEmail.add(value);
                                  }
                              );
                            }
                          ),

                          const SizedBox(height: 20,),
                          StreamBuilder<String>(
                            initialData: '',
                            stream: bloc!.parentMobileNo,
                            builder: (context, snapshot) {
                              return TextField(
                                  textInputAction: TextInputAction.next,
                                  maxLength: 10,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    hintText: 'Mobile Number',
                                  ),
                                  controller:  TextEditingController.fromValue(TextEditingValue(
                                      text: snapshot.data!,
                                      selection: TextSelection.collapsed(
                                          offset: snapshot.data!.length))),
                                  onChanged: (value) {
                                    bloc?.addParentMobileNo.add(value);
                                  }
                              );
                            }
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                    foregroundColor: MaterialStateProperty.all<
                                        Color>(
                                        Colors.white),
                                    backgroundColor: MaterialStateProperty.all<
                                        Color>(
                                        Colors.white),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                14.0),
                                            side: BorderSide(
                                                color: PSColors.app_color))
                                    )
                                ),
                                child: Text('Cancel', style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: PSColors.app_color),),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              const SizedBox(width: 20,),
                              ElevatedButton(
                                style: ButtonStyle(
                                    foregroundColor: MaterialStateProperty.all<
                                        Color>(
                                        PSColors.app_color),
                                    backgroundColor: MaterialStateProperty.all<
                                        Color>(
                                        PSColors.app_color),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                14.0),
                                            side: BorderSide(
                                                color: PSColors.app_color))
                                    )
                                ),
                                child: const Text('Submit', style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),),

                                onPressed: () {
                                  bloc!.students_submit.add(null);
                                },
                              ),
                            ],
                          ),
                        ]
                    ) ;
                  }
              ),
            ),
          ),
        )
    );
  }

}



