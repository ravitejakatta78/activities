
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:publicschool_app/common/bloc/info_bloc.dart';
import 'package:publicschool_app/di/app_injector.dart';
import 'package:publicschool_app/di/i_student_exams.dart';
import 'package:publicschool_app/helper/logger/logger.dart';
import 'package:publicschool_app/model/subject/student_list.dart';
import 'package:rxdart/rxdart.dart';
import '../../../app/arch/bloc_provider.dart';
import '../../../common/widgets/toast/toast.dart';
import '../../../manager/user_data_store/user_data_store.dart';
import '../../../model/base_response/request_response.dart';
import '../../../model/exams/exams_data.dart';
import '../../../model/exams/exams_item.dart';
import '../../../model/login/login_response.dart';
import '../../../model/subject/subject_list_data.dart';
import '../../../repositories/menu_list/subject_api.dart';

typedef BlocProvider<StudentExamsBloc> AddStudentsExamFactory(int pageType);
class StudentExamsBloc extends InfoBloc {
  SubjectService? subjectService;
  UserDataStore? _userDataStore;
  String? type;
  int pageType;
  PublishSubject<void> _get_exam_list = PublishSubject();
  PublishSubject<void> _add_row = PublishSubject();
  PublishSubject<void> _add_exam = PublishSubject();
  PublishSubject<Map<String,dynamic>> _addExam = PublishSubject();
  final PublishSubject<ExamsItem> _addRow = PublishSubject();
  PublishSubject<Map<String,dynamic>> _getExamList = PublishSubject();
  BehaviorSubject<bool> _valid =BehaviorSubject.seeded(false);
  BehaviorSubject<bool> _examValid =BehaviorSubject.seeded(false);
  BehaviorSubject<bool> _listValid =BehaviorSubject.seeded(false);
  BehaviorSubject<int> _ScreenType =BehaviorSubject.seeded(0);
  final PublishSubject<List<ExamsItem>> _examItem=PublishSubject();
  BehaviorSubject<String> _examDate=BehaviorSubject.seeded("Select Date");
  BehaviorSubject<String> _examName=BehaviorSubject.seeded("");
  BehaviorSubject<bool> _isAddClick=BehaviorSubject.seeded(false);
  BehaviorSubject<List<ExamsList>> _studentExamsList=BehaviorSubject.seeded([]);
  BehaviorSubject<List<StudentList>> _studentList=BehaviorSubject.seeded([]);
  PublishSubject<List<SubjectList>> _subjects=PublishSubject();
  Stream<List<SubjectList>> get subjects => _subjects;
  Stream<List<ExamsList>> get studentExamsList => _studentExamsList;
  Stream<List<StudentList>> get studentList => _studentList;
  Stream<String> get examName => _examName;
  Sink<String>  get addExamName => _examName;
  Stream<String> get examDate => _examDate;
  Sink<String> get addExamDate => _examDate;
  Stream<List<ExamsItem>> get examItem => _examItem;
  Sink<List<ExamsItem>> get addExamItem => _examItem;
  Stream<bool> get listValid => _listValid;
  Sink<Map<String,dynamic>> get getExamList => _getExamList;
  Sink<void>  get get_exam_list=> _get_exam_list;
  Sink<void>  get add_exam=> _add_exam;
  Sink<void>  get add_row=> _add_row;
  Sink<ExamsItem> get addRow => _addRow;
  Sink<Map<String,dynamic>> get addExam => _addExam;
  Sink<bool>  get isAddClick=> _isAddClick;
  Stream<int> get ScreenType => _ScreenType;
  bool addClick=false;

  List<SubjectList> subjectsList=[];
  List<String> value=[];
  DateTime? parseDate;
  List<ExamsItem> examItemList=[];
  StudentExamsBloc(this.type,this._userDataStore,this.subjectService,this.pageType):super(
      subjectService, _userDataStore,type,null){
    _ScreenType.add(pageType);

    setListener();
    getData();
  }
  void getData(){
    getClassList({"action":"classList"},0);
  }


