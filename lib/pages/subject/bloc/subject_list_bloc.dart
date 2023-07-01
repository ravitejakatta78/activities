
import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:publicschool_app/common/widgets/container_widget/container_widget.dart';
import 'package:publicschool_app/common/widgets/toast/toast.dart';
import 'package:publicschool_app/di/i_subject_list.dart';
import 'package:publicschool_app/model/dashboard/dashboard_data.dart';
import 'package:publicschool_app/model/subject/faculity_list.dart';
import 'package:publicschool_app/model/subject/student_list.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

import '../../../app/arch/bloc_provider.dart';
import '../../../common/widgets/bottom_sheet/calende_bottom_sheet.dart';
import '../../../di/app_injector.dart';
import '../../../helper/logger/logger.dart';
import '../../../manager/user_data_store/user_data_store.dart';
import '../../../model/base_response/request_response.dart';
import '../../../model/login/login_response.dart';
import '../../../model/subject/subject_list_data.dart';
import '../../../repositories/menu_list/subject_api.dart';

typedef BlocProvider<SubjectListBloc> SubjectFactory(String type);

class SubjectListBloc extends BlocBase {
  String type;
  final UserDataStore? _userDataStore;
  SubjectService? subjectService;
  final BehaviorSubject<String> _title = BehaviorSubject.seeded("");
  final BehaviorSubject<String> _errorMsg=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _subjectName=BehaviorSubject();
  final BehaviorSubject<String> _genderName=BehaviorSubject();
  final BehaviorSubject<String> _sectionName=BehaviorSubject.seeded("");

  final BehaviorSubject<String> _action=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _className=BehaviorSubject();
  final BehaviorSubject<String> _facultyName=BehaviorSubject();
  final BehaviorSubject<String> _facultyQulfyName=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _facultyMail=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _facultyMobile=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _facultyAddress=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _stuFirstName=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _stuLastName=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _stuDOB=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _stuRollNo=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _stuAdmissionID=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _stuAddress=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _parentName=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _parentType=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _occupation=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _parentEmail=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _parentMobileNo=BehaviorSubject.seeded("");

  Sink<String> get stuFirstName => _stuFirstName;
  Sink<String> get stuLastName => _stuLastName;
  Sink<String> get stuDOB => _stuDOB;
  Sink<String> get stuRollNo => _stuRollNo;
  Sink<String> get stuAddress => _stuAddress;
  Sink<String> get stuAdmissionID => _stuAdmissionID;
  Sink<String> get parentName => _parentName;
  Sink<String> get parentType => _parentType;
  Sink<String> get occupation => _occupation;
  Sink<String> get parentEmail => _parentEmail;
  Sink<String> get parentMobileNo => _parentMobileNo;



  final BehaviorSubject<bool> _isLoading=BehaviorSubject.seeded(true);
  final PublishSubject<List<FaculityList>> _faculityList=PublishSubject();
  final PublishSubject<List<SubjectList>> _subjectList=PublishSubject();
  final PublishSubject<List<ClassList>> _classList=PublishSubject();
  final BehaviorSubject<File?> _imageFile=BehaviorSubject.seeded(null);
  final BehaviorSubject<File?> _stuImageFile=BehaviorSubject.seeded(null);

  final BehaviorSubject<Tuple2<bool,List<ContainerWithWidget>>> _content=BehaviorSubject();
  BehaviorSubject<bool> _valid =BehaviorSubject.seeded(false);
  BehaviorSubject<bool> _faculty_valid =BehaviorSubject.seeded(false);
  BehaviorSubject<bool> _student_valid =BehaviorSubject.seeded(false);
  BehaviorSubject<bool> _parent_valid =BehaviorSubject.seeded(false);

  PublishSubject<void> _class_submit = PublishSubject();
  PublishSubject<void> _subject_submit = PublishSubject();
  PublishSubject<void> _faculty_submit = PublishSubject();
  PublishSubject<void> _student_submit = PublishSubject();
  PublishSubject<void> _parent_submit = PublishSubject();

  PublishSubject<Map<String,dynamic>> _submitclass = PublishSubject();
  PublishSubject<Map<String,dynamic>> _submitsubject = PublishSubject();
  PublishSubject<Future<FormData>> _submitfaculty = PublishSubject();
  PublishSubject<Future<FormData>> _submitstudent = PublishSubject();


  Stream<String> get errorMsg => _errorMsg;

  Sink<void>  get subject_submit=> _subject_submit;
  Sink<void>  get class_submit=> _class_submit;
  Sink<void>  get faculty_submit=> _faculty_submit;
  Sink<void>  get student_submit=> _student_submit;

