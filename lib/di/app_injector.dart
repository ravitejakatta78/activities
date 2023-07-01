
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:publicschool_app/di/i_register_login.dart';
import 'package:publicschool_app/di/i_register_signup.dart';
import 'package:publicschool_app/manager/data_base/db_manager.dart';
import 'package:publicschool_app/manager/user_data_store/user_data_store.dart';
import 'package:publicschool_app/di/i_register_dashboard.dart';
import 'package:publicschool_app/di/i_intro_page.dart';
import '../app/arch/bloc_provider.dart';
import '../app/bloc/app_bloc.dart';
import '../pages/splash/app_page.dart';


class AppInjector{
  static final AppInjector instance=AppInjector._internal();
  final container=Injector.appInstance;

  //App
  BlocProvider<AppBloc> get app => container.get();
  UserDataStore get userDataStore => container.get();

   AppInjector._internal() {
    container.registerDependency<BlocProvider<AppBloc>>(() {
      return BlocProvider(child: AppPage(), bloc: AppBloc("",userDataStore));


    });
    registerLogin();
    registerSignUp();
    registerIntroPage();
    registerDashboard();
    registerChangePassword();

    container.registerSingleton(() => UserDataStore(DBManager()));

  }
}