  void setListener() async{

    UserDetails? userDetails=await  _userDataStore?.getUser();
    userId=userDetails!.usersid!;

    addStartDate.add(startDate!);
    addEndDate.add(endDate!);



    CombineLatestStream.combine3(getClassId, getSectionId,_isAddClick, (String a, String b,bool c)
    => (a.isNotEmpty )).listen(_listValid.add).addTo(disposeBag);
   
    _get_exam_list
    .withLatestFrom(_listValid, (_, bool v) {
      if(v!=true) ToastMessage('Enter Details');
      return v;
      }).where((event) => event)
       .withLatestFrom3(getClassId, getSectionId,_isAddClick, (t, String a, String b,bool c) {
      addClick=c;
         return {'action':(pageType==0)?'studentList':'examList','usersid':userId,'class_id':a,'section_id':b} ;})
      .listen(_getExamList.add)
       .addTo(disposeBag);

    _getExamList.
    doOnData((_)=> addLoading.add(true))
        .map(subjectService!.getRequest)
        .listen((event) {
      addLoading.add(false);
      event
          .asStream()
          .where((r) => r.error == null)
          .map((r) => r.data)
          .listen((u) async {

        _handleAuthResponse(event,1,addClick);

      }).addTo(disposeBag);

    })
        .addTo(disposeBag);


    CombineLatestStream.combine3(_examDate, subjectId,subject,
            (String a, String b,String c) => a.isNotEmpty && a!="Select Date" && b.isNotEmpty)
        .listen(_valid.add).addTo(disposeBag);


    CombineLatestStream.combine6(_examName, startDateStream, endDateStream, getClassId, getSectionId, _examItem, (String a, String b, String c, String d, String e, List<ExamsItem> f)
    => a.isNotEmpty && b.isNotEmpty && c.isNotEmpty && d.isNotEmpty  && f.isNotEmpty)
        .listen(_examValid.add)
        .addTo(disposeBag);
    _add_exam
    .withLatestFrom6(_examName, startDateStream, endDateStream, getClassId, getSectionId, _examItem, (t, String a, String b, String c,String d, String e, List<ExamsItem> f) {
      List<String> exam_date=[];
      List<String> subject_id=[];
      for(int i=0;i<f.length;i++){
        exam_date.add(f[i].examDate.toString());
        subject_id.add(f[i].subjectId.toString());

      }
      return  {
        'action':'addExam','exam_name':a,'exam_start_date':b,'exam_end_date':c,'class_id':d,'usersid':userId,'section_id':e,
        'subject_id':subject_id,'exam_date':exam_date};
    }


    )  .listen(_addExam.add)
        .addTo(disposeBag);

    _addExam.
    doOnData((_)=> addLoading.add(true))
        .map(subjectService!.addData)
        .listen((event) {
      addLoading.add(false);
      event
          .asStream()
          .where((r) => r.error == null)
          .map((r) => r.data)
          .listen((u) async {
        _handleAuthResponse(event,2,addClick);

      }).addTo(disposeBag);

    })
        .addTo(disposeBag);

    subjectList.listen((event) {
      value = [];
      subjectsList=[];
    // addSubject.add(event[0].subjectName!);
      for (int i = 0; i < event.length; i++) {
        value.add(event[i].subjectName!);
      }
      value=value.toSet().toList();
      subjectsList.addAll(event);
      printLog("event", event);
      _subjects.add(event);

    }).addTo(disposeBag);

  }

  void deleteExam(ExamsList examsList){
    subjectService!.addData({'action':'deleteExam','examId':examsList.examId,'usersid':userId}).then((value){
      if(value.data!.status=="200"||value.data!.status=="1"){
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text(value.data!.message!),
          ),
        );
        get_exam_list.add(null);
      }
    });


  }

  getExamDate(List<ExamsItem> list,int pos){

    showDatePicker(
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
      context: Get.context!,
    ).then((selectedDate) async {
      TimeOfDay? pickedTime =  await showTimePicker(
        initialTime: TimeOfDay.now(),
        context: Get.context!,
      );
      if(pickedTime != null ){
        print(pickedTime.format(Get.context!));
        DateTime parsedTime = DateFormat.jm().parseLoose(pickedTime.format(Get.context!).toString());
        print(parsedTime);
        String formattedTime = DateFormat('h:mm a').format(parsedTime);
        String formattedDate=new DateFormat('yyyy-MM-dd').format(selectedDate!);
        String exam='$formattedDate $formattedTime';
        print(exam);
         parseDate = new DateFormat("yyyy-MM-dd h:mm a").parse(exam);
        print(parseDate.toString());
        list[pos].examDate=exam;
        addExamItem.add(list);
       addExamDate.add(exam);
      }else{
        print("Time is not selected");
      }

    });



  }

  updateList(int pos){
      examItemList.removeAt(pos);
    _examItem.add(examItemList);
    addExamDate.add("Select Date");

  }

  void addRowData() {

   // printLog("datata", event.first.examDate);
   // examItemList.add(ExamsItem(event.first.examDate, event.first.subjectId, event.first.subjectName));
    examItemList.add(ExamsItem(startDate,subjectsList[0].id, subjectsList[0].subjectName));
    _examItem.add(examItemList);
    addExamDate.add("Select Date");

  }



  _handleAuthResponse(Future<RequestResponse<SubjectListData>> result,int type,bool click) {
    result
        .asStream()
        .where((r) => r.error == null)
        .map((r) => r.data)
        .listen((u) async {
      if (u != null){
        if(u.status=="1"||u.status=="200") {
          if(type==2){
            printLog("message", u.message);
            ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(
                content:  Text(u.message!),
              ),
            );
           Navigator.pop(Get.context!);
            _isAddClick.add(false);
            get_exam_list.add(null);

          }else{
            if(u.examList!=null){
              if(click!=true){
                if(u.examList!.isNotEmpty){
                  _studentExamsList.add(u.examList!);
                }else _studentExamsList.add([]);
              }
            }else _studentExamsList.add([]);

            if(u.studentList!=null){
              if(click!=true){
                if(u.studentList!.isNotEmpty){
                  _studentList.add(u.studentList!);
                }else _studentList.add([]);
              }
            }else _studentList.add([]);

          }

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



