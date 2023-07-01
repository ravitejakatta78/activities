import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:publicschool_app/app/arch/bloc_provider.dart';
import 'package:publicschool_app/common/widgets/load_container/load_container.dart';
import 'package:publicschool_app/di/app_injector.dart';
import 'package:publicschool_app/di/i_faculity_attendance.dart';
import 'package:publicschool_app/helper/logger/logger.dart';
import 'package:publicschool_app/model/faculty/faculty_list_data.dart';
import 'package:publicschool_app/model/subject/faculity_list.dart';
import 'package:publicschool_app/pages/attendance/widget/attendance_history.dart';
import 'package:publicschool_app/pages/attendance/widget/faculty_register.dart';
import 'package:publicschool_app/utilities/constants.dart';
import 'package:publicschool_app/utilities/fonts.dart';
import 'package:vibration/vibration.dart';
import '../../common/widgets/no_data/no_data.dart';
import '../../model/login/login_response.dart';
import '../../utilities/ps_colors.dart';

import 'bloc/faculty_attendance_bloc.dart';

class FacultyAttendance extends StatefulWidget{

  @override
  FacultyAttendanceState createState() => FacultyAttendanceState();

}
class FacultyAttendanceState extends State<FacultyAttendance> {

  late FacultyAttendanceBloc _bloc;
  UserDetails? userDetails;
  String? facultyId;
  String? name;
  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    getUser();
  }

  @override
  Widget build(BuildContext context) {

    return LoaderContainer(
      child: Material(
        type: MaterialType.transparency,
      child:Container(
        height: MediaQuery.of(context).size.height,
        color: PSColors.bg_color,
        child: SingleChildScrollView(
          child: StreamBuilder<String>(
              initialData: Constants.school,
              stream: _bloc.roleId,
              builder: (context, snapshot) {
                return (snapshot.data==Constants.school)?Column(
                  children: [
                    Container(
                      color: PSColors.app_color,
                      padding: EdgeInsets.only(top: 30),
                      height: 100,
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: (){
                                Get.back();
                              },
                              child:  Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.arrow_back,color: Colors.white,),
                              )),
                           Expanded(
                             child: Center(
                               child: Text('Attendance History',style: TextStyle(fontSize: 20,fontFamily: WorkSans.semiBold,color: Colors.white),),
                             ),
                           ),

                        ],


                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10,right: 10,top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 5,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width/3.5,
                              height: 50,
                              child: ElevatedButton.icon(
                                icon: Icon(
                                  Icons.calendar_today_outlined,
                                  color: PSColors.hint_text_color,
                                  size: 25.0,
                                ),
                                label: StreamBuilder<String>(
                                    initialData: 'Start Date',
                                    stream: _bloc.startDateStream,
                                    builder: (context, snapshot) {
                                      return Text(snapshot.data!);
                                    }
                                ),
                                onPressed: () {
                                  _bloc.getStartDate();
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: HexColor('#FFFFFF'),
                                  onPrimary: PSColors.text_color,
                                  shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 15,),
                          Expanded(
                            flex: 5,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width/3.5,
                              height: 50,
                              child: ElevatedButton.icon(
                                icon: Icon(
                                  Icons.calendar_today_outlined,
                                  color: PSColors.hint_text_color,
                                  size: 25.0,
                                ),
                                label: StreamBuilder<String>(
                                    initialData: 'End Date',
                                    stream: _bloc.endDateStream,
                                    builder: (context, snapshot) {
                                      return Text(snapshot.data!);
                                    }
                                ),
                                onPressed: () {
                                  _bloc.getEndDate();
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: HexColor('#FFFFFF'),
                                  onPrimary: PSColors.text_color,
                                  shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 15,),
                          GestureDetector(
                            onTap: ()=> _bloc.getFacultyAttendance(),
                            child: const Icon(
                              Icons.search),

                          )


                        ],
                      ),
                    ),
                    StreamBuilder<List<FacultyAttendanceHistory>?>(
                        initialData: [],
                        stream: _bloc.facultyHistory,
                        builder: (context, snapshot) {
                          return (snapshot.data!.isNotEmpty)?LoaderContainer(
                            stream: _bloc.isLoading,
                            child: Container(
                              margin: const EdgeInsets.only(left: 10,right: 10),
                              child:ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (c,s){
                                return AttendanceHistory(snapshot.data![s]);

                              })
                            ),
                          ):NoData();
                        }
                    )
                  ],
                ):Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 40),
                      height: MediaQuery.of(context).size.height/3,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Color(0xFF1AB394),
                              Color(0xFFffffff),
                            ],
                            begin: FractionalOffset(0.0, 0.0),
                            end: FractionalOffset(0.0, 1.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                      ),
                      child: Column(
                        children: [
                         Container(
                           height: 58,
                           margin: const EdgeInsets.only(bottom: 20),
                           child: Row(
                             children: [
                               Expanded(
                                 flex: 2,
                                 child: Center(
                                   child: GestureDetector(
                                       onTap: (){
                                        Get.back();
                                       },
                                       child: const Icon(Icons.arrow_back,color: Colors.white,)),
                                 ),
                               ),
                              const Expanded(
                                flex: 8,
                                child: Center(
                                  child: Text('Faculty Login',style: TextStyle(fontSize: 20,fontFamily: WorkSans.semiBold,color: Colors.white),),
                                ),
                              ),
                                Expanded(
                                 flex: 2,
                                 child: Center(
                                   child:  GestureDetector(
                                       onTap: (){
                                         Get.to(AppInjector.instance.facultyRegister(facultyId,name!));
                                       },
                                       child: Icon(Icons.history,color: Colors.white,)),
                                 ),
                               ),


                             ],


                           ),
                         ),
                          SizedBox(
                            height: 115,
                            width: 115,
                            child: CircleAvatar(
                              backgroundColor: PSColors.app_color,
                              child: const CircleAvatar(
                                radius: 60,
                                backgroundImage:
                                CachedNetworkImageProvider('https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg'),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    StreamBuilder<List<FacultyAttendanceHistory>>(
                      stream: _bloc.facultyHistory,
                      initialData: [],
                      builder: (context, snapshot) {
                        return Column(
                          children: [
                            const SizedBox(height: 40,),
                            Text('Hi,${userDetails!.firstName!}',style: TextStyle(fontSize: 20,fontFamily: WorkSans.regular,color: PSColors.text_color)),
                            const SizedBox(height: 10,),
                            (snapshot.data!.isNotEmpty)?
                            Text((snapshot.data![0].logout!=null)?'Logout at ${DateFormat('HH:mm:ss').format(convertDate(snapshot.data![0].logout!))}':'Login at ${DateFormat('HH:mm:ss').format(convertDate(snapshot.data![0].login!))}',style: TextStyle(fontSize: 12,fontFamily: WorkSans.regular,color: PSColors.text_color))
                                :Text('Login Time',style: TextStyle(fontSize: 12,fontFamily: WorkSans.regular,color: PSColors.text_color)),
                            const SizedBox(height: 30,),
                            GestureDetector(
                                onLongPress: (){
                                  Vibration.vibrate(duration: 1000);
                                  showDialog(context: Get.context!, builder: (BuildContext context){
                                    return  AlertDialog(
                                      title: Text("Are you sure want to ${(snapshot.data!.isNotEmpty)?(snapshot.data![0].logout!=null)?"Sign in ?":"Sign out ?":"Sign in ?"}" ,style: TextStyle(fontSize: 14,fontFamily: WorkSans.semiBold,color: PSColors.text_black_color),),
                                      actions: [

                                        ElevatedButton(
                                          style: ButtonStyle(
                                              foregroundColor: MaterialStateProperty.all<Color>(PSColors.app_color),
                                              backgroundColor: MaterialStateProperty.all<Color>(PSColors.app_color),
                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(14.0),
                                                      side: BorderSide(color: PSColors.app_color))
                                              )
                                          ),
                                          child:const Text('Yes',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color:Colors.white ),),
                                          onPressed: () {
                                                _bloc.addFacultyAttendance((snapshot.data!.isNotEmpty)?(snapshot.data![0].logout!=null)?"login":"logout":"login");
                                                Navigator.pop(context);
                                            }


                                        ),
                                        const SizedBox(width: 10,),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(14.0),
                                                      side:BorderSide(color: PSColors.app_color))
                                              )
                                          ),
                                          child:  Text('No',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color:PSColors.app_color ),),

                                          onPressed: () {

                                            Navigator.pop(context);
                                          },
                                        )


                                      ],
                                    );
                                  });
                                },
                                child: Image.asset('assets/images/finger_print.png',color: (snapshot.data!.isNotEmpty)?(snapshot.data![0].logout!=null)?PSColors.red_color: (snapshot.data![0].login!=null)?PSColors.app_color:Colors.indigo:Colors.indigo,)

                            ),
                            const SizedBox(height: 20,),
                            Text(
                                'Please provide thumb',
                                style:  TextStyle(fontSize: 12,fontFamily: WorkSans.semiBold,color:PSColors.text_color )),
                            RichText(
                              text:  TextSpan(
                                  text: 'to ',
                                  style:  TextStyle(fontSize: 12,fontFamily: WorkSans.semiBold,color:PSColors.text_color ),
                                  children: <TextSpan>[
                                    TextSpan(text: (snapshot.data!.isNotEmpty)?(snapshot.data![0].logout!=null)?"Login":"Logout":"Login",style:  TextStyle(fontSize: 12,fontFamily: WorkSans.semiBold,color:PSColors.app_color ))
                                  ]
                              ),
                            ),
                          ],
                        );
                      }
                    )
                  ],
                );
              }
          ),
        ),
      ),
    ));
  }

  void getUser() async{
  userDetails=await  AppInjector.instance.userDataStore.getUser();
  _bloc.addRoleId.add(userDetails!.roleId.toString());
  facultyId=userDetails!.faculityId;
  name=userDetails!.firstName.toString();
  printLog("userName", userDetails!.firstName.toString());
  _bloc.getFacultyAttendance();
  /*if(userDetails!.roleId==Constants.school) {
    _bloc.getFacultyAttendance();
  } else if(userDetails!.roleId==Constants.faculty) {
    _bloc.getFacultyAttendance();
  }*/

  }

  DateTime convertDate(String dateValue){

    DateTime parseDate = new DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateValue);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd-MM-yyyy');
    var outputDate = outputFormat.format(inputDate);
    return parseDate;
  }

}