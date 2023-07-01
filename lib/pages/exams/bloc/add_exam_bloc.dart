

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import '../../../app/arch/bloc_provider.dart';
import '../../../common/widgets/bottom_sheet/add_exam_botttom_sheet.dart';
import '../../../common/widgets/bottom_sheet/calende_bottom_sheet.dart';
import '../../../helper/logger/logger.dart';
import '../../../manager/user_data_store/user_data_store.dart';
import '../../../model/base_response/request_response.dart';
import '../../../model/dashboard/dashboard_data.dart';
import '../../../model/login/login_response.dart';
import '../../../model/sections/sections_data.dart';
import '../../../model/subject/subject_list_data.dart';
import '../../../repositories/menu_list/subject_api.dart';

typedef BlocProvider<AddExamsBloc> AddStudentExamsFactory(String type);

class AddExamsBloc extends BlocBase {

  String? type;
  SubjectService? subjectService;
  UserDataStore? _userDataStore;
  final BehaviorSubject<String> _errorMsg=BehaviorSubject.seeded("");
  final BehaviorSubject<bool> _isLoading =BehaviorSubject.seeded(false);

  final PublishSubject<List<SubjectList>> _subjectList=PublishSubject();
  final PublishSubject<List<ClassList>> _classList=PublishSubject();
  final PublishSubject<List<SectionsList>> _sectionsList=PublishSubject();
  final BehaviorSubject<String> _startDate=BehaviorSubject.seeded("Start Date");
  final BehaviorSubject<String> _endDate=BehaviorSubject.seeded("End Date");
  final BehaviorSubject<String> _className=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _classId=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _sectionName=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _sectionId=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _subject=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _subjectId=BehaviorSubject.seeded("");
  final BehaviorSubject<bool> _isView=BehaviorSubject.seeded(true);
  Stream<bool> get isView => _isView;
  Stream<String> get class_name => _className;
  Sink<String> get addClass => _className;
  Stream<String> get classId => _classId;
  Sink<String> get addClassId => _classId;

  Stream<String> get subject => _subject;
  Sink<String> get addSubject => _subject;

  Stream<String> get sectionName => _sectionName;
  Sink<String> get addSection => _sectionName;
  Stream<String> get sectionId => _sectionId;
  Sink<String> get addSectionId => _sectionId;
  Stream<bool> get isLoading => _isLoading;
  Stream<String> get errorMsg => _errorMsg;
  Stream<List<SubjectList>> get subjectList => _subjectList;
  Stream<List<ClassList>> get classList => _classList;
  Stream<List<SectionsList>> get sectionsList => _sectionsList;
  Stream<String> get startDateStream => _startDate;
  Sink<String> get addStartDate => _startDate;

  Stream<String> get endDateStream => _endDate;
  Sink<String> get addEndDate => _endDate;

  String? startDate=new DateFormat('yyyy-MM-dd').format(new DateTime.now());
  String? endDate=new DateFormat('yyyy-MM-dd').format(new DateTime.now());


  AddExamsBloc(this.type,this.subjectService,this._userDataStore) {

   // setListener();
  }
  void setListener(){
    getClasses();
    getSubjects();

   // displayData();
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
                addClass.add(value.data!.classList![0].className!);
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
              if(type==null){
                addSubject.add(value.data!.subjectList![0].subjectName!);

              }
          }

        } else _errorMsg.add('Invalid');
      }else _errorMsg.add('Invalid');
    }});
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
                addSection.add(value.data!.sectionList![0].sectionName!);
                addSectionId.add(value.data!.sectionList![0].sectionId!);
              }
            }
          }

        } else _errorMsg.add('Invalid');
      }else _errorMsg.add('Invalid');
    });
  }

  getStateDate(){
    calenderBottomSheet(onCallback: (dateTime){
      startDate=dateTime.toString();
      addStartDate.add(startDate!);
    },selectedDate:DateTime.parse(startDate!),type:2 );

  }
  getEndDate(){
    calenderBottomSheet(onCallback: (dateTime){
      endDate=dateTime.toString();
      addEndDate.add(endDate!);
    },selectedDate:DateTime.parse(endDate!),type:2 );

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
