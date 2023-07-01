

import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:publicschool_app/app/arch/bloc_provider.dart';
import 'package:publicschool_app/model/subject/student_list.dart';
import 'package:rxdart/rxdart.dart';
import '../../../common/widgets/bottom_sheet/calende_bottom_sheet.dart';
import '../../../common/widgets/toast/toast.dart';
import '../../../helper/logger/logger.dart';
import '../../../manager/user_data_store/user_data_store.dart';
import '../../../model/base_response/request_response.dart';
import '../../../model/dashboard/dashboard_data.dart';
import '../../../model/login/login_response.dart';
import '../../../model/sections/sections_data.dart';
import '../../../model/subject/faculity_list.dart';
import '../../../model/subject/subject_list_data.dart';
import '../../../repositories/menu_list/subject_api.dart';

typedef BlocProvider<AddStudentBloc> AddStudentFactory(StudentList? studentList);

class AddStudentBloc extends BlocBase{
  UserDataStore? userDataStore;
  SubjectService? subjectService;
  StudentList? studentList;
  BehaviorSubject<String> _title = BehaviorSubject.seeded("");
  BehaviorSubject<String> _errorMsg=BehaviorSubject.seeded("");
  final BehaviorSubject<bool> _isLoading=BehaviorSubject.seeded(false);
  final BehaviorSubject<String> _className=BehaviorSubject();
  final BehaviorSubject<String> _genderName=BehaviorSubject();
  final BehaviorSubject<String> _stuFirstName=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _stuLastName=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _stuDOB=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _stuRollNo=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _stuAdmissionID=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _stuAddress=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _parentName=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _parentType=BehaviorSubject();
  final BehaviorSubject<String> _occupation=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _parentEmail=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _parentMobileNo=BehaviorSubject.seeded("");
  final BehaviorSubject<File?> _imageFile=BehaviorSubject.seeded(null);
  final BehaviorSubject<File?> _stuImageFile=BehaviorSubject.seeded(null);
  final BehaviorSubject<String> _sectionName=BehaviorSubject();
  final BehaviorSubject<List<ClassList>> _classList=BehaviorSubject.seeded([]);
  final PublishSubject<List<SectionsList>> _sectionsList=PublishSubject();
  final BehaviorSubject<String> _classId=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _sectionId=BehaviorSubject.seeded("");
  BehaviorSubject<bool> _student_valid =BehaviorSubject.seeded(false);
  BehaviorSubject<bool> _parent_valid =BehaviorSubject.seeded(false);
  PublishSubject<void> _students_submit = PublishSubject();
  PublishSubject<Future<FormData>> _submitstudent = PublishSubject();
  Sink<Future<FormData>> get submitstudent => _submitstudent;
  PublishSubject<void> _parent_submit = PublishSubject();
  Stream<String> get gender_name => _genderName;
  Sink<String> get gender => _genderName;
  Sink<String> get className => _className;
  Stream<String> get stuFirstName => _stuFirstName;
  Stream<String> get stuLastName => _stuLastName;
  Sink<String> get stuDOB => _stuDOB;
  Stream<String> get stuRollNo => _stuRollNo;
  Stream<String> get stuAddress => _stuAddress;
  Stream<String> get stuAdmissionID => _stuAdmissionID;
  Stream<String> get parentName => _parentName;
  Stream<String> get parentType => _parentType;
  Stream<String> get occupation => _occupation;
  Stream<String> get parentEmail => _parentEmail;
  Stream<String> get parentMobileNo => _parentMobileNo;
  Sink<String> get addStuFirstName => _stuFirstName;
  Sink<String> get addStuLastName => _stuLastName;
  Sink<String> get addStuRollNo => _stuRollNo;
  Sink<String> get addStuAddress => _stuAddress;
  Sink<String> get addStuAdmissionID => _stuAdmissionID;
  Sink<String> get addParentName => _parentName;
  Sink<String> get addParentType => _parentType;
  Sink<String> get addOccupation => _occupation;
  Sink<String> get addParentEmail => _parentEmail;
  Sink<String> get addParentMobileNo => _parentMobileNo;
  Stream<bool> get isLoading => _isLoading;
  Stream<String> get errorMsg => _errorMsg;
  Stream<File?> get image_File => _imageFile;
  Stream<File?> get stuImage_File => _stuImageFile;
  Stream<String> get section_name => _sectionName;
  Sink<String> get section => _sectionName;
  Stream<List<ClassList>> get classList => _classList;
  Sink<String> get class1 => _className;
  Sink<void>  get students_submit=> _students_submit;
  Stream<String> get studentDOB => _stuDOB;
  Stream<String> get class_name => _className;
  Stream<String> get classId => _classId;
  Sink<String> get addClassId => _classId;
  Stream<String> get sectionId => _sectionId;
  Sink<String> get addSectionId => _sectionId;
  Stream<List<SectionsList>> get sectionsList => _sectionsList;

