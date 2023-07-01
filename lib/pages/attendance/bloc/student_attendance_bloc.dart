
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl/intl.dart';
import 'package:publicschool_app/model/sections/sections_data.dart';
import 'package:rxdart/rxdart.dart';

import '../../../app/arch/bloc_provider.dart';
import '../../../common/widgets/bottom_sheet/calende_bottom_sheet.dart';
import '../../../common/widgets/bottom_sheet/classes_bottom_sheet.dart';
import '../../../common/widgets/bottom_sheet/sections_bottom_sheet.dart';
import '../../../common/widgets/bottom_sheet/sessions_bottom_sheet.dart';
import '../../../helper/logger/logger.dart';
import '../../../manager/user_data_store/user_data_store.dart';
import '../../../model/dashboard/dashboard_data.dart';
import '../../../model/login/login_response.dart';
import '../../../model/subject/student.dart';
import '../../../model/subject/student_list.dart';
import '../../../model/subject/subject_list_data.dart';
import '../../../repositories/menu_list/subject_api.dart';

typedef BlocProvider<StuAttendanceBloc> StuAttendanceFactory(String type);

class StuAttendanceBloc extends BlocBase {

  String type;
  SubjectService? subjectService;
  UserDataStore? _userDataStore;
  final BehaviorSubject<String> _errorMsg=BehaviorSubject.seeded("");
  final BehaviorSubject<bool> _isLoading=BehaviorSubject.seeded(true);
  final BehaviorSubject<bool> _isChecked=BehaviorSubject.seeded(false);

  BehaviorSubject<int> _selectedPosition = BehaviorSubject.seeded(0);
  final PublishSubject<List<ClassList>> _classList=PublishSubject();
  final PublishSubject<List<Student>> _studentList=PublishSubject();
  final PublishSubject<List<SectionsList>> _sectionsList=PublishSubject();

  Stream<int> get selectedPosition  => _selectedPosition;
  Stream< List<Student>> get studentList => _studentList;
  Sink<int> get selectedPos => _selectedPosition;
  Stream<List<ClassList>> get classList => _classList;
  Stream<List<SectionsList>> get sectionsList => _sectionsList;
  String? classId="-1";
  String? section="-1";
  String? session="1";
  String? currentDate=new DateFormat('yyyy-MM-dd').format(new DateTime.now());
  Stream<bool> get isLoading => _isLoading;
  Stream<bool> get isChecked => _isChecked;
  Sink<bool> get checkedList => _isChecked;

  StuAttendanceBloc(this.type,this._userDataStore,this.subjectService);


  void getClassList(Map<String, String?> map) async {
    UserDetails? userDetails=await  _userDataStore?.getUser();
   String userId=userDetails!.usersid!;
    map.addAll({"usersid":userId});
    subjectService!.getRequest(map).then((value) {
      _isLoading.add(false);
      if(value.error==null){
        if(value.data!.status=="200"){
         if(value.data!.classList!=null){
            if(value.data!.classList!.isNotEmpty){

             // getUsers({'action':'studentList','class_id':value.data!.classList![0].classId,'usersid':userId});
             // classId=value.data!.classList![0].classId;

              openClassBottomSheet(classList:value.data!.classList!,onCallback:(classList) {
                //getUsers({'action':'studentList','class_id':classList.classId,'usersid':userId});
                classId=classList.classId;
                    studentData();
                printLog("classList", classList.className);
              },selectedPos: int.parse(classId!));
              _classList.add(value.data!.classList!);
              printLog('classList',value.data!.classList);

            }

          }

        } else _errorMsg.add('Invalid');
      }else _errorMsg.add('Invalid');
    });
  }
  void getSections(Map<String, String?> map) async {
    UserDetails? userDetails=await  _userDataStore?.getUser();
    String userId=userDetails!.usersid!;
    map.addAll({"usersid":userId,"class_id":classId});
    subjectService!.getRequest(map).then((value) {
      _isLoading.add(false);
      if(value.error==null){
        if(value.data!.status=="200"){
           if(value.data!.sectionList!=null){
            if(value.data!.sectionList!.isNotEmpty){
             // section=value.data!.sectionList![0].sectionId;
              sectionsBottomSheet(sectionsList:value.data!.sectionList!,onCallback:(sectionData) {
                section=sectionData.sectionId;
                studentData();

                printLog("SectionName", sectionData.sectionName);
              },selectedPos: int.parse(section!));


            }
          }

        } else _errorMsg.add('Invalid');
      }else _errorMsg.add('Invalid');
    });
  }

  void getSessions() {

    sessionsBottomSheet( onCallback: (value){
      session=value;
      studentData();
     // printLog("session : ",value);

    },radioValue:(session=="-1")?int.parse(session!):int.parse(session!)-1);
  }

  void getDate() {

    calenderBottomSheet(onCallback: (dateTime){
      currentDate=dateTime.toString();
      studentData();


    },selectedDate:DateTime.parse(currentDate!) ,type:1);
  }
  void studentData() async{
    UserDetails? userDetails=await  _userDataStore?.getUser();
    String userId=userDetails!.usersid!;

    if(classId!.isNotEmpty&&session!.isNotEmpty&&currentDate!.isNotEmpty&&section!.isNotEmpty){
      Map<String, String?> map={};
      getUsers({'action':'get-student-attendance','class_id':classId,'usersid':userId,'section_id':section,
        'attendance_date':currentDate.toString(),'attendance_session':session});
    }

  }
  void submit(List<Student> students) async{
    String jsonstringmap = jsonEncode(students);
    printLog("JSONWE", jsonstringmap);

    UserDetails? userDetails=await  _userDataStore?.getUser();
    String userId=userDetails!.usersid!;
    Map<String, dynamic?> map={'action':'add-student-attendance',
      'class_id':classId,'usersid':userId,
      'section_id':section,
      'attendance_date':currentDate.toString(),
      'student_list':jsonstringmap,
      'attendance_session':session};
      printLog("MapData", map);
    subjectService!.addData(map).then((value) {
      _isLoading.add(false);
      if(value.error==null){
        if(value.data!.status=="200"){
          printLog("message",value.data!.message!);
         // Navigator.pop(Get.context!);
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(
              content:  Text(value.data!.message!),
            ),
          );

        } else _errorMsg.add('Invalid');
      }else _errorMsg.add('Invalid');
    });

  }

  void getUsers(Map<String, String?> map)  {
    subjectService!.getRequest(map).then((value){
      if(value.error==null){
        if(value.data!.status=="200"){
          if(value.data!.data!=null){
            if(value.data!.data!.isNotEmpty){
              _studentList.add(value.data!.data!);

            }else _studentList.add([]);
          }

        } else _errorMsg.add('Invalid');
      }else _errorMsg.add('Invalid');
    });
  }

  void updateStudentList(List<Student>? data){
    _studentList.add(data!);
  }




}



