import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:intl/intl.dart';
import 'package:publicschool_app/helper/logger/logger.dart';
import 'package:publicschool_app/model/subject/subject_list_data.dart';
import 'package:toast/toast.dart';

import '../../common/widgets/bottom_sheet/bottom_sheet.dart';
import '../../common/widgets/dropdown/custom_dropdown.dart';
import '../../di/app_injector.dart';
import '../../repositories/menu_list/subject_api.dart';
import '../../utilities/ps_colors.dart';
import '../subject/bloc/subject_list_bloc.dart';

class AddStudents extends StatefulWidget {
  const AddStudents({Key? key}) : super(key: key);
 @override
  AddStudentState createState() => AddStudentState();
}
class AddStudentState extends State<AddStudents> {

  SubjectListBloc? bloc;
  File? studentImageFile;
  final List<String> gender = ['Male', 'Female', 'Others'];
  final List<String> section = ['Section-A', 'Section-B', 'Section-C'];

  @override
  void initState() {
    super.initState();
    bloc = SubjectListBloc('Students', AppInjector.instance.userDataStore,
        SubjectService(AppInjector.instance.userDataStore));
    bloc?.getFacultyList('classList');
   // bloc?.gender.add(gender[0]);
    bloc?.section.add(section[0]);

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
        body: Container(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: StreamBuilder<List<ClassList>>(
                initialData: [],
                stream: bloc?.classList,
                builder: (context, s) {
                  List<String> value = [];
                  if (s.data!.isNotEmpty) {
                    bloc?.class1.add(
                        '${s.data![0].classId!},${s.data![0].className!}');
                    for (int i = 0; i < s.data!.length; i++) {
                      value.add('${s.data![i].classId!},${s.data![i].className!}');
                    }
                  }

                  return (s.data!.isNotEmpty) ? Column(
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
                        TextField(
                            textInputAction: TextInputAction.next,
                            maxLines: 1,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: 'First Name',
                            ),
                            onChanged: (value) {
                              bloc?.stuFirstName.add(value);
                            }
                        ),
                        const SizedBox(height: 20,),
                        TextField(
                            textInputAction: TextInputAction.next,
                            maxLines: 1,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: 'Last Name',
                            ),
                            onChanged: (value) {
                              bloc?.stuLastName.add(value);
                            }
                        ),
                        const SizedBox(height: 20,),

                        StreamBuilder<String>(
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
                              controller: TextEditingController(text: s.data!),
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
                        TextField(
                            maxLines: 1,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: 'Roll Number',
                            ),
                            onChanged: (value) {
                              bloc?.stuRollNo.add(value);
                            }
                        ),
                        const SizedBox(height: 20,),
                        TextField(
                            textInputAction: TextInputAction.next,

                            maxLines: 1,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: 'Admission ID',
                            ),
                            onChanged: (value) {
                              bloc?.stuAdmissionID.add(value);
                            }
                        ),
                        const SizedBox(height: 20,),
                        TextField(
                            textInputAction: TextInputAction.done,
                            maxLines: 1,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: 'Address',
                            ),
                            onChanged: (value) {
                              bloc?.stuAddress.add(value);
                            }
                        ),
                        const SizedBox(height: 20,),
                        StreamBuilder<String>(
                            initialData: null,
                            stream: bloc?.class_name,
                            builder: (context, snapshot) {
                              return CustomDropdown(
                                hint: 'Select Class',
                                dropdownItems: value,
                                buttonWidth: 500,
                                buttonHeight: 60,
                                value: snapshot.data,
                                onChanged: (value) {
                                  bloc?.class1.add(value!);
                                },
                              );
                            }
                        ),
                        const SizedBox(height: 20,),
                        // StreamBuilder<String>(
                        //     initialData: '',
                        //     stream: bloc?.section_name,
                        //     builder: (context, b) {
                        //       return (b.data!.isNotEmpty) ? CustomDropdown(
                        //         hint: 'Select Section',
                        //         dropdownItems: section,
                        //         buttonWidth: 500,
                        //         buttonHeight: 60,
                        //         value: b.data,
                        //         onChanged: (String? value) {
                        //           bloc?.section.add(value!);
                        //         },
                        //       ) : const SizedBox();
                        //     }
                        // ),
                        // const SizedBox(height: 20,),
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

                        TextField(
                            textInputAction: TextInputAction.next,
                            maxLines: 1,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: 'Name',
                            ),
                            onChanged: (value) {
                              bloc?.parentName.add(value);
                            }
                        ),
                        const SizedBox(height: 20,),
                        TextField(
                            maxLines: 1,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: 'Parent Type',
                            ),
                            onChanged: (value) {
                              bloc?.parentType.add(value);
                            }
                        ),
                        const SizedBox(height: 20,),
                        TextField(
                            maxLines: 1,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: 'Occupation',
                            ),
                            onChanged: (value) {
                              bloc?.occupation.add(value);
                            }
                        ),
                        const SizedBox(height: 20,),
                        TextField(
                            maxLines: 1,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: 'Email',
                            ),
                            onChanged: (value) {
                              bloc?.parentEmail.add(value);
                            }
                        ),

                        const SizedBox(height: 20,),
                        TextField(
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
                            onChanged: (value) {
                              bloc?.parentMobileNo.add(value);
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
                                bloc!.student_submit.add(null);
                              },
                            ),
                          ],
                        ),
                      ]
                  ) : SizedBox();
                }
            ),
          ),
        )
    );
  }

}



