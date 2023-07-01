import 'package:publicschool_app/pages/attendance/student_attendance.dart';
import 'package:publicschool_app/repositories/menu_list/subject_api.dart';

import '../app/arch/bloc_provider.dart';
import '../pages/attendance/bloc/student_attendance_bloc.dart';
import 'app_injector.dart';

extension StuAttendanceList on AppInjector {

  StuAttendanceFactory get stuAttendance => container.get();

  registerStuAttendance(){

    container.registerDependency<StuAttendanceFactory>((){
      return(type)=> BlocProvider<StuAttendanceBloc>(bloc:StuAttendanceBloc(type,userDataStore,SubjectService(userDataStore)),child: StudentAttendance());


    });

  }

}