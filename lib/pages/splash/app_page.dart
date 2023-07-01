import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:publicschool_app/app/arch/bloc_provider.dart';
import 'package:publicschool_app/app/bloc/app_bloc.dart';
import 'package:publicschool_app/app/life_cycle/life_cycle.dart';
import 'package:publicschool_app/di/app_injector.dart';
import 'package:publicschool_app/di/i_register_login.dart';
import 'package:publicschool_app/pages/splash/curve.dart';
import 'package:publicschool_app/pages/splash/intro_page.dart';
import 'package:publicschool_app/utilities/fonts.dart';

import '../../utilities/ps_colors.dart';

class AppPage extends StatefulWidget {
  const AppPage({Key? key}) : super(key: key);

  @override
  AppPageState createState() => AppPageState();
}

class AppPageState extends State<AppPage> {

 late AppBloc _bloc;
  @override
  void initState() {
   _bloc=BlocProvider.of(context);
   _bloc.onClick();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

      return LifeCycleManager(
        child: GetMaterialApp (
          themeMode: ThemeMode.light,
        routingCallback: (r)=>_bloc.onRouteGenrate.add(null),
        home: StreamBuilder<Widget>(
          stream: _bloc.startPage,
          builder: (c, s) {
            return (s.data!=null)?s.data!:Container(color:Colors.white,);
            
          }
        ),

        ),
      );
  }
}