  Sink<Map<String,dynamic>> get submitclass => _submitclass;
  Sink<Map<String,dynamic>> get submitsubject => _submitsubject;
  Sink<Future<FormData>> get submitfaculty => _submitfaculty;
  Sink<Future<FormData>> get submitstudent => _submitstudent;

  Stream<File?> get image_File => _imageFile;
  Stream<File?> get stuImage_File => _stuImageFile;

  Sink<File?> get image => _imageFile;
  Sink<File?> get stuImage => _stuImageFile;


  Stream<bool> get isLoading => _isLoading;
  Stream<String> get title => _title;
  Stream<Tuple2<bool,List<ContainerWithWidget>>> get onListUpdate => _content;
  Sink<String> get subject => _subjectName;
  Stream<String> get subject_name => _subjectName;
  Stream<String> get gender_name => _genderName;
  Stream<String> get section_name => _sectionName;
  Stream<String> get class_name => _className;
  Sink<String> get class1 => _className;
  Stream<String> get studentDOB => _stuDOB;
  Sink<String> get gender => _genderName;
  Sink<String> get section => _sectionName;
  Sink<String> get action => _action;
  Stream<String> get facultyName => _facultyName;
  Sink<String> get faculty_name => _facultyName;
  Sink<String> get facultyQulfyName => _facultyQulfyName;
  Sink<String> get facultyMail => _facultyMail;
  Sink<String> get facultyMobile => _facultyMobile;
  Sink<String> get facultyAddress => _facultyAddress;
  Sink<String> get className => _className;
  Stream<List<FaculityList>> get faculityList => _faculityList;
  Stream<List<SubjectList>> get subjectList => _subjectList;
  Stream<List<ClassList>> get classList => _classList;
  String? startDate=new DateFormat('yyyy-MM-dd').format(new DateTime.now());


  SubjectListData? subjectListData=null;
  String userId="";
  Map<String,dynamic> studentParams={};

  SubjectListBloc(this.type,this._userDataStore,this.subjectService){
    init();
    //facultyInit();
    //studentInit();
  }
  void getData() async {
    printLog("type title", type);
    _title.add(type);
    UserDetails? userDetails=await  _userDataStore?.getUser();
    printLog("userDetails", userDetails?.userName);
    _isLoading.add(true);
      subjectService!.subjectList(DashboardData((type=='Subjects')?'subjectList':(type=='Classes')?'classList':(type=='Faculty')?'faculityList':(type=='Students')?'studentList':'', userDetails!.usersid)).then((value) {
        _isLoading.add(false);
        if(value.error==null){
          if(value.data!.status=="200"){
            subjectListData=value.data!;
            if(value.data!.subjectList!=null){
              if(value.data!.subjectList!.isNotEmpty){
                _content.add(Tuple2(false,(value.data!.subjectList!.map((e) => SubjectContainer(subjectList: e))).toList() ));
              }
            }else if(value.data!.classList!=null){
              if(value.data!.classList!.isNotEmpty){
                _content.add(Tuple2(false,(value.data!.classList!.map((e) => ClassContainer(classList: e))).toList() ));

              }
            }else if(value.data!.faculityList!=null){
              if(value.data!.faculityList!.isNotEmpty){
                _content.add(Tuple2(false,(value.data!.faculityList!.map((e) => FacultyContainer(facultyList: e,onCallback: (type,faculty){
                  if(type==0){
                    Get.to(AppInjector.instance.addFaculty(faculty))!.then((value) => getData());

                  }
                }))).toList() ));
              }
            }else if(value.data!.studentList!=null){
              if(value.data!.studentList!.isNotEmpty){
                _content.add(Tuple2(false,(value.data!.studentList!.map((e) => StudentListContainer(studentList: e,onCallback: (type,student){
                  if(type==0){
                    Get.to(AppInjector.instance.studentAdd(student))!.then((value) => getData());
                  }

                }))).toList()));

              }
            }

          } else _errorMsg.add('Invalid');
        }else _errorMsg.add('Invalid');
      });


  }

