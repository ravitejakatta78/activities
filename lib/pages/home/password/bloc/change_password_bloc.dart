
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:publicschool_app/di/i_register_dashboard.dart';
import 'package:publicschool_app/pages/home/password/widget/change_password.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../app/arch/bloc_provider.dart';
import '../../../../common/widgets/toast/toast.dart';
import '../../../../di/app_injector.dart';
import '../../../../helper/logger/logger.dart';
import '../../../../manager/user_data_store/user_data_store.dart';
import '../../../../model/base_response/request_response.dart';
import '../../../../model/login/login_response.dart';
import '../../../../model/subject/subject_list_data.dart';
import '../../../../repositories/menu_list/subject_api.dart';

typedef BlocProvider<ChangePasswordBloc> ChangePasswordFactory();

class ChangePasswordBloc extends BlocBase {
  SubjectService? subjectService;
  UserDataStore? _userDataStore;
  BehaviorSubject<String> _oldPassword =BehaviorSubject.seeded("");
  BehaviorSubject<String> _newPassword =BehaviorSubject.seeded("");
  BehaviorSubject<bool> _valid =BehaviorSubject.seeded(false);
  PublishSubject<void> _passwordSubmit = PublishSubject();
  BehaviorSubject<bool> _isLoading =BehaviorSubject.seeded(false);
  PublishSubject<Map<String,dynamic>> _submitPassword = PublishSubject();
  Sink<String> get  oldPassword=> _oldPassword;
  Sink<String> get  newPassword=> _newPassword;
  Stream<bool> get  valid=> _valid;
  Sink<void>  get passwordSubmit=> _passwordSubmit;
  Stream<bool> get isLoading=> _isLoading;
  Sink<Map<String,dynamic>> get submitPassword => _submitPassword;
  String userId="";
  ChangePasswordBloc(this._userDataStore,this.subjectService){
    setListeners();
  }
  void setListeners() async{
    UserDetails? userDetails=await  _userDataStore?.getUser();
    userId=userDetails!.usersid!;

    CombineLatestStream.combine2(_oldPassword, _newPassword,
            (String a, String b) => a.isNotEmpty && b.isNotEmpty)
        .listen(_valid.add)
        .addTo(disposeBag);

    _passwordSubmit
        .withLatestFrom(_valid, (_, bool v) {
      if(v!=true) ToastMessage('Enter Details');
      return v;

    })
        .where((event) => event)
        .withLatestFrom2(_oldPassword, _newPassword,
            (t, String a, String b) => { 'action':'update-password', 'usersid':userId, 'old_password':a, 'new_password':b})
        .listen(_submitPassword.add)
        .addTo(disposeBag);
    _submitPassword.
    doOnData((_)=> _isLoading.add(true))
        .map(subjectService!.addData)
        .listen((event) {

      _handleAuthResponse(event);
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
          printLog("message", u.message!);
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(
              content:Text(u.message!),
            ),
          );
           //Navigator.pop(Get.context!);
          Get.offAll(AppInjector.instance.dashboard);
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
