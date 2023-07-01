
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:publicschool_app/app/arch/bloc_provider.dart';
import 'package:publicschool_app/model/exams/exams_marks.dart';
import 'package:publicschool_app/model/subject/student_list.dart';
import 'package:rxdart/rxdart.dart';
import '../../../helper/logger/logger.dart';
import '../../../manager/user_data_store/user_data_store.dart';
import '../../../model/base_response/request_response.dart';
import '../../../model/dashboard/dashboard_data.dart';
import '../../../model/exams/exams_data.dart';
import '../../../model/login/login_response.dart';
import '../../../model/subject/subject_list_data.dart';
import '../../../repositories/menu_list/subject_api.dart';

typedef BlocProvider<AddExamMarksBloc> AddExamMarksFactory(String type,ExamsList examsList);
class AddExamMarksBloc extends BlocBase {
  SubjectService? subjectService;
  UserDataStore? _userDataStore;
  String? type;
  ExamsList examsList;
  final BehaviorSubject<String> _errorMsg=BehaviorSubject.seeded("");
  final BehaviorSubject<bool> _isLoading = BehaviorSubject.seeded(false);
  Stream<String> get  errorMsg=> _errorMsg;
  Stream<bool> get isLoading => _isLoading;
  final BehaviorSubject<bool> _isValid = BehaviorSubject.seeded(false);
  Stream<bool> get isValid => _isValid;
  final BehaviorSubject<ExamsList> _examsList=BehaviorSubject();
  PublishSubject<List<StudentList>> _studentList = PublishSubject();
  PublishSubject<List<SubjectMarks>> _studentMarks = PublishSubject();
  BehaviorSubject<List<SubjectMarks>> _modifyStudentMarks = BehaviorSubject();
  Sink<List<SubjectMarks>> get modifyStudentMarks => _modifyStudentMarks;
  final BehaviorSubject<String> _studentName=BehaviorSubject();
  final BehaviorSubject<String> _studentId=BehaviorSubject.seeded("");
  PublishSubject<void> _addMarks = PublishSubject();
  PublishSubject<Map<String,dynamic>> _submitStudentMarks=PublishSubject();
  Sink<void> get addMarks => _addMarks;
  Stream<List<StudentList>> get students => _studentList;
  Stream<List<SubjectMarks>> get studentMarks => _studentMarks;
  Sink<List<SubjectMarks>> get addStudentMarks => _studentMarks;
  Stream<ExamsList> get getExamsList => _examsList;
  Stream<String> get studentName => _studentName;
  Sink<String> get addStudentName => _studentName;
  Sink<String> get addStudentId => _studentId;
  String? userId ="";
  AddExamMarksBloc(this.type,this.subjectService,this._userDataStore,this.examsList){
    _examsList.add(examsList);
    getStudentList();
    setListener();
  }
  void setListener() async {
    UserDetails? userDetails=await  _userDataStore?.getUser();
    CombineLatestStream.combine2(_studentId, _studentMarks, (String a,List<SubjectMarks> b) {
      printLog("_studentId",a);
      printLog("_studentMarks",b);
      return a.isNotEmpty&&_studentList.length!=0;}).listen(_isValid.add).addTo(disposeBag);
    _addMarks.withLatestFrom(_isValid,  (_, bool v){
      return v;
    }).where((event) => event)
        .withLatestFrom2(_studentId, _studentMarks,
            (t, String a,List<SubjectMarks> b,) {
          List<String> subject_id=[];
          List<String> marks=[];
          for(int i=0;i<b.length;i++){
            subject_id.add(b[i].subjectId!);
            marks.add(b[i].marks!);
          }

          return
          { 'action': 'add-exam-marks', 'usersid':userDetails!.usersid,'student_id':a,'exam_id':examsList.examId,'marks':marks,'subject_id':subject_id};

        })
        .listen(_submitStudentMarks.add)
        .addTo(disposeBag);

    _submitStudentMarks.doOnData((_)=> _isLoading.add(true))
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

  void getStudentList() async{
    UserDetails? userDetails=await  _userDataStore?.getUser();
    _isLoading.add(true);
    subjectService!.subjectList(DashboardData('studentList', userDetails!.usersid)).then((value) {
      _isLoading.add(false);
      if (value.error == null) {
        if (value.data!.status == "200") {
          if (value.data!.studentList != null) {
            List<StudentList> students=[];
          for(int i=0;i<value.data!.studentList!.length;i++){
            if(value.data!.studentList![i].studentClass==examsList.classId && value.data!.studentList![i].studentSection==examsList.sectionId ){
              students.add(value.data!.studentList![i]);
            }
          }
          printLog("students", students.length);
            _studentList.add(students);
            getStudentMarks(students[0].id!);
          }
        }else _errorMsg.add('Invalid');
      }else _errorMsg.add('Invalid');

    });

}

  void getStudentMarks(String studentId) async{
    _isLoading.add(true);
    UserDetails? userDetails=await  _userDataStore?.getUser();
    String userId=userDetails!.usersid!;
    Map<String,dynamic> map={};
    map.addAll({
      'action': 'get-student-exam-marks',
      'usersid': userId,
      'exam_id':examsList.examId,
      'student_id':studentId
    });
    subjectService!.getExamsMarksData(map).then((value) {
      _isLoading.add(false);
      if(value.data!.status=="1") {
        if(value.data!.examDetails!.subjectMarks!=null){
          if(value.data!.examDetails!.subjectMarks!.isNotEmpty){
            addStudentMarks.add(value.data!.examDetails!.subjectMarks!);
          }
        }
      }
    });

  }

  _handleAuthResponse(Future<RequestResponse<SubjectListData>> result) async {
    result
        .asStream()
        .where((r) => r.error == null)
        .map((r) => r.data)
        .listen((u) async {
      if (u != null){
        if(u.status=="1"||u.status=="200") {
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(
              content:  Text(u.message!),
            ),
          );
         //Navigator.pop(Get.context!);
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