  void getFacultyList(String type) async {
    UserDetails? userDetails=await  _userDataStore?.getUser();
    userId=userDetails!.usersid!;

    subjectService!.subjectList(DashboardData(type, userId)).then((value) {
      _isLoading.add(false);
      if(value.error==null){
        if(value.data!.status=="200"){
          if(value.data!.faculityList!=null){
            if(value.data!.faculityList!.isNotEmpty){
            _faculityList.add(value.data!.faculityList!);
            }
          }else if(value.data!.subjectList!=null){
            if(value.data!.subjectList!.isNotEmpty){
              _subjectList.add(value.data!.subjectList!);
              printLog('cubjectList',value.data!.subjectList);

            }

          }else if(value.data!.classList!=null){
            if(value.data!.classList!.isNotEmpty){
              _classList.add(value.data!.classList!);
              printLog('cubjectList',value.data!.classList);

            }

          }

        } else _errorMsg.add('Invalid');
      }else _errorMsg.add('Invalid');
    });
  }
  void onSearch(String value){
    if(subjectListData!.subjectList!=null){
      if(subjectListData!.subjectList!.isNotEmpty){

        List<SubjectList> searchResult=[];

        subjectListData!.subjectList!.forEach((item) {
          if (item.subjectName!.toLowerCase().contains(value.toLowerCase())) searchResult.add(item);
        });
        _content.add(Tuple2(false,(searchResult.map((e) => SubjectContainer(subjectList: e))).toList() ));
      }
    }else if(subjectListData!.classList!=null){
      if(subjectListData!.classList!.isNotEmpty){

        List<ClassList> searchResult=[];

        subjectListData!.classList!.forEach((item) {
          if (item.className!.toLowerCase().contains(value.toLowerCase())) searchResult.add(item);
        });

        _content.add(Tuple2(false,(searchResult.map((e) => ClassContainer(classList: e))).toList() ));

      }
    }else
      if(subjectListData!.faculityList!=null){
      if(subjectListData!.faculityList!.isNotEmpty){

        List<FaculityList> searchResult=[];

        subjectListData!.faculityList!.forEach((item) {
          if (item.faculityName!.toLowerCase().contains(value.toLowerCase())) searchResult.add(item);
        });

        _content.add(Tuple2(false,(searchResult.map((e) => FacultyContainer(facultyList: e))).toList() ));

      }
    }
      else if(subjectListData!.studentList!=null){
      if(subjectListData!.studentList!.isNotEmpty){

        List<StudentList> searchResult=[];

        subjectListData!.studentList!.forEach((item) {
          if (item.firstName!.toLowerCase().contains(value.toLowerCase())) searchResult.add(item);
        });

        _content.add(Tuple2(false,(searchResult.map((e) => StudentListContainer(studentList: e,onCallback: (type,student){
          if(type==0){
            Get.to(AppInjector.instance.studentAdd(student))!.then((value) => getData());
          }
        }))).toList()));

      }
    }





  }


  @override
  void dispose() {
    // TODO: implement dispose
    _subjectName.close();
    _facultyName.close();
    _faculityList.close();
    _content.close();
    _genderName.close();
    _sectionName.close();
    _imageFile.close();
    _stuImageFile.close();
    super.dispose();
  }

