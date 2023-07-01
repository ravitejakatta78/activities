

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:publicschool_app/common/widgets/load_container/load_container.dart';
import 'package:publicschool_app/model/fees/fee_types_list.dart';
import 'package:publicschool_app/model/subject/student_list.dart';
import 'package:toast/toast.dart';

import '../../../app/arch/bloc_provider.dart';
import '../../../common/widgets/dropdown/custom_dropdown.dart';
import '../../../helper/logger/logger.dart';
import '../../../model/sections/sections_data.dart';
import '../../../model/subject/subject_list_data.dart';
import '../../../utilities/fonts.dart';
import '../../../utilities/ps_colors.dart';
import '../bloc/add_student_fees_bloc.dart';

class AddStudentFees extends StatefulWidget {

  @override
  AddStudentFeesState createState() => AddStudentFeesState();
}

class AddStudentFeesState extends State<AddStudentFees>{
  AddStudentFeesBloc? _bloc;
  TextEditingController? _controller;
  void initState() {
    super.initState();
    _bloc=BlocProvider.of(context);
    _controller = new TextEditingController();
    _controller!.text="Hello";
    ToastContext().init(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PSColors.app_color,
        centerTitle: true,
        title: const Text('Add Student Fees',style:TextStyle(fontSize: 20,fontFamily: WorkSans.semiBold)),
      ),
      body: LoaderContainer(
        stream: _bloc!.isLoading,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder<List<ClassList>>(
                    initialData: [],
                    stream: _bloc?.classList,
                    builder: (context, s){
                      List<String> value = [];
                      List<String> valueId = [];
                      if (s.data!.isNotEmpty) {

                        for (int i = 0; i < s.data!.length; i++) {
                          value.add(s.data![i].className!);
                        }
                      }
                      return (s.data!.isNotEmpty) ?StreamBuilder<String>(
                          initialData: null,
                          stream: _bloc?.class_name,
                          builder: (context, snapshot) {
                            return  CustomDropdown(
                              hint: 'Select Class',
                              dropdownItems: value,
                              buttonWidth: 500,
                              buttonHeight: 60,
                              value: snapshot.data,
                              onChanged: (value) {
                                for (int i = 0; i < s.data!.length; i++) {
                                  if(value==s.data![i].className!) {
                                    _bloc?.getSections(s.data![i].classId!);
                                    _bloc!.getFeesListTypes(s.data![i].classId!);
                                    _bloc?.addClassId.add(s.data![i].classId!);
                                    _bloc?.addClass.add(value!);
                                    break;
                                  }
                                }
                              },
                            )
                                ;
                          }
                      ):const SizedBox();
                    }

                ),
                const SizedBox(height: 20,),
                StreamBuilder<List<SectionsList>>(
                    initialData: [],
                    stream: _bloc?.sectionsList,
                    builder: (context, s){
                      List<String> value = [];
                      if (s.data!.isNotEmpty) {
                       // _bloc?.addSection.add(s.data![0].sectionName!);
                        for (int i = 0; i < s.data!.length; i++) {
                          value.add(s.data![i].sectionName!);
                        }
                        value=value.toSet().toList();
                      }
                      return (value.isNotEmpty) ?StreamBuilder<String>(
                          initialData:null,
                          stream: _bloc?.sectionName,
                          builder: (context, snapshot) {
                            return  CustomDropdown(
                              hint: 'Select Section',
                              dropdownItems: value,
                              buttonWidth: 500,
                              buttonHeight: 60,
                              value: snapshot.data,
                              onChanged: (value) {
                                for (int i = 0; i < s.data!.length; i++) {
                                  if(value==s.data![i].sectionName!) {
                                    _bloc?.addSection.add(s.data![i].sectionName!);
                                    _bloc?.addSectionId.add(s.data![i].sectionId!);
                                    _bloc!.getStudents(s.data![i].sectionId!);
                                    break;
                                  }
                                }
                              },
                            )
                               ;
                          }
                      ):SizedBox();
                    }

                ),
                const SizedBox(height: 20,),
                StreamBuilder<List<StudentList>>(
                    initialData: [],
                    stream: _bloc?.studentList,
                    builder: (context, s){
                      List<String> value = [];
                      if (s.data!.isNotEmpty) {
                        for (int i = 0; i < s.data!.length; i++) {
                          value.add(s.data![i].firstName!+" "+s.data![i].lastName!);
                        }
                        value=value.toSet().toList();
                      }
                      return (value.isNotEmpty) ?StreamBuilder<String>(
                          initialData:value.first,
                          stream: _bloc?.studentName,
                          builder: (context, snapshot) {
                            return  CustomDropdown(
                              hint: 'Select Student',
                              dropdownItems: value,
                              buttonWidth: 500,
                              buttonHeight: 60,
                              value: snapshot.data,
                              onChanged: (value) {
                                for (int i = 0; i < s.data!.length; i++) {
                                  if(value==s.data![i].firstName!+" "+s.data![i].lastName!) {
                                    _bloc!.addStudent.add(s.data![i].firstName!+" "+s.data![i].lastName!);
                                    _bloc?.addStudentId.add(s.data![i].id!);
                                    break;
                                  }
                                }
                              },
                            );
                          }
                      ):TextField(
                        decoration:  InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          hintText: 'No student',
                        ),
                        onTap: () async {
                        },

                      );
                    }
                ),
                const SizedBox(height: 20,),
                StreamBuilder<List<FeeTypes>>(
                    initialData: [],
                    stream: _bloc?.feeTypesList,
                    builder: (context, s){
                      List<String> value1 = [];
                      if (s.data!.isNotEmpty) {
                        for (int i = 0; i < s.data!.length; i++) {
                          value1.add(s.data![i].feeName!);
                        }
                      }
                      return (value1.isNotEmpty) ?StreamBuilder<String>(
                          initialData: null,
                          stream: _bloc?.feeType,
                          builder: (context, snapshot) {
                            return  CustomDropdown(
                              hint: 'Fee Type ',
                              dropdownItems: value1,
                              buttonWidth: 500,
                              buttonHeight: 60,
                              value: snapshot.data,
                              onChanged: (value) {
                                for (int i = 0; i < s.data!.length; i++) {
                                  if(value==s.data![i].feeName!) {
                                    _bloc?.addFeeType.add(s.data![i].feeName!);
                                    _bloc?.addFeeTypeId.add(s.data![i].feeType!.toString());
                                    _bloc!.addFeeId.add(s.data![i].id.toString());
                                    _bloc!.addAmount.add(s.data![i].feeAmount.toString());
                                    break;
                                  }
                                }

                              },
                            )
                               ;
                          }
                      ):SizedBox();
                    }

                ),
                const SizedBox(height: 20,),
                StreamBuilder<String>(
                  initialData: '',
                  stream: _bloc!.amount,
                  builder:(c,s)=>
                      Container(
                        height: 60,
                        width: 500,
                        decoration:BoxDecoration(
                        border: Border.all(color:Colors.black ),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: Container(
                            padding: EdgeInsets.all(15),
                            child: Text('${(s.data!)} Rupees',style: TextStyle(fontSize: 18,fontFamily: WorkSans.regular,color:PSColors.text_black_color ),)),


                      ),

                ),
                const SizedBox(height: 20,),

               /* StreamBuilder<String>(
                  initialData: '',
                  stream: _bloc!.paidDateStream,
                  builder:(c,s)=>
                      TextField(
                        decoration:  InputDecoration(
                          suffixIcon: Icon(Icons.calendar_month),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          hintText: 'Paid Date',
                        ),
                        controller: TextEditingController(text: s.data!),
                        onTap: () async {
                          _bloc!.getStateDate(1);
                        },

                      ),

                ),*/
                const SizedBox(height:50,),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    child: Text('Add Fee',style: TextStyle(color: Colors.white)),
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>( PSColors.app_color),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: const BorderRadius.only(
                                    topLeft:Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                    topRight:Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0)
                                ),
                                side: BorderSide(color: PSColors.app_color,width: 1)
                            )
                        )
                    ),
                    onPressed: () {
                      _bloc?.student_fee_submit.add(null);
                    },
                  ),
                )



              ],

            ),
          )
        ),
      ),





    );
  }

}