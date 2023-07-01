
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rxdart/rxdart.dart';

import '../../../app/arch/bloc_provider.dart';
import '../../../common/widgets/toast/toast.dart';
import '../../../helper/logger/logger.dart';
import '../../../manager/user_data_store/user_data_store.dart';
import '../../../model/base_response/request_response.dart';
import '../../../model/dashboard/dashboard_data.dart';
import '../../../model/login/login_response.dart';
import '../../../model/sections/sections_data.dart';
import '../../../model/subject/faculity_list.dart';
import '../../../model/subject/subject_list_data.dart';
import '../../../model/time_table/get_time_table.dart';
import '../../../repositories/menu_list/subject_api.dart';

typedef BlocProvider<AddTimeTableBloc> AddTimeTableBlocFactory(TimeTable? type);

class AddTimeTableBloc extends BlocBase {

  TimeTable? type;
  SubjectService? subjectService;
  UserDataStore? _userDataStore;
  final BehaviorSubject<String> _errorMsg=BehaviorSubject.seeded("");
  final BehaviorSubject<bool> _isLoading =BehaviorSubject.seeded(false);
  final PublishSubject<List<SubjectList>> _subjectList=PublishSubject();
  final PublishSubject<List<FaculityList>> _faculityList=PublishSubject();
  final PublishSubject<List<ClassList>> _classList=PublishSubject();
  final PublishSubject<List<SectionsList>> _sectionsList=PublishSubject();
  final BehaviorSubject<String> _className=BehaviorSubject();
  final BehaviorSubject<String> _classId=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _sectionName=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _sectionId=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _facultyName=BehaviorSubject();
  final BehaviorSubject<String> _facultyId=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _subject=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _days=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _daysId=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _time=BehaviorSubject.seeded("");

  BehaviorSubject<bool> _valid =BehaviorSubject.seeded(false);
  PublishSubject<void> _time_table_submit = PublishSubject();
  PublishSubject<Map<String,dynamic>> _submitTimeTable = PublishSubject();



  Sink<void>  get time_table_submit=> _time_table_submit;
  Sink<Map<String,dynamic>> get submitTimeTable => _submitTimeTable;

  Stream<List<SectionsList>> get sectionsList => _sectionsList;
  Stream<String> get class_name => _className;
  Sink<String> get addClass => _className;
  Stream<String> get classId => _classId;
  Sink<String> get addClassId => _classId;
  Stream<String> get facultyName => _facultyName;
  Sink<String> get addFaculty => _facultyName;
  Stream<String> get facultyId => _facultyId;
  Sink<String> get addFacultyId => _facultyId;
  Stream<String> get sectionName => _sectionName;
  Sink<String> get addSection => _sectionName;
  Stream<String> get sectionId => _sectionId;
  Sink<String> get addSectionId => _sectionId;
  Stream<String> get subject => _subject;
  Sink<String> get addSubject => _subject;
  Stream<String> get days => _days;
  Sink<String> get addDays => _days;
  Stream<String> get daysId => _daysId;
  Sink<String> get addDayId => _daysId;
  Stream<String> get time => _time;
  Sink<String> get addTime => _time;
  Stream<bool> get isLoading => _isLoading;
  Stream<List<SubjectList>> get subjectList => _subjectList;
  Stream<List<FaculityList>> get facultyList => _faculityList;
  Stream<List<ClassList>> get classList => _classList;
  Stream<String> get errorMsg => _errorMsg;
  String? userId ="";
  String? schoolId ="";

  Map<String,dynamic> addTimeTableParams = {};

  AddTimeTableBloc(this.type,this._userDataStore,this.subjectService){

    setListener();
  }
  void getInfo(){
    getClasses();
    getSubjects();
    getFaculty();
  }

