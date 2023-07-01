import 'package:publicschool_app/pages/leaves/leave_request.dart';
import 'package:publicschool_app/repositories/menu_list/subject_api.dart';

import '../app/arch/bloc_provider.dart';

import '../pages/leaves/bloc/leave_management_bloc.dart';
import '../pages/leaves/bloc/leave_request_bloc.dart';
import '../pages/leaves/leave_management.dart';
import 'app_injector.dart';

extension LeaveManagementList on AppInjector {

  //LeaveManagementFactory get leaveManagement => container.get();
  BlocProvider<LeaveManagementBloc> get leaveManagement => container.get<BlocProvider<LeaveManagementBloc>>();

  //LeaveRequestFactory get leaveRequest => container.get();
  BlocProvider<LeaveRequestBloc> get leaveRequest => container.get<BlocProvider<LeaveRequestBloc>>();

  registerLeaveManagement() {
    container.registerDependency<BlocProvider<LeaveManagementBloc>>(() {
      return
          BlocProvider<LeaveManagementBloc>(bloc: LeaveManagementBloc(
              "", userDataStore, SubjectService(userDataStore)),
              child: LeaveManagement());
    });
  }

  registerLeaveRequest() {
    container.registerDependency<BlocProvider<LeaveRequestBloc>>(() {
      return
          BlocProvider<LeaveRequestBloc>(bloc: LeaveRequestBloc(
              "", userDataStore, SubjectService(userDataStore)),
              child: LeaveRequest());
    });
  }
}