  Sink<File?> get image => _imageFile;
  Sink<File?> get stuImage => _stuImageFile;
  Map<String,dynamic> studentParams={};
  String userId="";
  String? startDate=new DateFormat('yyyy-MM-dd').format(new DateTime.now());

  AddStudentBloc(this.userDataStore,this.subjectService,this.studentList){
    studentInit();

   getClassList('classList');


  }

  Future<File> _fileFromImageUrl(String img) async {
    final response = await http.get(Uri.parse(img));
    final documentDirectory = await getApplicationDocumentsDirectory();

    final file = File(join(documentDirectory.path, 'imagetest.png'));

    file.writeAsBytesSync(response.bodyBytes);

    return file;
  }
  void getClassList(String type) async {
    UserDetails? userDetails=await  userDataStore?.getUser();
    userId=userDetails!.usersid!;
    _isLoading.add(true);
    subjectService!.subjectList(DashboardData(type, userId)).then((value) {
      _isLoading.add(false);
      if(value.error==null){
        if(value.data!.status=="200"){
          if(value.data!.classList!=null){
            if(value.data!.classList!.isNotEmpty){
              _classList.add(value.data!.classList!);
              if(type==null){
              //  class1.add(value.data!.classList![0].className!);
                addClassId.add(value.data!.classList![0].classId!);
                getSections(value.data!.classList![0].classId!);
              }

            }
          }

        } else _errorMsg.add('Invalid');
      }else _errorMsg.add('Invalid');
    });
  }
  void getSections(String classId) async{
    UserDetails? userDetails=await userDataStore?.getUser();
    String userId=userDetails!.usersid!;
    _isLoading.add(true);
    subjectService!.getRequest({"usersid":userId,"class_id":classId,"action":"section-list"}).then((value) {
      _isLoading.add(false);
      if(value.error==null){
        if(value.data!.status=="200"){
          if(value.data!.sectionList!=null){
            if(value.data!.sectionList!.isNotEmpty){
              // section=value.data!.sectionList![0].sectionId;
              _sectionsList.add(value.data!.sectionList!);
                //section.add(value.data!.sectionList![0].sectionName!);
                addSectionId.add(value.data!.sectionList![0].sectionId!);

            }
          }

        } else _errorMsg.add('Invalid');
      }else _errorMsg.add('Invalid');
    });
  }
  void studentInit() async {
    if(studentList!=null){
      addStuFirstName.add(studentList!.firstName!);
      addStuLastName.add(studentList!.lastName!);
      stuDOB.add(studentList!.dob!);
      addStuRollNo.add(studentList!.rollNumber!);
      addStuAdmissionID.add(studentList!.admissionId!);
      addStuAddress.add(studentList!.address!);
      class1.add(studentList!.studentClass!);
      gender.add(studentList!.gender!);
      addParentName.add(studentList!.parentName!);
      addOccupation.add(studentList!.occupation);
      addParentType.add(studentList!.parentTypeText!);
      addParentEmail.add((studentList!.email==null)?'':studentList!.email!);
      addParentMobileNo.add((studentList!.mobile==null)?'':studentList!.mobile!);
    }

    UserDetails? userDetails=await userDataStore!.getUser();
    userId=userDetails!.usersid!;

    CombineLatestStream.combine9(_stuFirstName,_stuLastName,_stuDOB,_stuRollNo,_stuAdmissionID,_stuAddress,_className,_genderName,_stuImageFile,
            (String a, String b, String c, String d, String e, String f, String g,String h,File? file ) => a.isNotEmpty && b.isNotEmpty && c.isNotEmpty && d.isNotEmpty && e.isNotEmpty && h.isNotEmpty)
        .listen(_student_valid.add)
        .addTo(disposeBag);
    _student_valid.listen((value) {
      if(value==true){
        CombineLatestStream.combine5(_parentName,_parentType,_occupation,_parentEmail,_parentMobileNo, (String a, String b, String c, String d, String e) => a.isNotEmpty)
            .listen(_parent_valid.add)
            .addTo(disposeBag);
      }
    }).addTo(disposeBag);


    _students_submit.withLatestFrom(_parent_valid,(_, bool v) {
      if(v!=true) printLog('error','Enter Details');
      return v;
    }).where((event) => event)
        .withLatestFrom9(_stuFirstName,_stuLastName,_stuDOB,_stuRollNo,_stuAdmissionID,_stuAddress,_classId,_genderName,_stuImageFile,
            (t, String a, String b, String c, String d, String e, String f, String g, String h, File? file) async {
              (studentList==null)? studentParams.addAll(  {'action':'add-student','first_name':a,'last_name':b,
            'dob':c,'gender':(h=='Male')?'1':'2','address':f,'usersid':userId,'roll_number':d,'admission_id':e,'student_class':g,
            'student_img':(file!=null)?await MultipartFile.fromFile(file.path,filename: file.path.split('/').last):null} ):studentParams.addAll(  {'action':'update-student','first_name':a,'last_name':b,
                'dob':c,'gender':(h=='Male')?'1':'2','address':f,'usersid':userId,'roll_number':d,'admission_id':e,'student_class':g,
                'student_img':(file!=null)?await MultipartFile.fromFile(file.path,filename: file.path.split('/').last):null} );
          printLog("studentParams", studentParams);
          return FormData.fromMap(studentParams);
        }
        )
        .listen(_parent_submit.add)
        .addTo(disposeBag);

    _parent_submit.withLatestFrom(_student_valid,(_, bool v) {
      if(v!=true) printLog('error','Enter Details');
      return v;
    }).where((event) => event)
        .withLatestFrom6(_parentName,_parentType,_occupation,_parentEmail,_parentMobileNo,_sectionId,
            (t, String a, String b, String c, String d, String e,String f) async {
          printLog("studentParams", studentParams);
          (studentList==null)? studentParams.addAll({'parent_name':a,'parent_type':(b=='Mother')?'1':(b=='Father')?'2':'3',
            'user_email':d,'user_mobile':e,'occupation':c,'religion':'1','blood_group':'1','student_section':f,
          }): studentParams.addAll({'parent_name':a,'parent_type':'1',
            'user_email':d,'user_mobile':e,'occupation':c,'religion':'1','blood_group':'1','student_section':f,'studentId':studentList!.id,'parentId':studentList!.parentId,'parentUserId':(studentList!.parentUserId!=null)?studentList!.parentUserId:''
          });
          printLog("studentParams", studentParams);
          return FormData.fromMap(studentParams);}

    ).listen(_submitstudent.add)

        .addTo(disposeBag);

    _submitstudent.
    doOnData((_)=> _isLoading.add(true))
        .map(subjectService!.addImageData)
        .listen((event) {

      event
          .asStream()
          .where((r) => r.error == null)
          .map((r) => r.data)
          .listen((u) async {
        _handleAuthResponse(event);

      }).addTo(disposeBag);

    }).addTo(disposeBag);

  }
   void getDate(int type){
    calenderBottomSheet(onCallback: (dateTime){
      startDate=dateTime.toString();
      stuDOB.add(startDate!);
    },selectedDate:DateTime.parse(startDate!),type:type );

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
          ToastMessage(u.message!);
          _isLoading.add(false);
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(
              content:  Text(u.message!),
            ),
          );
           Navigator.pop(Get.context!);
        }else {
          ToastMessage(u.message!);
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

