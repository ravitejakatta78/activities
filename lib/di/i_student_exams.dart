import 'package:publicschool_app/repositories/menu_list/subject_api.dart';
import '../app/arch/bloc_provider.dart';
import '../pages/exams/bloc/add_exams_marks_bloc.dart';
import '../pages/exams/bloc/exams_schedule_list_bloc.dart';
import '../pages/exams/widgets/add_exam.dart';
import '../pages/exams/bloc/add_exam_bloc.dart';
import '../pages/exams/bloc/exams_list_bloc.dart';
import '../pages/exams/widgets/add_exam_marks.dart';
import '../pages/exams/widgets/exams_list.dart';
import '../pages/exams/widgets/exams_schedule_list.dart';
import 'app_injector.dart';

extension StudentExamsList on AppInjector {

 // StudentExamsFactory get studentExamsList => container.get();
 // BlocProvider<StudentExamsBloc> get studentExamsList => container.get<BlocProvider<StudentExamsBloc>>();
  //AddStudentExamsFactory get addExams => container.get();
  AddExamMarksFactory get examDetails => container.get();
  ExamsScheduleListFactory get examsScheduleList => container.get();
  AddStudentsExamFactory get studentExamsList => container.get();

  registerStudentExams(){
    container.registerDependency<AddStudentsExamFactory>((){
      return(type)=> BlocProvider<StudentExamsBloc>(bloc:StudentExamsBloc("",userDataStore,SubjectService(userDataStore),type),child: StudentExams());
    });
    // container.registerDependency<BlocProvider<StudentExamsBloc>>((){
    //   return BlocProvider(
    //       bloc:StudentExamsBloc("",userDataStore,SubjectService(userDataStore),),
    //       child: StudentExams());
    //
    // });

  }

  registerExamsScheduleList(){

    container.registerDependency<ExamsScheduleListFactory>((){
      return(type, examsList)=> BlocProvider<ExamsScheduleListBloc>(bloc:ExamsScheduleListBloc(type,SubjectService(userDataStore),userDataStore, examsList),child: ExamsScheduleList());


    });

  }

  registerAddStudentExams(){

    container.registerDependency<AddStudentExamsFactory>((){
      return(type)=> BlocProvider<AddExamsBloc>(bloc:AddExamsBloc(type,SubjectService(userDataStore),userDataStore),child: AddExam());


    });

  }
  registerExamDetails(){

    container.registerDependency<AddExamMarksFactory>((){
      return(type, examsList)=> BlocProvider<AddExamMarksBloc>(bloc:AddExamMarksBloc(type,SubjectService(userDataStore),userDataStore, examsList),child: AddExamMarks());


    });

  }


}