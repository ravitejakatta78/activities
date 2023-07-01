
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:publicschool_app/model/fees/fee_types_list.dart';
import 'package:rxdart/rxdart.dart';

import '../../../app/arch/bloc_provider.dart';
import '../../../common/widgets/bottom_sheet/calende_bottom_sheet.dart';
import '../../../common/widgets/toast/toast.dart';
import '../../../helper/logger/logger.dart';
import '../../../manager/user_data_store/user_data_store.dart';
import '../../../model/base_response/request_response.dart';
import '../../../model/dashboard/dashboard_data.dart';
import '../../../model/fees/fees_list.dart';
import '../../../model/login/login_response.dart';
import '../../../model/sections/sections_data.dart';
import '../../../model/subject/faculity_list.dart';
import '../../../model/subject/student.dart';
import '../../../model/subject/student_list.dart';
import '../../../model/subject/subject_list_data.dart';
import '../../../model/time_table/get_time_table.dart';
import '../../../repositories/menu_list/subject_api.dart';

typedef BlocProvider<AddStudentFeesBloc> AddStudentFeesBlocFactory(Fees? type);

class AddStudentFeesBloc extends BlocBase {

  Fees? type;
  SubjectService? subjectService;
  UserDataStore? _userDataStore;
  final BehaviorSubject<String> _errorMsg=BehaviorSubject.seeded("");
  final BehaviorSubject<bool> _isLoading =BehaviorSubject.seeded(false);
  final PublishSubject<List<StudentList>> _studentList=PublishSubject();
  final PublishSubject<List<ClassList>> _classList=PublishSubject();
  final PublishSubject<List<SectionsList>> _sectionsList=PublishSubject();
  final PublishSubject<List<FeeTypes>> _feeTypesList=PublishSubject();
  final BehaviorSubject<String> _className=BehaviorSubject();
  final BehaviorSubject<String> _classId=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _sectionName=BehaviorSubject();
  final BehaviorSubject<String> _sectionId=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _studentName=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _studentId=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _feeId=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _paidDate=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _feeType=BehaviorSubject();
  final BehaviorSubject<String> _feeTypeId=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _amount=BehaviorSubject.seeded("");
  BehaviorSubject<bool> _valid =BehaviorSubject.seeded(false);
  PublishSubject<void> _student_fee_submit = PublishSubject();
  PublishSubject<Map<String,dynamic>> _submitStudentFee = PublishSubject();
  Sink<void>  get student_fee_submit=> _student_fee_submit;
  Sink<Map<String,dynamic>> get submitTimeTable => _submitStudentFee;
  Stream<List<SectionsList>> get sectionsList => _sectionsList;
  Stream<String> get class_name => _className;
  Sink<String> get addClass => _className;
  Sink<String> get addClassId => _classId;
  Stream<String> get studentName => _studentName;
  Sink<String> get addStudent => _studentName;
  Sink<String> get addStudentId => _studentId;
  Sink<String> get addFeeId => _feeId;
  Stream<String> get sectionName => _sectionName;
  Sink<String> get addSection => _sectionName;
  Sink<String> get addSectionId => _sectionId;
  Stream<String> get paidDate => _paidDate;
  Sink<String> get addPaidDate => _paidDate;
  Stream<String> get feeType => _feeType;
  Sink<String> get addFeeType => _feeType;
  Stream<String> get feeTypeId => _feeTypeId;
  Sink<String> get addFeeTypeId => _feeTypeId;
  Stream<String> get amount => _amount;
  Sink<String> get addAmount => _amount;
  Stream<bool> get isLoading => _isLoading;
  Stream<List<StudentList>> get studentList => _studentList;
  Stream<List<ClassList>> get classList => _classList;
  Stream<List<FeeTypes>> get feeTypesList => _feeTypesList;
  Stream<String> get errorMsg => _errorMsg;
  BehaviorSubject<String> _feePaidDate=BehaviorSubject.seeded("Paid Date");
  Stream<String> get paidDateStream => _feePaidDate;
  Sink<String> get addPaidFeeDate => _feePaidDate;
  String? startDate=new DateFormat('yyyy-MM-dd').format(new DateTime.now());
  String? currentDate=new DateFormat('yyyy-MM-dd').format(new DateTime.now());
  String? userId ="";
  Map<String,dynamic> addTimeTableParams = {};
  String classIdString="";
  String sectionIdString="";

  AddStudentFeesBloc(this.type,this._userDataStore,this.subjectService){

    getInfo();
  }
  void getInfo(){
    getClasses();
    setListener();

  }

