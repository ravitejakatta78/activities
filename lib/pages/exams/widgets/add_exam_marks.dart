

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:publicschool_app/common/widgets/load_container/load_container.dart';
import 'package:publicschool_app/helper/logger/logger.dart';
import 'package:publicschool_app/model/exams/exams_marks.dart';
import 'package:toast/toast.dart';
import '../../../app/arch/bloc_provider.dart';
import '../../../common/widgets/dropdown/custom_dropdown.dart';
import '../../../model/exams/exams_data.dart';
import '../../../model/exams/exams_marks.dart';
import '../../../model/exams/exams_marks.dart';
import '../../../model/subject/student_list.dart';
import '../../../utilities/fonts.dart';
import '../../../utilities/ps_colors.dart';
import '../bloc/add_exams_marks_bloc.dart';

class AddExamMarks extends StatefulWidget{

  @override
  AddExamMarksState createState() => AddExamMarksState();

}
class AddExamMarksState extends State<AddExamMarks>{
  AddExamMarksBloc? _bloc;
  List<SubjectMarks> subjectMarksList=[];
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _controller = new TextEditingController();
    _controller!.text="";
   // _controller!.selection = TextSelection.collapsed(offset: _controller!.text.length);
    ToastContext().init(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PSColors.app_color,
        centerTitle: true,
        title: const Text('Add Exam Marks',style:TextStyle(fontSize: 20,fontFamily: WorkSans.semiBold)),
      ),
      body: LoaderContainer(
        stream: _bloc!.isLoading,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder<List<StudentList>>(
                    initialData: [],
                    stream: _bloc!.students,
                    builder:(c,s) {
                List<String> value = [];
                if (s.data!.isNotEmpty) {
                for (int i = 0; i < s.data!.length; i++) {
                value.add(s.data![i].firstName!+" "+s.data![i].lastName!);
               // _bloc!.addStudentName.add(s.data![0].firstName!+" "+s.data![0].lastName!);
                _bloc!.addStudentId.add(s.data![0].id!);
                }
                }
                return (s.data!.isNotEmpty) ?StreamBuilder<String>(
                initialData: null,
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
                      _bloc!.addStudentName.add(s.data![i].firstName!+" "+s.data![i].lastName!);
                      _bloc!.addStudentId.add(s.data![i].id!);
                      _bloc!.getStudentMarks(s.data![i].id!);
                      subjectMarksList=[];
                      break;
                    }
                  }

                },
                ) ;
                }
                ):const SizedBox();
                }),
                SizedBox(height: 10,),
                StreamBuilder<ExamsList>(
                    initialData: null,
                    stream: _bloc!.getExamsList,
                    builder: (c,s){
                      return(s.data!=null)? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(flex:2,child: Text("Class Name : ",textAlign: TextAlign.center,style: TextStyle(fontFamily: WorkSans.regular,fontSize: 14,color: PSColors.text_black_color),)),

                              Expanded(flex:5,child: Text("${(s.data!.sectionName!.isNotEmpty)?(s.data!.className!+"-"+s.data!.sectionName!):s.data!.className!}",textAlign: TextAlign.start,style: TextStyle(fontFamily: WorkSans.semiBold,fontSize: 13,color: PSColors.text_black_color),)),
                            ],
                          ),
                          SizedBox(height: 5,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(flex:2,child: Text("Exam Name : ",textAlign: TextAlign.center,style: TextStyle(fontFamily: WorkSans.regular,fontSize: 14,color: PSColors.text_black_color),)),
                              Expanded(flex:5,child: Text(s.data!.examName!,textAlign: TextAlign.start,style: TextStyle(fontFamily: WorkSans.semiBold,fontSize: 13,color: PSColors.text_black_color),)),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(flex:2,child: Text("Start Date   : ",textAlign: TextAlign.center,style: TextStyle(fontSize: 14,color: PSColors.text_black_color,fontFamily: WorkSans.regular),)),
                              Expanded(flex:5,child: Text(s.data!.examStartDate!,textAlign: TextAlign.start,style: TextStyle(fontSize: 13,color: PSColors.text_black_color,fontFamily: WorkSans.semiBold),)),

                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(flex:2,
                                  child: Text("End Date     : ",textAlign: TextAlign.center,style: TextStyle(fontSize: 14,color: PSColors.text_black_color,fontFamily: WorkSans.regular),)),
                              Expanded(flex:5,
                                  child: Text(s.data!.examEndDate!,textAlign: TextAlign.start,style: TextStyle(fontSize: 13,color: PSColors.text_black_color,fontFamily: WorkSans.semiBold),)),

                            ],
                          ),
                        ],

                      ):SizedBox();

                    }),
                StreamBuilder<List<SubjectMarks>>(
                    initialData: [],
                    stream: _bloc!.studentMarks,
                    builder: (c,s){
                      return (s.data!=null)?Column(
                        children: [
                          const SizedBox(height: 15,),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                Expanded(
                                    flex:5,
                                    child: Text("Subject name",style: TextStyle(fontFamily: WorkSans.bold,fontSize: 16,color: PSColors.text_color))),
                                Expanded(
                                    flex:6,
                                    child: Text("Marks",textAlign: TextAlign.center,style: TextStyle(fontFamily: WorkSans.bold,fontSize: 16,color: PSColors.text_color))),
                              ],
                            ),
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: s.data!.length,
                              itemBuilder: (c,j){
                               // printLog("Marks", s.data![j].marks);
                                return Container(
                                  height: 50,
                                  margin: EdgeInsets.only(top: 10),
                                  padding: EdgeInsets.only(left: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.white, //background color
                                    border: Border.all(
                                        color: PSColors.box_border_color// border color
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex:3,
                                          child: Text(s.data![j].subjectName!,style: TextStyle(fontFamily: WorkSans.bold,fontSize: 14,color: PSColors.text_color))),
                                      VerticalDivider(
                                        color: PSColors.box_border_color,
                                        thickness: 1,
                                        width: 10,
                                      ),
                                      Expanded(
                                          flex:7,
                                          child:TextFormField(
                                            controller: TextEditingController.fromValue(
                                                new TextEditingValue(
                                                    text: s.data![j].marks,
                                                    selection: new TextSelection.collapsed(
                                                        offset: s.data![j].marks.length))),
                                            textInputAction: TextInputAction.next,
                                            keyboardType: TextInputType.number,
                                            onChanged: (value){
                                              s.data![j].marks=value;
                                              _bloc!.addStudentMarks.add(s.data!);
                                            // printLog("ADDMarks", s.data![j].marks);
                                            },textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 14,fontFamily: WorkSans.semiBold,color: PSColors.text_color),
                                             decoration: InputDecoration(
                                               border: InputBorder.none
                                             ),

                                          ),
                                      ),

                                    ],
                                  ),
                                );


                              }

                              ),

                          Container(
                            height: 40,
                            width: 150,
                            margin:EdgeInsets.only(top:20),
                            child: ElevatedButton(onPressed: (){
                              _bloc!.addMarks.add(null);
                            },style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all<Color>(PSColors.text_color),
                                backgroundColor: MaterialStateProperty.all<Color>(PSColors.app_color_lite),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        side:  BorderSide(color: PSColors.app_color_lite))
                                )
                            ),
                                child: Text("Save",style: TextStyle(fontSize: 16,fontFamily: WorkSans.semiBold,color: PSColors.text_color),)),
                          )

                        ],
                      ):Text('No Data');

                })


              ],
            ),
          ),



        ),

      ),

 );
  }



}