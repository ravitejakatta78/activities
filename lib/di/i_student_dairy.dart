
import 'package:publicschool_app/model/dairy/dairy_list.dart';
import 'package:publicschool_app/repositories/menu_list/subject_api.dart';

import '../app/arch/bloc_provider.dart';
import '../pages/dairy/bloc/add_student_dairy_bloc.dart';
import '../pages/dairy/bloc/student_dairy_bloc.dart';
import '../pages/dairy/widgets/add_student_dairy.dart';
import '../pages/dairy/widgets/student_dairy_list.dart';
import 'app_injector.dart';

extension StudentDairyExtension on AppInjector{

 // StudentDairyFactory get studentDairyPage => container.get();
  BlocProvider<StudentDairyBloc> get studentDairyPage => container.get<BlocProvider<StudentDairyBloc>>();

  AddStudentDairyFactory get addStudentDairyPage => container.get();
 // BlocProvider<AddStudentDairyBloc> get addStudentDairyPage => container.get<BlocProvider<AddStudentDairyBloc>>();


  registerStudentDairyPage(){

    container.registerDependency<BlocProvider<StudentDairyBloc>>((){
      return  BlocProvider<StudentDairyBloc>(bloc: StudentDairyBloc("", SubjectService(userDataStore),userDataStore ) , child: StudentDairy());

    });

  }
  registerAddStudentDairyPage(){

    container.registerDependency<AddStudentDairyFactory>((){
      return(type,dairy) => BlocProvider<AddStudentDairyBloc>(bloc: AddStudentDairyBloc("", SubjectService(userDataStore),userDataStore ,dairy),
          child: AddStudentDairy());

    });

  }
}