  void setListener() async {

    UserDetails? userDetails=await  _userDataStore?.getUser();
    userId=userDetails!.usersid!;

    CombineLatestStream.combine5(_classId, _studentId,  _amount,_sectionId, _feeTypeId, (String a, String b,  String d, String e, String f) =>
    (a.isNotEmpty && b.isNotEmpty  && d.isNotEmpty && e.isNotEmpty ) )
        .listen(_valid.add)
        .addTo(disposeBag);

    _student_fee_submit
        .withLatestFrom(_valid, (_, bool v){
      printLog("title", "onPressed");
      if(v!=true) ToastMessage('Enter Details');
      return v;
    }).where((event) => event).withLatestFrom5(_classId, _studentId,  _amount,_sectionId, _feeTypeId,
            (t, String a,String b,String d,String e, String f) =>{
              'action': 'pay-student-fee','student_id':b,'amount':d,'class_id':a,'paid_date':startDate,'usersid':userId,'fee_type':f,'section_id':e
        })
        .listen(_submitStudentFee.add)
        .addTo(disposeBag);

    _submitStudentFee.doOnData((_)=> _isLoading.add(true))
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
                classIdString=value.data!.classList![0].classId!;
                //addClass.add(value.data!.classList![0].className!);
                addClassId.add(value.data!.classList![0].classId!);
                getSections(value.data!.classList![0].classId!);
                getFeesListTypes(value.data!.classList![0].classId!);
                getStudents( sectionIdString);
              }
            }
          }
        } else _errorMsg.add('Invalid');
      }else _errorMsg.add('Invalid');
    });
  }

  void getStudents(String sectionId) async{
    UserDetails? userDetails=await  _userDataStore?.getUser();
    printLog("userDetails", userDetails?.userName);
    if(classIdString.isNotEmpty&&sectionId.isNotEmpty){
      _isLoading.add(true);
      subjectService!.getRequest({"usersid":userId,"class_id":classIdString,"action":"studentList","section_id":sectionId}).then((value) {
        _isLoading.add(false);
        if(value.error==null){
          if(value.data!.status=="200"){
            if(value.data!.studentList!=null){
              //List<StudentList> students=[];
              // for(int i=0;i<value.data!.studentList!.length;i++){
              //   if(value.data!.studentList![i].studentClass==type!.classId && value.data!.studentList![i].studentSection==type!.sectionId ){
              //     students.add(value.data!.studentList![i]);
              //   }
              // }
              // _studentList.add(students);
              if(value.data!.studentList!.isNotEmpty){
                _studentList.add(value.data!.studentList!);
                if(type==null){
                  addStudent.add(value.data!.studentList![0].firstName!+" "+value.data!.studentList![0].lastName!);
                  addStudentId.add(value.data!.studentList![0].id!);
                }
              }
            }
          } else _errorMsg.add('Invalid');
        }else _errorMsg.add('Invalid');
      });
    }

  }
  void getSections(String classId) async{
    classIdString=classId;
    UserDetails? userDetails=await  _userDataStore?.getUser();
    String userId=userDetails!.usersid!;
    subjectService!.getRequest({"usersid":userId,"class_id":classId,"action":"section-list"}).then((value) {
      _isLoading.add(false);
      if(value.error==null){
        if(value.data!.status=="200"){
          if(value.data!.sectionList!=null){
            if(value.data!.sectionList!.isNotEmpty){
              _sectionsList.add(value.data!.sectionList!);
              if(type==null){
                sectionIdString=value.data!.sectionList![0].sectionId!;
                //addSection.add(value.data!.sectionList![0].sectionName!);
                addSectionId.add(value.data!.sectionList![0].sectionId!);
                getStudents(value.data!.sectionList![0].sectionId!);
              }
            }else  _sectionsList.add([]);
          }else  _sectionsList.add([]);
        } else _errorMsg.add('Invalid');
      }else _errorMsg.add('Invalid');
    });
  }
  void getFeesListTypes(String classId) async{
    UserDetails? userDetails=await  _userDataStore?.getUser();
    String userId=userDetails!.usersid!;
    subjectService!.getFeesTypesList({"usersid":userId,"class_id":classId,"action":"get-fee-types"}).then((value) {
      _isLoading.add(false);
      if(value.error==null){
        if(value.data!.status=="200"){
          if(value.data!.data!=null){
            if(value.data!.data!.isNotEmpty){
              _feeTypesList.add(value.data!.data!);
              //addFeeType.add(value.data!.data![0].feeName!);
              addFeeTypeId.add(value.data!.data![0].feeType!.toString());
             // addAmount.add(value.data!.data![0].feeAmount!.toString());
              addFeeId.add(value.data!.data![0].id!.toString());

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
        if(u.status=="200") {
          printLog("message", u.message);
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(
              content:  Text(u.message!),
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
        .doOnData((_) => _isLoading.add(false))
        .listen((e) {
      if (e != null){
        printLog("data", e.statusCode);
        //if(e.statusCode!=401)
      }
    }).addTo(disposeBag);
  }
  getStateDate(int type){
    calenderBottomSheet(onCallback: (dateTime){
      startDate=dateTime.toString();
      addPaidFeeDate.add(startDate!);
    },selectedDate:DateTime.parse(startDate!),type:type );

  }
}