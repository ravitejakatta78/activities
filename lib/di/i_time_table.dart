

import 'package:publicschool_app/pages/splash/intro_page.dart';
import 'package:publicschool_app/repositories/menu_list/subject_api.dart';

import '../app/arch/bloc_provider.dart';
import '../pages/splash/bloc/intro_page.dart';
import '../pages/time_table/bloc/add_time_table_bloc.dart';
import '../pages/time_table/bloc/time_table_bloc.dart';
import '../pages/time_table/widgets/add_time_table_list.dart';
import '../pages/time_table/widgets/time_table_list.dart';
import 'app_injector.dart';

extension TimeTableExtension on AppInjector{

  TimeTableBlocFactory get timeTablePage => container.get();

  AddTimeTableBlocFactory get addTimeTablePage => container.get();

  registerTimeTablePage(){

    container.registerDependency<TimeTableBlocFactory>((){
      return(type)=> BlocProvider<TimeTableBloc>(bloc: TimeTableBloc(type, userDataStore, SubjectService(userDataStore)) , child: TimeTableList());

    });


  }
  registerAddTimeTablePage(){

    container.registerDependency<AddTimeTableBlocFactory>((){
      return(type)=> BlocProvider<AddTimeTableBloc>(bloc: AddTimeTableBloc(type, userDataStore, SubjectService(userDataStore)) , child: AddTimeTableList());

    });


  }
}
