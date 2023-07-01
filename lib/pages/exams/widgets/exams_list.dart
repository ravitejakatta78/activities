import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:publicschool_app/common/widgets/load_container/load_container.dart';
import 'package:publicschool_app/di/i_student_exams.dart';
import 'package:publicschool_app/di/i_subject_list.dart';
import 'package:publicschool_app/helper/logger/logger.dart';
import 'package:publicschool_app/model/exams/exams_data.dart';
import 'package:publicschool_app/model/subject/student_list.dart';
import 'package:publicschool_app/pages/exams/bloc/exams_list_bloc.dart';
import 'package:publicschool_app/pages/exams/widgets/exam.dart';
import '../../../app/arch/bloc_provider.dart';
import '../../../common/widgets/bottom_sheet/add_exam_botttom_sheet.dart';
import '../../../di/app_injector.dart';
import '../../../utilities/fonts.dart';
import '../../../utilities/ps_colors.dart';
import '../../students/widgets/student_item.dart';

class StudentExams extends StatefulWidget {
  @override
  StudentExamsState createState() => StudentExamsState();
}
class StudentExamsState extends State<StudentExams>{
  late StudentExamsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);

  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      initialData: 0,
      stream: _bloc.ScreenType,
      builder: (context, sn) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: PSColors.app_color,
            centerTitle: true,
            title:  Text((sn.data==0)?'Students':'Exams',style:TextStyle(fontSize: 20)),
          ),
          body: LoaderContainer(
            stream: _bloc.isLoading,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  StreamBuilder<int>(
                      initialData: -1,
                      stream: _bloc.selectedPosition,
                      builder: (context, snapshot) {
                        return Container(
                          height: 50,
                          margin: const EdgeInsets.all(10),
                          alignment: Alignment.centerLeft,
                          child: ListView.builder(
                            itemCount: 2,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (c,s){
                              return Container(
                                  height: 50,
                                  width: 150,
                                  margin: const EdgeInsets.all(5),
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: ElevatedButton.icon(
                                        onPressed: (){
                                          _bloc.isAddClick.add(false);
                                          _bloc.selectedPos.add(s);
                                          if(s==0) {
                                            _bloc.getClassList({"action":"classList"},0);
                                          }else{
                                            _bloc.getSections({"action":"section-list"},0);
                                          }

                                        },
                                        label: Text((s==0)?'Classes':'Sections',style: TextStyle(fontSize: 16,fontFamily:WorkSans.medium,color: (snapshot.data!=s)?PSColors.text_color:Colors.white),),
                                        icon: Icon((s==0)?Icons.menu_book_outlined:(s==1)?Icons.supervisor_account_outlined:
                                        (s==1)?Icons.calendar_today_rounded:Icons.calendar_today_rounded,size: 16,color: (snapshot.data!=s)?PSColors.app_color:Colors.white,),
                                        style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all((snapshot.data!=s)?Colors.white:PSColors.app_color),
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(5.0),
                                                    side: BorderSide(color: PSColors.app_color)
                                                )
                                            )
                                        )
                                    ),
                                  )
                              );
                            },

                          ),
                        );
                      }
                  ),
                  StreamBuilder<bool>(
                      initialData: false,
                      stream: _bloc.listValid,
                      builder: (context, snapshot) {
                        if(snapshot.data!)
                          _bloc.get_exam_list.add(null);

                        return SizedBox();
                      }
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: (sn.data==0)?StreamBuilder<List<StudentList>?>(
                        initialData: [],
                        stream: _bloc.studentList,
                        builder: (context, sna) {
                          return (sna.data!.isNotEmpty)?ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:sna.data!.length ,
                              itemBuilder: (c,s){
                                return StudentItem(studentList:sna.data![s],onCallback: (int type,StudentList student){
                                  if(type==0){
                                    Get.to(AppInjector.instance.studentAdd(student))!.then((value) => _bloc.get_exam_list.add(null));
                                  }
                                });
                              })
                         :Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image(image: AssetImage('assets/images/library.png'),),
                              SizedBox(height: 10,),
                              Text("Click filter to get more information",style: TextStyle(fontSize: 14,fontFamily: WorkSans.semiBold,color: PSColors.text_color),)
                            ],
                          );

                        }
                    ): StreamBuilder<List<ExamsList>?>(
                        initialData: [],
                        stream: _bloc.studentExamsList,
                        builder: (context, snapshot) {
                          return (snapshot.data!.isNotEmpty)?ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:snapshot.data!.length ,
                              itemBuilder: (c,s){
                                return Exam(examsList: snapshot.data![s],onCallBack:(type, examsList) {
                                  (type==2)?_bloc.deleteExam(examsList):printLog("title", examsList.examId);
                                });
                              })
                          /*GridView.count(
                          padding: EdgeInsets.all(10),
                          crossAxisCount: 2,
                          childAspectRatio: (2.1 / 2.3),
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          shrinkWrap: true,
                          children: List.generate(snapshot.data!.length, (index) {
                            return Exam(examsList: snapshot.data![index],onCallBack:(type, examsList) {
                              (type==2)?_bloc.deleteExam(examsList):printLog("title", examsList.examId);
                            });

                          }),
                        )*/:Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image(image: AssetImage('assets/images/library.png'),),
                              SizedBox(height: 10,),
                              Text("Click filter to get more information",style: TextStyle(fontSize: 14,fontFamily: WorkSans.semiBold,color: PSColors.text_color),)
                            ],
                          );

                        }
                    ),



                  ),


                ],


              ),
            ),

          ),
          floatingActionButton: DraggableFab(child: FloatingActionButton(

            child: Icon(Icons.add,color:Colors.white,),
            backgroundColor: PSColors.app_color,
            foregroundColor: Colors.green,
            onPressed: () {
              if(sn.data==0){
                Get.to(AppInjector.instance.studentAdd(null))!.then((value) =>_bloc.get_exam_list.add(null));
              }else {
                _bloc.isAddClick.add(true);
                openAddExamBottomSheet(_bloc);
              }
              //Get.to(AppInjector.instance.addExams(''));

            },
          ),

          ),

        );
      }
    );

  }


}