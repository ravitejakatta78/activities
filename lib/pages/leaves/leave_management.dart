import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:publicschool_app/app/arch/bloc_provider.dart';
import 'package:publicschool_app/common/widgets/load_container/load_container.dart';
import 'package:publicschool_app/di/i_leave_management.dart';
import 'package:publicschool_app/pages/leaves/leave_request.dart';
import 'package:publicschool_app/utilities/constants.dart';

import '../../common/widgets/listview_widget/listview_widget.dart';
import '../../di/app_injector.dart';
import '../../helper/logger/logger.dart';
import '../../model/login/login_response.dart';
import '../../utilities/fonts.dart';
import '../../utilities/ps_colors.dart';
import 'bloc/leave_management_bloc.dart';


class LeaveManagement extends StatefulWidget {

  @override
  LeaveManagementState  createState() => LeaveManagementState();

}
class LeaveManagementState extends State<LeaveManagement>{
  String? roleId;
  LeaveManagementBloc? _bloc;
  UserDetails? userDetails;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc=BlocProvider.of(context);
    getUser();
  }
  getUser() async{
     userDetails=await  AppInjector.instance.userDataStore.getUser();
    printLog("userDetails", userDetails?.roleId);
    roleId=userDetails?.roleId;
    if(roleId==Constants.school)
      _bloc?.addIsAdmin.add(true);
    else _bloc?.addIsAdmin.add(false);

    _bloc?.getLeavesList(userDetails!.usersid!,roleId!);
  }
  @override
  Widget build(BuildContext context) {
    return LoaderContainer(
      stream: _bloc?.isLoading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: PSColors.app_color,
          centerTitle: true,
          title: const Text('Leaves History',style:TextStyle(fontFamily: WorkSans.semiBold,fontSize: 20)),
        ),
      body: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(8.0),
        child: ListviewWidget(
          onListUpdate: _bloc?.onListUpdate,

        ),
      ),
        floatingActionButton:StreamBuilder<bool>(
          initialData: true,
        stream: _bloc!.isAdmin,
    builder: (b,s){
          return (s.data!=true)?DraggableFab(child: FloatingActionButton(

          child: Icon(Icons.add,color:Colors.white,),

      backgroundColor: PSColors.app_color,
      foregroundColor: Colors.green,
      onPressed: () {

      Get.to(AppInjector.instance.leaveRequest)!.then((value) {
        _bloc?.getLeavesList(userDetails!.usersid!,roleId!);
      });
      },
      )):SizedBox();

    })






      ),
    );


  }

}