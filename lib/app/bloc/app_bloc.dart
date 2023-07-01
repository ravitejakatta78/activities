import 'package:flutter/cupertino.dart';
import 'package:publicschool_app/app/arch/bloc_provider.dart';
import 'package:publicschool_app/di/i_intro_page.dart';
import 'package:publicschool_app/di/i_register_dashboard.dart';
import 'package:publicschool_app/helper/logger/logger.dart';
import 'package:rxdart/rxdart.dart';

import '../../di/app_injector.dart';
import '../../manager/user_data_store/user_data_store.dart';
import '../../model/login/login_response.dart';

class AppBloc extends BlocBase{

  String? title;
  UserDataStore userDataStore;
  BehaviorSubject<void> _onRouteGenrate = BehaviorSubject();
  BehaviorSubject<Widget> _startPage = BehaviorSubject();

  Sink<void> get onRouteGenrate=> _onRouteGenrate;

  Stream<Widget> get startPage => _startPage;


  AppBloc(this.title,this.userDataStore){
    setUpPlatform();
    init();
  }

  void setUpPlatform() {

  }

  void init() {


  }

  void onClick() async{
    UserDetails? user=await  userDataStore.getUser();
    if(user == null){
      _startPage.add(AppInjector.instance.introPage());
    }else{
      if(user.roleId == null) {
        _startPage.add(AppInjector.instance.introPage());
      } else {
        printLog("PageValue", user.roleId);
        _startPage.add(AppInjector.instance.dashboard());
      }
    }

  }

}
