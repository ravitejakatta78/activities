

import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:publicschool_app/app/arch/bloc_provider.dart';
import 'package:publicschool_app/model/subject/faculity_list.dart';
import 'package:rxdart/rxdart.dart';
import '../../../common/widgets/toast/toast.dart';
import '../../../helper/logger/logger.dart';
import '../../../manager/user_data_store/user_data_store.dart';
import '../../../model/base_response/request_response.dart';
import '../../../model/dashboard/dashboard_data.dart';
import '../../../model/login/login_response.dart';
import '../../../model/subject/subject_list_data.dart';
import '../../../repositories/menu_list/subject_api.dart';

typedef BlocProvider<AddFacultyBloc> AddFacultyFactory(FaculityList? faculityList);
class AddFacultyBloc extends BlocBase{
   UserDataStore? userDataStore;
   SubjectService? subjectService;
   FaculityList? faculityList;
   BehaviorSubject<String> _title = BehaviorSubject.seeded("");
   BehaviorSubject<String> _errorMsg=BehaviorSubject.seeded("");
   final BehaviorSubject<String> _facultyName=BehaviorSubject.seeded("");
   final BehaviorSubject<String> _facultyQulfyName=BehaviorSubject.seeded("");
   final BehaviorSubject<String> _facultyMail=BehaviorSubject.seeded("");
   final BehaviorSubject<String> _facultyMobile=BehaviorSubject.seeded("");
   final BehaviorSubject<String> _facultyAddress=BehaviorSubject.seeded("");
   final BehaviorSubject<String> _subjectName=BehaviorSubject();
   final BehaviorSubject<String> _genderName=BehaviorSubject();
   final BehaviorSubject<File?> _imageFile=BehaviorSubject.seeded(null);
   BehaviorSubject<bool> _faculty_valid =BehaviorSubject.seeded(false);
   PublishSubject<void> _faculty_submit = PublishSubject();
   Sink<void>  get faculty_submit=> _faculty_submit;
   final PublishSubject<List<SubjectList>> _subjectList=PublishSubject();
   final PublishSubject<List<FaculityList>> _faculityList=PublishSubject();

   PublishSubject<Future<FormData>> _submitfaculty = PublishSubject();
   final BehaviorSubject<bool> _isLoading=BehaviorSubject.seeded(false);
   Stream<String> get gender_name => _genderName;
   Stream<String> get errorMsg => _errorMsg;
   Stream<bool> get isLoading => _isLoading;
   Stream<String> get subjectName => _subjectName;
   Sink<String> get addSubjectName => _subjectName;
   Sink<String> get addFacultyName => _facultyName;
   Stream<String> get facultyName => _facultyName;
   Stream<String> get facultyQulfyName => _facultyQulfyName;
   Stream<String> get facultyMail => _facultyMail;
   Stream<String> get facultyMobile => _facultyMobile;
   Stream<String> get facultyAddress => _facultyAddress;
   Stream<File?> get image_File => _imageFile;
   Sink<File?> get image => _imageFile;
   Sink<String> get addFacultyQulfyName => _facultyQulfyName;
   Sink<String> get addFacultyMail => _facultyMail;
   Sink<String> get addFacultyMobile => _facultyMobile;
   Sink<String> get addFacultyAddress => _facultyAddress;
   Stream<List<SubjectList>> get subjectList => _subjectList;
   Stream<List<FaculityList>> get facultyList => _faculityList;
   Sink<String> get gender => _genderName;
   String userId="";
   Map<String,dynamic> parentParams={};
   AddFacultyBloc(this.userDataStore,this.subjectService,this.faculityList){
     facultyInit();
     getFacultyList('subjectList');
   }
   void getFacultyList(String type) async {
     UserDetails? userDetails=await  userDataStore?.getUser();
     userId=userDetails!.usersid!;
     _isLoading.add(true);
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
               printLog('subjectList',value.data!.subjectList);

             }
           }

         } else _errorMsg.add('Invalid');
       }else _errorMsg.add('Invalid');
     });
   }
   void facultyInit() async {
     if(faculityList!=null){
       addFacultyName.add((faculityList!.faculityName==null)?'':faculityList!.faculityName!);
       addFacultyQulfyName.add((faculityList!.qualification==null)?"":faculityList!.qualification!);
       addFacultyMail.add((faculityList!.email==null)?"":faculityList!.email!);
       addFacultyMobile.add((faculityList!.mobile==null)?"":faculityList!.mobile!);
       addFacultyAddress.add((faculityList!.address==null)?'':faculityList!.address!);
       gender.add((faculityList!.gender==null)?"":faculityList!.gender!);
     }
     UserDetails? userDetails=await userDataStore!.getUser();
     userId=userDetails!.usersid!;
     CombineLatestStream.combine8(_facultyName,_subjectName,_facultyAddress,_facultyMail,_facultyMobile,_facultyQulfyName,_genderName,_imageFile,
             (String a, String b, String c, String d, String e, String f, String g,File? file ) => a.isNotEmpty && b.isNotEmpty && c.isNotEmpty && d.isNotEmpty && e.isNotEmpty && f.isNotEmpty && g.isNotEmpty)
         .listen(_faculty_valid.add)
         .addTo(disposeBag);
     _faculty_submit
         .withLatestFrom(_faculty_valid, (_, bool v) {
       if(v!=true) printLog('error','Enter Details');
       return v;
     }).where((event) => event)
         .withLatestFrom8(_facultyName,_subjectName,_facultyAddress,_facultyMail,_facultyMobile,_facultyQulfyName,_genderName,_imageFile,
             (t, String a, String b, String c, String d, String e, String f, String g,File? imageFile) async {
               (faculityList!=null)?parentParams.addAll({'action':'update-faculity','faculity_name':a,'subject_id':b.split(',')[0],'qualification':f,'email':d,'mobile':e,'gender':(g=='Male')?'1':'2','address':c,'usersid':userId,'faculity_id':faculityList!.id,
                 'faculity_pic':(imageFile!=null)?await MultipartFile.fromFile(imageFile.path,filename: imageFile.path.split('/').last):null}):parentParams.addAll({'action':'add-faculity','faculity_name':a,'subject_id':b.split(',')[0],'qualification':f,'email':d,'mobile':e,'gender':(g=='Male')?'1':'2','address':c,'usersid':userId,
                 'faculity_pic':(imageFile!=null)?await MultipartFile.fromFile(imageFile.path,filename: imageFile.path.split('/').last):null});
               printLog("ParentParams", parentParams);
           return FormData.fromMap(parentParams);
         }


     ).listen(_submitfaculty.add)
         .addTo(disposeBag);

     _submitfaculty.
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
           ScaffoldMessenger.of(Get.context!).showSnackBar(
             SnackBar(
               content:  Text(u.message!),
             ),
           );
            Navigator.pop(Get.context!);
         }else {
           printLog('message',u.message!);
           ToastMessage(u.message!);
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