

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:publicschool_app/common/widgets/load_container/load_container.dart';
import 'package:publicschool_app/utilities/fonts.dart';
import 'package:publicschool_app/utilities/ps_colors.dart';

import '../../../app/arch/bloc_provider.dart';
import '../../../common/widgets/dropdown/custom_dropdown.dart';
import '../../../model/exams/exams_item.dart';
import '../../../model/sections/sections_data.dart';
import '../../../model/subject/subject_list_data.dart';
import '../bloc/add_exam_bloc.dart';
import '../bloc/exams_list_bloc.dart';

class AddExam extends StatefulWidget {
  @override
  AddExamState createState() => AddExamState();

}
class AddExamState extends State<AddExam> {
  StudentExamsBloc? bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PSColors.bg_color,
      appBar: AppBar(
          backgroundColor: PSColors.app_color,
          centerTitle: true,
          title: Text("Add Exam List",
            style: TextStyle(fontSize: 20, fontFamily: WorkSans.semiBold),)
      ),
      body: LoaderContainer(
        stream: bloc?.isLoading,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(children: [
                  Expanded(
                      flex:4,
                      child: Text('Exam Title Name',style: TextStyle(fontSize: 14,fontFamily: WorkSans.semiBold,color: PSColors.text_color),)),
                  Expanded(
                      flex:6,child:SizedBox(
                    height: 35,
                    child:TextField(
                      style: TextStyle(fontSize: 14,fontFamily: WorkSans.semiBold,color: PSColors.text_color),
                      decoration:   InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(1),
                            borderSide: BorderSide(color: PSColors.hint_text_color, width: 1)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: PSColors.hint_text_color, width: 1)),
                      ),
                      onChanged: (value){
                        bloc!.addExamName.add(value);
                      },


                    ),
                  )

                  )
                ],),
                SizedBox(height: 15,),
                Row(children: [
                  Expanded(
                      flex:4,
                      child: Text('Exam starting date',style: TextStyle(fontSize: 14,fontFamily: WorkSans.semiBold,color: PSColors.text_color),)),
                  Expanded(
                      flex:6,child:SizedBox(
                      height: 35,
                      child:StreamBuilder<String>(
                        initialData: '',
                        stream: bloc!.startDateStream,
                        builder: (c,s){
                          return TextField(
                            controller: TextEditingController(text:s.data),
                            style: TextStyle(fontSize: 14,fontFamily: WorkSans.semiBold,color: PSColors.text_color),
                            decoration:   InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(1),
                                  borderSide: BorderSide(color: PSColors.hint_text_color, width: 1)
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: PSColors.hint_text_color, width: 1)),
                            ),
                            readOnly: true,
                            onTap: () async {
                              bloc!.getStateDate(2);
                            },

                          );
                        },)
                  )

                  )
                ],),
                SizedBox(height: 15,),
                Row(children: [
                  Expanded(
                      flex:4,
                      child: Text('Exam ending date',style: TextStyle(fontSize: 14,fontFamily: WorkSans.semiBold,color: PSColors.text_color),)),
                  Expanded(
                      flex:6,child:SizedBox(
                    height: 35,
                    child:StreamBuilder<String>(
                      initialData: '',
                      stream: bloc!.endDateStream,
                      builder: (c,s){
                        return TextField(
                          controller: TextEditingController(text:s.data),
                          style: TextStyle(fontSize: 14,fontFamily: WorkSans.semiBold,color: PSColors.text_color),
                          decoration:   InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(1),
                                borderSide: BorderSide(color: PSColors.hint_text_color, width: 1)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: PSColors.hint_text_color, width: 1)),
                          ),
                          readOnly: true,
                          onTap: () async {
                            bloc!.getEndDate(2);

                          },

                        );
                      },),
                  )

                  )
                ],),
                SizedBox(height: 15,),
                Row(children: [
                  Expanded(
                      flex:4,
                      child: Text('Class',style: TextStyle(fontSize: 14,fontFamily: WorkSans.semiBold,color: PSColors.text_color),)),
                  Expanded(
                      flex:6,child:SizedBox(
                    height: 35,
                    child:StreamBuilder<List<ClassList>>(
                        initialData: [],
                        stream: bloc!.classList,
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
                              stream: bloc!.class_name,
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
                                        bloc!.getSections({"action":"section-list","class_id":s.data![i].classId!},1);
                                        bloc!.addClassId.add(s.data![i].classId!);
                                        bloc!.addClass.add(value!);
                                        break;
                                      }
                                    }
                                  },
                                );
                              }
                          ):const SizedBox();
                        }

                    ),
                  )

                  )
                ],),
                SizedBox(height: 15,),
                Row(children: [
                  Expanded(
                      flex:4,
                      child: Text('Section',style: TextStyle(fontSize: 14,fontFamily: WorkSans.semiBold,color: PSColors.text_color),)),
                  Expanded(
                      flex:6,child:SizedBox(
                    height: 35,
                    child: StreamBuilder<List<SectionsList>>(
                        initialData: [],
                        stream: bloc!.sectionsList,
                        builder: (context, s){
                          List<String> value = [];
                          if (s.data!.isNotEmpty) {
                           // bloc!.addSection.add(s.data![0].sectionName!);
                            for (int i = 0; i < s.data!.length; i++) {
                              value.add(s.data![i].sectionName!);
                            }
                            value=value.toSet().toList();
                          }
                          return (value.isNotEmpty) ?StreamBuilder<String>(
                              initialData: null,
                              stream: bloc!.sectionName,
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
                                        bloc!.addSection.add(s.data![i].sectionName!);
                                        bloc!.addSectionId.add(s.data![i].sectionId!);
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
                  )

                  )
                ],),
                SizedBox(height: 15,),
                Row(
                  children: [
                    Expanded(
                        flex:5,
                        child: Text('Exam Date',style: TextStyle(fontSize: 14,fontFamily: WorkSans.semiBold,color: PSColors.text_color),)),
                    SizedBox(width: 10,),
                    Expanded(
                        flex:4,
                        child: Text('Subject Name',style: TextStyle(fontSize: 14,fontFamily: WorkSans.semiBold,color: PSColors.text_color),)),
                    SizedBox(width: 10,),
                    Expanded(
                        flex: 1,
                        child: Text('',style: TextStyle(fontSize: 14,fontFamily: WorkSans.semiBold,color: PSColors.text_color),)),

                  ],
                ),

                StreamBuilder<List<ExamsItem>>(
                    initialData: [],
                    stream: bloc!.examItem,
                    builder: (context, snapshot) {
                      return Column(
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (c,s){
                                return  Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            flex:5,
                                            child: Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.only(top: 10),
                                              height: 45,
                                              padding: EdgeInsets.only(left: 5),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(color: PSColors.hint_text_color,width: 1),
                                                  borderRadius: BorderRadius.all(Radius.circular(1))),
                                              child:TextField(
                                                readOnly:true,
                                                onTap: () => bloc!.getExamDate(snapshot.data!,s),
                                                controller:TextEditingController(text:snapshot.data![s].examDate),
                                                style: TextStyle(fontSize: 14,fontFamily: WorkSans.semiBold,color: PSColors.text_color),
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                ),

                                              ),
                                            )),
                                        SizedBox(width: 10,),
                                        Expanded(
                                            flex:4,
                                            child: Container(
                                              margin: EdgeInsets.only(top: 10),
                                              height: 45,
                                              child:CustomDropdown(
                                                hint: 'Select Subject',
                                                dropdownItems: bloc!.value,
                                                buttonWidth: 500,
                                                buttonHeight: 60,
                                                value: snapshot.data![s].subjectName,
                                                onChanged: (value) {
                                                  for (int i = 0; i <  bloc!.subjectsList.length; i++) {
                                                    if(value==bloc!.subjectsList[i].subjectName!) {
                                                      snapshot.data![s].subjectName=value;
                                                      snapshot.data![s].subjectId=bloc!.subjectsList[i].id!;
                                                      bloc!.addExamItem.add( snapshot.data!);
                                                      break;
                                                    }

                                                  }
                                                },
                                              )

                                              /*StreamBuilder<List<SubjectList>>(
                                            initialData: [],
                                            stream: bloc.subjects,
                                            builder: (context, s){
                                              List<String> value = [];
                                              if (s.data!.isNotEmpty) {
                                                bloc.addSubject.add(s.data![0].subjectName!);
                                                for (int i = 0; i < s.data!.length; i++) {
                                                  value.add(s.data![i].subjectName!);
                                                }
                                                value=value.toSet().toList();
                                              }
                                              return (value.isNotEmpty) ?StreamBuilder<String>(
                                                  initialData: '',
                                                  stream: bloc.subject,
                                                  builder: (context, snapshot) {
                                                    return (snapshot.data!.isNotEmpty)
                                                        ? CustomDropdown(
                                                      hint: 'Select Subject',
                                                      dropdownItems: value,
                                                      buttonWidth: 500,
                                                      buttonHeight: 60,
                                                      value: snapshot.data,
                                                      onChanged: (value) {

                                                        for (int i = 0; i < s.data!.length; i++) {
                                                          if(value==s.data![i].subjectName!) {
                                                            bloc.addSubject.add(s.data![i].subjectName!);
                                                            bloc.addSubjectId.add(s.data![i].id!);
                                                            break;
                                                          }

                                                        }
                                                      },
                                                    )
                                                        : const SizedBox();
                                                  }
                                              ):SizedBox();
                                            }

                                        )*/,
                                            )),
                                        SizedBox(width: 10,),
                                        Expanded(
                                            flex: 1,
                                            child: GestureDetector(
                                                onTap:() =>  bloc!.updateList(s),
                                                child: Center(child: Image(image: AssetImage('assets/images/delete.png'),height: 30,width: 30,)))),


                                      ],
                                    ),

                                    SizedBox(height: 10,),
                                  ],
                                );
                              }
                          ),
                        ],
                      );
                    }
                ),

                SizedBox(height: 15,),
                Row(
                  children: [
                    Expanded(flex:3,child:  ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.indigo)),
                        onPressed: () {
                          bloc!.addRowData();


                        },
                        child: const Text(
                            "Add Row", style: TextStyle(fontFamily:'Inter', color: Color(0xffffffff), fontSize: 12, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, letterSpacing: 0,))
                    ),
                    ),
                    Expanded(flex:3,child: SizedBox(),),
                    Expanded(flex:3,child:  ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(PSColors.app_color)),
                        onPressed: () {
                          bloc!.add_exam.add(null);
                        },


                        child: const Text("Add Exam", style: TextStyle(fontFamily:'Inter', color: Color(0xffffffff), fontSize: 12, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal,letterSpacing: 0,))
                    ),
                    )
                  ],
                )

              ],
            ),
          ),
        ),

      ),

    );
  }


}


