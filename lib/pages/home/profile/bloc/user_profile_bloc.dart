import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:publicschool_app/di/app_injector.dart';
import 'package:publicschool_app/di/i_register_dashboard.dart';
import 'package:rxdart/rxdart.dart' ;
import '../../../../app/arch/bloc_provider.dart';
import '../../../../common/widgets/toast/toast.dart';
import '../../../../helper/logger/logger.dart';
import '../../../../manager/user_data_store/user_data_store.dart';
import '../../../../model/base_response/request_response.dart';
import '../../../../model/login/login_response.dart';
import '../../../../model/subject/subject_list_data.dart';
import '../../../../repositories/menu_list/subject_api.dart';

typedef BlocProvider<UserProfileBloc> UserProfileFactory();

class UserProfileBloc extends BlocBase {

  UserDataStore userDataStore;
  SubjectService? subjectService;
  final BehaviorSubject<bool> _isLoading =BehaviorSubject.seeded(false);
  final BehaviorSubject<UserDetails> _userDetails=BehaviorSubject();
  final BehaviorSubject<String> _firstName=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _lastName=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _gender=BehaviorSubject();
  final BehaviorSubject<String> _email=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _mobile=BehaviorSubject.seeded("");
  final BehaviorSubject<File?> _image=BehaviorSubject.seeded(null);
  BehaviorSubject<bool> _valid =BehaviorSubject.seeded(false);
  PublishSubject<void> _user_profile_submit = PublishSubject();
  PublishSubject<Future<FormData>> _submitUserProfile = PublishSubject();
  Sink<void>  get user_profile_submit=> _user_profile_submit;
  Sink<Future<FormData>> get submitUserProfile => _submitUserProfile;
  Stream<String> get firstName => _firstName;
  Sink<String> get addFirstName => _firstName;
  Stream<String> get lastName => _lastName;
  Sink<String> get addLastName => _lastName;
  Stream<String> get gender => _gender;
  Sink<String> get addGender => _gender;
  Stream<String> get email => _email;
  Sink<String> get addEmail => _email;
  Stream<String> get mobile => _mobile;
  Sink<String> get addMobile => _mobile;
  Stream<File?> get image => _image;
  Sink<File?> get addImage => _image;
  Stream<bool> get isLoading => _isLoading;
  Stream<UserDetails> get userDetails => _userDetails;
  String? userId;

  UserProfileBloc(this.userDataStore,this.subjectService){
    getUser();
  }

  void getUser() async{
    UserDetails? userDetails= await userDataStore.getUser();
    printLog("title", userDetails!.firstName);
    _userDetails.add(userDetails);

     userId=userDetails.usersid!;
    _firstName.add(userDetails.firstName!);
    _lastName.add(userDetails.lastName!);
    _gender.add(userDetails.gender!);
    _email.add(userDetails.email!);
    _mobile.add(userDetails.mobile!);

    CombineLatestStream.combine6(_firstName, _lastName, _gender, _mobile, _email, _image, (String a, String b, String c, String d, String e, File? file) =>
    (a.isNotEmpty && b.isNotEmpty && c.isNotEmpty && d.isNotEmpty && e.isNotEmpty))
        .listen(_valid.add)
        .addTo(disposeBag);
    _user_profile_submit
        .withLatestFrom(_valid, (_, bool v){
      printLog("title", "onPressed");
      if(v!=true) ToastMessage('Enter Details');
      return v;
    }).where((event) => event).withLatestFrom6(_firstName, _lastName, _gender, _mobile, _email, _image,
            (t, String a,String b,String c,String d,String e, File? imageFile) async {
              return FormData.fromMap({'action':'update-profile','usersid':userId,'first_name':a,'last_name':b,'gender':(c=='Male')?1:2,'user_mobile':d,'user_email':e,
                'img_url':await MultipartFile.fromFile(imageFile!.path,filename: imageFile.path.split('/').last)});})
        .listen(_submitUserProfile.add)
        .addTo(disposeBag);

    _submitUserProfile.doOnData((_)=> _isLoading.add(true))
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

    })
        .addTo(disposeBag);
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
          await userDataStore.insert(u.user_details!);

        }else {
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

      }
    }).addTo(disposeBag);

  }

}