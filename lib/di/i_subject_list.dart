import 'package:publicschool_app/manager/user_data_store/user_data_store.dart';
import 'package:publicschool_app/repositories/menu_list/subject_api.dart';
import '../app/arch/bloc_provider.dart';
import '../pages/faculty/bloc/add_faculty_bloc.dart';
import '../pages/faculty/widgets/add_faculty.dart';
import '../pages/students/bloc/add_student_bloc.dart';
import '../pages/students/widgets/add_student.dart';
import '../pages/subject/bloc/subject_list_bloc.dart';
import '../pages/subject/subjects.dart';
import 'app_injector.dart';

extension AddSubjectsList on AppInjector {

  SubjectFactory get subjects => container.get();
  AddStudentFactory get studentAdd => container.get();
  AddFacultyFactory get addFaculty => container.get();


  registerSubjectList(){

    container.registerDependency<SubjectFactory>((){
      return(type)=> BlocProvider<SubjectListBloc>(bloc:SubjectListBloc(type,userDataStore,SubjectService(userDataStore)) , child: Subjects());
    });

    container.registerDependency<AddStudentFactory>((){
      return(studentList)=> BlocProvider<AddStudentBloc>(bloc:AddStudentBloc(userDataStore,SubjectService(userDataStore),studentList) , child: AddStudent());
    });
    container.registerDependency<AddFacultyFactory>((){
      return(faculityList)=> BlocProvider<AddFacultyBloc>(bloc:AddFacultyBloc(userDataStore,SubjectService(userDataStore),faculityList) , child: AddFaculty());
    });
  }

}