  void init() async {
    UserDetails? userDetails=await  _userDataStore?.getUser();
    userId=userDetails!.usersid!;

    CombineLatestStream.combine2(_subjectName, _action,
            (String a, String b) => a.isNotEmpty && b.isNotEmpty)
        .listen(_valid.add)
        .addTo(disposeBag);

    _subject_submit
        .withLatestFrom(_valid, (_, bool v) {
      if(v!=true) ToastMessage('Enter Details');
      return v;
    }).where((event) => event)
        .withLatestFrom2(_subjectName, _action, (t, String a, String b) => {'action':b,'subject':a,'usersid':userId})
        .listen(_submitsubject.add)
        .addTo(disposeBag);

    _submitsubject.
    doOnData((_)=> _isLoading.add(true))
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


    CombineLatestStream.combine2(_className, _facultyName,
            (String a, String b) => a.isNotEmpty && b.isNotEmpty)
        .listen(_valid.add)
        .addTo(disposeBag);

    _class_submit
        .withLatestFrom(_valid, (_, bool v) {
      if(v!=true) ToastMessage('Enter Details');
      return v;
    }).where((event) => event)
        .withLatestFrom2(_className, _facultyName, (t, String a, String b) => {'action':'add-class','class_name':a,'teacher_id':b.split(',')[0],'usersid':userId})
        .listen(_submitclass.add)
        .addTo(disposeBag);

    _submitclass.
    doOnData((_)=> _isLoading.add(true))
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
  void facultyInit() async {
    UserDetails? userDetails=await  _userDataStore?.getUser();
    userId=userDetails!.usersid!;
    CombineLatestStream.combine8(_facultyName,_subjectName,_facultyAddress,_facultyMail,_facultyMobile,_facultyQulfyName,_genderName,_imageFile,
            (String a, String b, String c, String d, String e, String f, String g,File? file ) => a.isNotEmpty && b.isNotEmpty && c.isNotEmpty && d.isNotEmpty && e.isNotEmpty && f.isNotEmpty && g.isNotEmpty)
        .listen(_faculty_valid.add)
        .addTo(disposeBag);

    _faculty_submit.withLatestFrom(_faculty_valid, (_, bool v) {
      if(v!=true) printLog('error','Enter Details');
      return v;
    }).where((event) => event)
        .withLatestFrom8(_facultyName,_subjectName,_facultyAddress,_facultyMail,_facultyMobile,_facultyQulfyName,_genderName,_imageFile,
            (t, String a, String b, String c, String d, String e, String f, String g,File? imageFile) async {
          printLog("calling", "data calling");
          return FormData.fromMap({'action':'add-faculity','faculity_name':a,'subject_id':b.split(',')[0],'qualification':f,'email':d,'mobile':e,'gender':(g=='Male')?'1':'2','address':c,'usersid':userId,
            'faculity_pic':await MultipartFile.fromFile(imageFile!.path,filename: imageFile.path.split('/').last)});}
        
        
    ).listen(_submitfaculty.add)
        .addTo(disposeBag);

    _submitfaculty.
    doOnData((_)=> _isLoading.add(true))
        .map(subjectService!.addImageData)
        .listen((event) {
      _isLoading.add(false);
      event
          .asStream()
          .where((r) => r.error == null)
          .map((r) => r.data)
          .listen((u) async {
        _handleAuthResponse(event);

      }).addTo(disposeBag);

    }).addTo(disposeBag);

  }
  void studentInit() async {
    UserDetails? userDetails=await  _userDataStore?.getUser();
    userId=userDetails!.usersid!;

    CombineLatestStream.combine9(_stuFirstName,_stuLastName,_stuDOB,_stuRollNo,_stuAdmissionID,_stuAddress,_className,_genderName,_stuImageFile,
            (String a, String b, String c, String d, String e, String f, String g,String h,File? file ) => a.isNotEmpty && b.isNotEmpty && c.isNotEmpty && d.isNotEmpty && e.isNotEmpty && f.isNotEmpty && g.isNotEmpty && h.isNotEmpty)
        .listen(_student_valid.add)
        .addTo(disposeBag);
    CombineLatestStream.combine5(_parentName,_parentType,_occupation,_parentEmail,_parentMobileNo, (String a, String b, String c, String d, String e) => a.isNotEmpty && b.isNotEmpty && c.isNotEmpty && d.isNotEmpty && e.isNotEmpty)
        .listen(_student_valid.add)
        .addTo(disposeBag);

    _student_submit.withLatestFrom(_student_valid,(_, bool v) {
      if(v!=true) printLog('error','Enter Details');
      return v;
    }).where((event) => event)
        .withLatestFrom9(_stuFirstName,_stuLastName,_stuDOB,_stuRollNo,_stuAdmissionID,_stuAddress,_className,_genderName,_stuImageFile,
            (t, String a, String b, String c, String d, String e, String f, String g, String h, File? file) async {

              studentParams.addAll({'action':'add-student','first_name':a,'last_name':b,
                'dob':c,'gender':(h=='Male')?'1':'2','address':f,'usersid':userId,'roll_number':d,'admission_id':e,'student_class':g.split(',')[0],
                'student_img':await MultipartFile.fromFile(file!.path,filename: file.path.split('/').last)});

              printLog("studentParams", studentParams);

          return FormData.fromMap(studentParams);}

            ).listen(_parent_submit.add)

        .addTo(disposeBag);


    _parent_submit.withLatestFrom(_student_valid,(_, bool v) {
      if(v!=true) printLog('error','Enter Details');
      return v;
    }).where((event) => event)
        .withLatestFrom5(_parentName,_parentType,_occupation,_parentEmail,_parentMobileNo,
            (t, String a, String b, String c, String d, String e) async {
          printLog("studentParams", studentParams);
          studentParams.addAll({'parent_name':a,'parent_type':'1',
            'user_email':d,'user_mobile':e,'occupation':c,'religion':'1','blood_group':'1'
            });
          printLog("studentParams", studentParams);
          return FormData.fromMap(studentParams);}

    ).listen(_submitstudent.add)

        .addTo(disposeBag);

    _submitstudent.
    doOnData((_)=> _isLoading.add(true))
        .map(subjectService!.addImageData)
        .listen((event) {
      _isLoading.add(false);
      event
          .asStream()
          .where((r) => r.error == null)
          .map((r) => r.data)
          .listen((u) async {
        _handleAuthResponse(event);

      }).addTo(disposeBag);

    }).addTo(disposeBag);

  }

  getDate(int type){
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
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(
              content:  Text(u.message!),
            ),
          );
         // Navigator.pop(Get.context!);
          getData();
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