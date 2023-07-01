
import 'package:publicschool_app/di/i_faculity_attendance.dart';
import 'package:publicschool_app/di/i_leave_management.dart';
import 'package:publicschool_app/di/i_stuAttendace.dart';
import 'package:publicschool_app/di/i_student_dairy.dart';
import 'package:publicschool_app/di/i_student_exams.dart';
import 'package:publicschool_app/di/i_student_fees.dart';
import 'package:publicschool_app/di/i_subject_list.dart';
import 'package:publicschool_app/di/i_time_table.dart';
import 'package:publicschool_app/repositories/dashboard/dashboard_api.dart';
import 'package:publicschool_app/repositories/menu_list/subject_api.dart';
import '../app/arch/bloc_provider.dart';
import '../pages/home/bloc/dashboard_bloc.dart';
import '../pages/home/dash_board.dart';
import '../pages/home/profile/bloc/user_profile_bloc.dart';
import '../pages/home/profile/widget/user_profile.dart';
import 'app_injector.dart';

extension DashboardExtension on AppInjector{

 DashboardFactory get dashboard => container.get();
 UserProfileFactory get profile => container.get();

 registerDashboard(){

    container.registerDependency<DashboardFactory>((){
      return()=> BlocProvider<DashboardBloc>(bloc: DashboardBloc(userDataStore,DashboardService(userDataStore)), child: const Dashboard());
    });

    registerSubjectList();
    registerStuAttendance();
    registerFacultyAttendance();
    registerStudentExams();
    registerAddStudentExams();
    registerLeaveManagement();
    registerLeaveRequest();
    registerFacultyRegister();
    registerTimeTablePage();
    registerAddTimeTablePage();
    registerStudentDairyPage();
    registerAddStudentDairyPage();
    registerExamDetails();
    registerExamsScheduleList();
    registerStudentFeesPage();
    registerAddStudentFeesPage();

    container.registerDependency<UserProfileFactory>((){
      return()=> BlocProvider<UserProfileBloc>(bloc: UserProfileBloc(userDataStore,SubjectService(userDataStore)), child:  UserProfile());
    });

 }

}
