

import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:publicschool_app/common/widgets/load_container/load_container.dart';
import 'package:publicschool_app/di/app_injector.dart';
import 'package:publicschool_app/utilities/constants.dart';
import 'package:publicschool_app/utilities/fonts.dart';
import 'package:publicschool_app/utilities/ps_colors.dart';

import '../../../app/arch/bloc_provider.dart';
import '../../../helper/logger/logger.dart';
import '../../../model/dashboard/dashboard_response.dart';
import '../../../model/login/login_response.dart';
import '../bloc/dashboard_bloc.dart';
import '../widgets/faculty_menu_widget.dart';
import '../widgets/menu_widget.dart';
import '../widgets/slider_widget.dart';


class DashboardPage extends StatefulWidget{

  @override
  DashboardPageState createState() => DashboardPageState();
}


class DashboardPageState  extends State<DashboardPage>{
  DashboardBloc? _bloc;
  String? roleId;
  @override
  void initState() {
    super.initState();
    _bloc=BlocProvider.of(context);
    getUser();
    _bloc!.getMenu();
  }
  getUser() async{
    UserDetails? userDetails=await  AppInjector.instance.userDataStore.getUser();
    printLog("userDetails", userDetails?.roleId);
    roleId=userDetails?.roleId;

  }
  @override
  Widget build(BuildContext context) {
    return LoaderContainer(
          stream: _bloc!.isLoading,
          child: Container(

            child:  StreamBuilder<DashboardResponse>(
                stream: _bloc!.dashboardResponse,
                builder: (b,s){
                  return  (s.data!=null)?ListView(
                    padding: EdgeInsets.only(top: 5),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Sliderwidget(schoolImages:s.data!.data!.scroolImages),
                      (roleId==Constants.school)?Column(
                        children: [
                          (s.data!.data!.features!=null)?Container(
                            alignment: Alignment.topCenter,
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Features',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize:20,fontFamily: WorkSans.bold,color: PSColors.text_black_color),
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    color: Colors.white,
                                    elevation: 3,
                                    shadowColor: Colors.blueGrey,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: MenuWidget(s.data!.data!.features),
                                    )),
                              ],
                            ),
                          ):SizedBox(),
                          (s.data!.data!.attendanceFeatures!=null)?Container(
                            alignment: Alignment.topCenter,
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Attendance',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize:20,fontFamily: WorkSans.bold,color: PSColors.text_black_color),
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    color: Colors.white,
                                    elevation: 3,
                                    shadowColor: Colors.blueGrey,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: AttendanceWidget(s.data!.data!.attendanceFeatures),
                                    )),
                              ],
                            ),
                          ):SizedBox(),
                          (s.data!.data!.attendanceStatics!=null)?Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            height: 180,
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(bottom: 40),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Attendance Statistics',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize:20,fontFamily: WorkSans.bold,color: PSColors.text_black_color),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  height: 110,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    color: Colors.white,
                                    elevation: 3,
                                    shadowColor: Colors.blueGrey,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex:1,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(height: 10,),
                                              Text(s.data!.data!.attendanceStatics.totalStudents.toString(),textAlign:TextAlign.center,
                                                style:  TextStyle(fontSize: 22,fontFamily:WorkSans.bold,color:PSColors.red_color),),
                                              SizedBox(height: 10,),
                                              Text('Total \n Students',textAlign:TextAlign.center,
                                                style:  TextStyle(fontSize: 12,fontFamily:WorkSans.regular ,color:PSColors.text_color),),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex:1,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(height: 10,),
                                              Text(s.data!.data!.attendanceStatics.totalFaculty.toString(),textAlign:TextAlign.center,
                                                style:  TextStyle(fontSize: 22,fontFamily:WorkSans.bold,color:PSColors.red_color),),
                                              SizedBox(height: 10,),
                                              Text('Total \n Faculty',textAlign:TextAlign.center,
                                                style:  TextStyle(fontSize: 12,fontFamily:WorkSans.regular,color:PSColors.text_color),),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex:1,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(height: 10,),
                                              Text(s.data!.data!.attendanceStatics.attendedStudents.toString(),textAlign:TextAlign.center,
                                                style:  TextStyle(fontSize: 22,fontFamily:WorkSans.bold,color:PSColors.app_color),),
                                              SizedBox(height: 10,),
                                              Text('Students Present',textAlign:TextAlign.center,
                                                style:  TextStyle(fontSize: 12,fontFamily:WorkSans.regular,color:PSColors.text_color),),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex:1,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(height: 10,),
                                              Text(s.data!.data!.attendanceStatics.attendedFaculty.toString(),textAlign:TextAlign.center,
                                                style:  TextStyle(fontSize: 22,fontFamily:WorkSans.bold,color:PSColors.app_color),),
                                              SizedBox(height: 10,),
                                              Text('Faculty \n  Present',textAlign:TextAlign.center,
                                                style:  TextStyle(fontSize: 12,fontFamily:WorkSans.regular,color:PSColors.text_color),),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ):SizedBox(),
                        ],
                      ):Column(children: [
                        (s.data!.data!.attendanceFeatures!=null)?Container(
                          alignment: Alignment.topCenter,
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Attendance',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize:20,fontFamily: WorkSans.bold,color: PSColors.text_black_color),
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  color: Colors.white,
                                  elevation: 3,
                                  shadowColor: Colors.blueGrey,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AttendanceWidget(s.data!.data!.attendanceFeatures),
                                  )),
                            ],
                          ),
                        ):SizedBox(),
                        (s.data!.data!.features!=null)?Container(
                          alignment: Alignment.topCenter,
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Features',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize:20,fontFamily: WorkSans.bold,color: PSColors.text_black_color),
                                ),
                              ),
                              FacultyMenuWidget(s.data!.data!.features),

                              SizedBox(height: 10,)

                            ],
                          ),
                        ):SizedBox(),
                      ],),


                      Container(
                        color: PSColors.app_color,
                        child: CalendarTimeline(
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1940, 1, 15),
                          lastDate: DateTime(2025, 11, 20),
                          onDateSelected: (date) {


                          },
                          leftMargin: 15,
                          monthColor:  PSColors.bg_color,
                          dayColor:  PSColors.bg_color,
                          activeDayColor: PSColors.bg_color,
                          activeBackgroundDayColor: PSColors.app_grdi_color,
                          locale: 'en_ISO',
                        ),
                      )
                    ],


                  )
                  :const SizedBox();
                }),



          ),
    );
  }
}