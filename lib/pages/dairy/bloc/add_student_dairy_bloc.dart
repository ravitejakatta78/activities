
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:publicschool_app/common/bloc/info_bloc.dart';
import 'package:publicschool_app/model/dairy/dairy_list.dart';
import 'package:rxdart/rxdart.dart';

import '../../../app/arch/bloc_provider.dart';
import '../../../common/widgets/bottom_sheet/calende_bottom_sheet.dart';
import '../../../common/widgets/toast/toast.dart';
import '../../../helper/logger/logger.dart';
import '../../../manager/user_data_store/user_data_store.dart';
import '../../../model/base_response/request_response.dart';
import '../../../model/dashboard/dashboard_data.dart';
import '../../../model/login/login_response.dart';
import '../../../model/sections/sections_data.dart';
import '../../../model/subject/subject_list_data.dart';
import '../../../repositories/menu_list/subject_api.dart';
typedef BlocProvider<AddStudentDairyBloc>  AddStudentDairyFactory(String? type,Dairy? dairy);
class AddStudentDairyBloc extends InfoBloc {
  String? type;
  SubjectService? subjectService;
  UserDataStore? _userDataStore;
  Dairy? dairy;
  final BehaviorSubject<String> _days=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _description=BehaviorSubject.seeded("");
  PublishSubject<void> _student_dairy_submit = PublishSubject();
  BehaviorSubject<bool> _valid =BehaviorSubject.seeded(false);
  PublishSubject<Map<String,dynamic>> _submitStudentDairy = PublishSubject();
  Sink<void>  get student_dairy_submit=> _student_dairy_submit;
  Sink<Map<String,dynamic>> get submitStudentDairy => _submitStudentDairy;
  Stream<String> get description => _description;
  Sink<String> get addDescription => _description;
  Stream<String> get days => _days;
  String? startDate=new DateFormat('yyyy-MM-dd').format(new DateTime.now());
  String? schoolId ="";
  AddStudentDairyBloc(this.type,this.subjectService,this._userDataStore,this.dairy):super(
    subjectService,_userDataStore,type,dairy
  ){

    getClassList({"action":"classList"},2);
    getSubjects();
  /*  getClasses();
    getSubjects();*/
    setListener();
  }
  void setListener()  async{
    UserDetails? userDetails=await  _userDataStore?.getUser();
    userId=userDetails!.usersid!;
    schoolId=userDetails.schoolId;

    if(dairy!=null){
      addDescription.add(dairy!.taskDescription!);
      addStartDate.add(dairy!.dairyDate!);
    }

    CombineLatestStream.combine5(getClassId, subjectId, startDateStream, _description,getSectionId, (String a, String b, String c, String d, String e) =>
    (a.isNotEmpty && b.isNotEmpty && c.isNotEmpty && d.isNotEmpty ) )
        .listen(_valid.add)
        .addTo(disposeBag);

    _student_dairy_submit
        .withLatestFrom(_valid, (_, bool v){
      printLog("title", "onPressed");
      if(v!=true) ToastMessage('Enter Details');
      return v;
    }).where((event) => event).withLatestFrom5(getClassId, subjectId, startDateStream, _description, getSectionId,
            (t, String a,String b,String c,String d,String e) {
          return(dairy!=null)?{'action': 'update-student-dairy','subject_id':b,'task_description':d,'class_id':a,'dairy_date':c,'usersid':userId,'school_id':schoolId,'section_id':e,'dairy_id':dairy!.id}:
          { 'action': 'add-student-dairy','subject_id':b,'task_description':d,'class_id':a,'dairy_date':c,'usersid':userId,'school_id':schoolId,'section_id':e};
        })
        .listen(_submitStudentDairy.add)
        .addTo(disposeBag);
    _submitStudentDairy.doOnData((_)=> addLoading.add(true))
        .map(subjectService!.addData)
        .listen((event) {
      addLoading.add(false);
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

  /*  void getClasses() async{
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
              if(dairy==null){
                addClass.add(value.data!.classList![0].className!);
                addClassId.add(value.data!.classList![0].classId!);
                getSections(value.data!.classList![0].classId!);
              }else{
                addClass.add(dairy!.className!);
                addClassId.add(dairy!.classId!);
                getSections(dairy!.classId!);
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
              if(dairy==null){
                addSubject.add(value.data!.subjectList![0].subjectName!);
                addSubjectId.add(value.data!.subjectList![0].id!);
              }else{
                addSubject.add(dairy!.subjectName!);
                addSubjectId.add(dairy!.sectionId!);
              }

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
              if(dairy==null){
                addSection.add(value.data!.sectionList![0].sectionName!);
                addSectionId.add(value.data!.sectionList![0].sectionId!);
              }else{
                addSection.add(dairy!.sectionName!);
                addSectionId.add(dairy!.sectionId!);
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

  }*/

  _handleAuthResponse(Future<RequestResponse<SubjectListData>> result) async {
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
              content: Text(u.message!),
            ),
          );
           Navigator.pop(Get.context!);

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
        .doOnData((_) => addLoading.add(false))
        .listen((e) {
      if (e != null){
        printLog("data", e.statusCode);
        //if(e.statusCode!=401)
      }
    }).addTo(disposeBag);


  }

}