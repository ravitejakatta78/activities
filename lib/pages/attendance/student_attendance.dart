import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:publicschool_app/app/arch/bloc_provider.dart';
import 'package:publicschool_app/common/widgets/load_container/load_container.dart';
import 'package:publicschool_app/common/widgets/no_data/no_data.dart';
import 'package:publicschool_app/helper/logger/logger.dart';
import 'package:publicschool_app/model/subject/student.dart';
import 'package:publicschool_app/utilities/fonts.dart';
import '../../utilities/ps_colors.dart';
import 'bloc/student_attendance_bloc.dart';

class StudentAttendance extends StatefulWidget{

  @override
  StudentAttendanceState createState() => StudentAttendanceState();

}
class StudentAttendanceState extends State<StudentAttendance> {

  late StuAttendanceBloc _bloc;
  late List<Student> getStudents;
@override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _bloc.getClassList({"action":"classList"});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
       appBar: AppBar(
        backgroundColor: PSColors.app_color,
        centerTitle: true,
        title: const Text('Student Attendance',style:TextStyle(fontFamily: WorkSans.semiBold,fontSize: 20)),
        actions: [

          StreamBuilder<bool>(
            initialData: false,
            stream: _bloc.isChecked,
            builder: (c, s) {
              return Checkbox(
                  checkColor: Colors.white,
                  value: s.data , onChanged: (value){
                    _bloc.checkedList.add(value!);
                    for(var elements in getStudents){
                    if(elements.attendanceStatus == 0||elements.attendanceStatus == 2){
                      elements.attendanceStatus = 1;
                    }else {
                      elements.attendanceStatus = 1;
                    }
                    printLog("Elements", elements.attendanceStatus);
                    }
                    _bloc.updateStudentList(getStudents);

              });
            }
          )
        ],

       ),

      body:LoaderContainer(
        child: Column(
          children: [
                StreamBuilder<int>(
                  initialData: -1,
                  stream: _bloc.selectedPosition,
                  builder: (context, snapshot) {
                    return Container(
                      height: 45,
                      margin: const EdgeInsets.all(10),
                      child: ListView.builder(
                        itemCount: 4,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (c,s){
                          return Container(
                              width: 120,
                              margin: const EdgeInsets.all(5),
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: ElevatedButton.icon(
                                  onPressed: (){
                                    _bloc.selectedPos.add(s);

                                  if(s==0) {
                                    _bloc.checkedList.add(false);
                                      _bloc.getClassList({"action":"classList"});
                                    }else if(s==1){
                                    _bloc.checkedList.add(false);
                                      _bloc.getSections({"action":"section-list"});
                                    } else if(s==2){
                                    _bloc.checkedList.add(false);
                                      _bloc.getDate();
                                    } else{
                                    _bloc.checkedList.add(false);
                                      _bloc.getSessions();

                                    }

                                  },
                                  label: Text((s==0)?'Classes':(s==1)?'Sections':(s==2)?'Calender':'Sessions',style: TextStyle(fontSize: 14,fontFamily:WorkSans.medium,color: (snapshot.data!=s)?PSColors.text_color:Colors.white),),
                                  icon: Icon((s==0)?Icons.menu_book_outlined:(s==1)?Icons.supervisor_account_outlined:(s==2)?Icons.calendar_month_rounded:Icons.supervisor_account_outlined,size: 16,color: (snapshot.data!=s)?PSColors.app_color:Colors.white,),
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



                StreamBuilder<List<Student>>(
                initialData: [],
                stream: _bloc.studentList,
                builder: (context, snapshot) {
                  getStudents=snapshot.data!;
                  return(snapshot.data!.isNotEmpty)? Container(
                    height: MediaQuery.of(context).size.height-200,
                    margin: const EdgeInsets.all(10),
                    child:Stack(
                      children: [
                        GridView.count(
                          crossAxisCount: 3,
                          childAspectRatio: (1 / 1.2),
                          shrinkWrap: true,
                          children: List.generate(snapshot.data!.length, (index) {
                            return GestureDetector(
                              onTap: (){
                                if( getStudents[index].attendanceStatus==0) {
                                  getStudents[index].attendanceStatus=1;
                                } else if( getStudents[index].attendanceStatus==1) {
                                  getStudents[index].attendanceStatus=2;
                                }else if( getStudents[index].attendanceStatus==2) {
                                  getStudents[index].attendanceStatus=1;
                                }

                                _bloc.updateStudentList(getStudents);


                           },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 85,
                                      width: 85,
                                      child: CircleAvatar(
                                        backgroundColor: (snapshot.data![index].attendanceStatus==0)?Colors.grey:(snapshot.data![index].attendanceStatus==1)?PSColors.app_color:(snapshot.data![index].attendanceStatus==2)?PSColors.red_color:(snapshot.data![index].attendanceStatus==3)?Colors.deepOrange:PSColors.app_color,
                                        child: CircleAvatar(
                                          radius: 40,
                                          backgroundImage:
                                          CachedNetworkImageProvider((snapshot.data![index].studentImg!=null)?snapshot.data![index].studentImg!:
                                          'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg'),
                                          backgroundColor: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5,),
                                    Text("${snapshot.data![index].studentName} ",style:  TextStyle(fontSize: 12,fontFamily: WorkSans.regular,color: PSColors.text_black_color)),

                                  ],
                                )
                              ),
                            );
                          }),
                        ),
                        Positioned(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: (getStudents.isNotEmpty)?SizedBox(
                              height: 35,
                              width: 315,
                              child: ElevatedButton(onPressed: (){
                                _bloc.submit(getStudents);

                               // Get.to(AppInjector.instance.dashboard);
                              }, style: ElevatedButton.styleFrom(
                                  shape: const RoundedRectangleBorder(),
                                  primary: PSColors.app_color



                              ),
                                  child: const Text('Attendance',style: TextStyle(fontFamily: WorkSans.semiBold,fontSize: 14),)),
                            ):const SizedBox(),
                          ),
                        ),
                      ],
                    ),
                  ):NoData();
                }
            ),





          ],
        ),

      )



    );
  }

}