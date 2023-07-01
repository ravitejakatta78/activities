import 'package:publicschool_app/pages/attendance/bloc/faculty_register_bloc.dart';
import 'package:publicschool_app/repositories/menu_list/subject_api.dart';

import '../app/arch/bloc_provider.dart';
import '../pages/attendance/bloc/faculty_attendance_bloc.dart';
import '../pages/attendance/faculty_attendance.dart';
import '../pages/attendance/widget/faculty_register.dart';
import 'app_injector.dart';

extension FacultyAttendanceList on AppInjector {

  FacultyAttendanceFactory get facultyAttendance => container.get();

  FacultyRegisterFactory get facultyRegister => container.get();



  registerFacultyAttendance(){

    container.registerDependency<FacultyAttendanceFactory>((){
      return(type)=> BlocProvider<FacultyAttendanceBloc>(bloc:FacultyAttendanceBloc(type,userDataStore,SubjectService(userDataStore)),child: FacultyAttendance());

    });

  }
  registerFacultyRegister(){

    container.registerDependency<FacultyRegisterFactory>((){
      return(type,name)=> BlocProvider<FacultyRegisterBloc>(bloc:FacultyRegisterBloc(type!,name,userDataStore,SubjectService(userDataStore)),child: FacultyRegister());


    });

  }




}