  void setListener() async {

    UserDetails? userDetails=await  _userDataStore?.getUser();
    userId=userDetails!.usersid!;
    schoolId=userDetails.schoolId;
    printLog("schoolId", schoolId);

    if(type!=null){
      getInfo();
      //addDays.add('Monday');
      _daysId.add(type!.dayId.toString());
      addClass.add(type!.className.toString());
      addClassId.add(type!.classId.toString());
      addFaculty.add(type!.faculityName!);
      addFacultyId.add(type!.facultyId!);
      getSections(type!.classId.toString());
      addSection.add(type!.sectionName!);
      addSectionId.add(type!.sectionId!);
      addSubject.add(type!.sessionName!);
      addDays.add((type!.dayId.toString()=="0")?'Sunday':(type!.dayId.toString()=="1")?'Monday':(type!.dayId.toString()=="2")?'Tuesday':(type!.dayId.toString()=="3")?'Wednesday':(type!.dayId.toString()=="4")?'Thursday':(type!.dayId.toString()=="5")?'Friday':'Saturday');
      addDayId.add(type!.dayId.toString());
      _time.add(type!.sessionTime.toString());
      /*addClass.add(type!.classId.toString());
      _classId.add(type!.classId.toString());
      _subject.add(type!.sessionName.toString());
      _daysId.add(type!.dayId.toString());
      _time.add(type!.sessionTime.toString());
      _sectionName.add(type!.sectionName.toString());
      _sectionId.add(type!.sectionId.toString()); */
    }else{
      getInfo();
     // addDays.add('Sunday');
    }


    CombineLatestStream.combine6(_classId, _subject, _daysId, _time,_sectionId, _facultyId, (String a, String b, String c, String d, String e, String f) =>
    (a.isNotEmpty && b.isNotEmpty && c.isNotEmpty && d.isNotEmpty && e.isNotEmpty ) )
        .listen(_valid.add)
        .addTo(disposeBag);

    _time_table_submit
        .withLatestFrom(_valid, (_, bool v){
      printLog("title", "onPressed");
      if(v!=true) ToastMessage('Enter Details');
      return v;
    }).where((event) => event).withLatestFrom6(_classId, _subject, _daysId, _time, _sectionId, _facultyId,
            (t, String a,String b,String c,String d,String e, String f) {
      return  (type!=null)? { 'action': 'update-time-table','session_name':b,'session_time':d,'class_id':a,'day_id':c,'usersid':userId,'school_id':schoolId,'section_id':e,'time_table_id':type?.id, 'faculty_id':f,}:
      { 'action': 'add-time-table','session_name':b,'session_time':d,'class_id':a,'day_id':c,'usersid':userId,'school_id':schoolId,'faculty_id':f,'section_id':e};

            })
        .listen(_submitTimeTable.add)
        .addTo(disposeBag);

    _submitTimeTable.doOnData((_)=> _isLoading.add(true))
        .map(subjectService!.addData)
        .listen((event) {
      _isLoading.add(false);
      event
          .asStream()
          .where((r) => r.error == null)
          .map((r) => r.data)
          .listen((u) async {
        _handleAuthResponse(event);

      }).addTo(disposeBag);

    })
        .addTo(disposeBag);

  }
  void getClasses() async{
    UserDetails? userDetails=await  _userDataStore?.getUser();
    printLog("userDetails", userDetails?.userName);
    _isLoading.add(true);
    subjectService!.subjectList(DashboardData('classList', userDetails!.usersid)).then((value) {
      _isLoading.add(false);
      if(value.error==null){
        if(value.data!.status=="200"){
          if(value.data!.classList!=null){
            if(value.data!.classList!.isNotEmpty){
              _classList.add(value.data!.classList!);
              if(type==null){
               // addClass.add(value.data!.classList![0].className!);
                addClassId.add(value.data!.classList![0].classId!);
                getSections(value.data!.classList![0].classId!);
              }
            }
          }

        } else _errorMsg.add('Invalid');
      }else _errorMsg.add('Invalid');
    });
  }
  void getSubjects() async{
    UserDetails? userDetails=await  _userDataStore?.getUser();
    printLog("userDetails", userDetails?.userName);
    _isLoading.add(true);
    subjectService!.subjectList(DashboardData('subjectList', userDetails!.usersid)).then((value) {
      _isLoading.add(false);
      if(value.error==null){
        if(value.data!.status=="200"){
          if(value.data!.subjectList!=null){
            if(value.data!.subjectList!.isNotEmpty){
              _subjectList.add(value.data!.subjectList!);
              /*if(type==null)
                addSubject.add(value.data!.subjectList![0].subjectName!);*/
            }
          }

        } else _errorMsg.add('Invalid');
      }else _errorMsg.add('Invalid');
    });
  }
  void getFaculty() async{
    UserDetails? userDetails=await  _userDataStore?.getUser();
    printLog("userDetails", userDetails?.userName);
    _isLoading.add(true);
    subjectService!.subjectList(DashboardData('faculityList', userDetails!.usersid)).then((value) {
      _isLoading.add(false);
      if(value.error==null){
        if(value.data!.status=="200"){
          if(value.data!.faculityList!=null){
            if(value.data!.faculityList!.isNotEmpty){
              _faculityList.add(value.data!.faculityList!);
              if(type==null)
               // addFaculty.add(value.data!.faculityList![0].faculityName!);
               addFacultyId.add(value.data!.faculityList![0].id!);
            }
          }

        } else _errorMsg.add('Invalid');
      }else _errorMsg.add('Invalid');
    });
  }
  void getSections(String classId) async{
    UserDetails? userDetails=await  _userDataStore?.getUser();
    String userId=userDetails!.usersid!;
    subjectService!.getRequest({"usersid":userId,"class_id":classId,"action":"section-list"}).then((value) {
      _isLoading.add(false);
      if(value.error==null){
        if(value.data!.status=="200"){
          if(value.data!.sectionList!=null){
            if(value.data!.sectionList!.isNotEmpty){
              // section=value.data!.sectionList![0].sectionId;
              _sectionsList.add(value.data!.sectionList!);
              if(type==null){
                //addSection.add(value.data!.sectionList![0].sectionName!);
                addSectionId.add(value.data!.sectionList![0].sectionId!);
              }

            }
          }

        } else _errorMsg.add('Invalid');
      }else _errorMsg.add('Invalid');
    });
  }


  _handleAuthResponse(Future<RequestResponse<SubjectListData>> result) {
    result
        .asStream()
        .where((r) => r.error == null)
        .map((r) => r.data)
        .listen((u) async {
      if (u != null){
        if(u.status=="1"||u.status=="200") {
          printLog("message", u.message);
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(
              content:  Text(u.message!),
            ),
          );
          // Navigator.pop(Get.context!);
        }else {
          printLog('message',u.message!);
        }
      }

    }).addTo(disposeBag);

    _handleError(result);
  }

  _handleError(Future<RequestResponse> result) {
    result
        .asStream()
        .where((r) => r.error != null)
        .map((r) => r.error)
        .doOnData((_) => _isLoading.add(false))
        .listen((e) {
      if (e != null){
        printLog("data", e.statusCode);
        //if(e.statusCode!=401)
      }
    }).addTo(disposeBag);


  }


}