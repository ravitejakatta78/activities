
import 'package:publicschool_app/repositories/menu_list/subject_api.dart';

import '../app/arch/bloc_provider.dart';
import '../pages/Fees/bloc/add_student_fees_bloc.dart';
import '../pages/Fees/bloc/student_fees_bloc.dart';
import '../pages/Fees/widgets/add_student_fees.dart';
import '../pages/Fees/widgets/student_fees_list.dart';

import 'app_injector.dart';

extension StudentFeesExtension on AppInjector{

  BlocProvider<StudentFeesBloc> get studentFeesPage => container.get<BlocProvider<StudentFeesBloc>>();

  //BlocProvider<AddStudentFeesBloc> get addStudentFeesPage => container.get<BlocProvider<AddStudentFeesBloc>>();
  AddStudentFeesBlocFactory get addStudentFeesPage => container.get();

  registerStudentFeesPage(){

    container.registerDependency<BlocProvider<StudentFeesBloc>>((){
      return  BlocProvider<StudentFeesBloc>(bloc: StudentFeesBloc("", SubjectService(userDataStore),userDataStore ) , child: StudentFees());

    });

  }
  registerAddStudentFeesPage(){

    container.registerDependency<AddStudentFeesBlocFactory>((){
      return(type)=> BlocProvider<AddStudentFeesBloc>(bloc: AddStudentFeesBloc(type, userDataStore, SubjectService(userDataStore)) , child: AddStudentFees());

    });

  }
}
