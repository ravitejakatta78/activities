import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:publicschool_app/common/bloc/info_bloc.dart';
import 'package:publicschool_app/helper/logger/logger.dart';
import 'package:publicschool_app/model/leave/leaves_list.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

import '../../../app/arch/bloc_provider.dart';
import '../../../common/widgets/container_widget/container_widget.dart';
import '../../../common/widgets/toast/toast.dart';
import '../../../manager/user_data_store/user_data_store.dart';
import '../../../model/login/login_response.dart';
import '../../../repositories/menu_list/subject_api.dart';
import '../../../utilities/fonts.dart';
import '../../../utilities/ps_colors.dart';

class LeaveManagementBloc extends InfoBloc {
  String? type;
  SubjectService? subjectService;
  UserDataStore? _userDataStore;
  final BehaviorSubject<String> _errorMsg=BehaviorSubject.seeded("");
  final BehaviorSubject<bool> _isAdmin=BehaviorSubject.seeded(true);
  final PublishSubject<List<LeavesList>> _leavesList=PublishSubject();
  final BehaviorSubject<Tuple2<bool,List<ContainerWithWidget>>> _content=BehaviorSubject();
  Stream<Tuple2<bool,List<ContainerWithWidget>>> get onListUpdate => _content;
  Stream<List<LeavesList>> get leavesList => _leavesList;
  Stream<bool> get isAdmin=> _isAdmin;
  Sink<bool> get addIsAdmin=> _isAdmin;
  LeaveManagementBloc(this.type,this._userDataStore,this.subjectService):super(subjectService,_userDataStore,type,null);

 void getLeavesList(String userId,String roleId) async{
   addLoading.add(true);
   subjectService?.getLeaveList({'usersid':userId,'action':'get-faculty-leaves-history'})
       .then((value) {
     addLoading.add(false);
     if(value.error==null){
       if(value.data!.status=="200"){
         if(value.data!.data!=null){
           if(value.data!.data!.isNotEmpty){
             _content.add(Tuple2(false,(value.data!.data!.map((e) => LeaveListContainer(leave: e,userId: roleId,onCallBack:(type,leave){

               showDialog(context: Get.context!, builder: (BuildContext context){
                 return  AlertDialog(
                   title: Text("Are you sure want to ${type==2?"Accepted":"Decline"} ?" ,style: TextStyle(fontSize: 14,fontFamily: WorkSans.semiBold,color: PSColors.text_black_color),),
                   actions: [

                     ElevatedButton(
                       style: ButtonStyle(
                           foregroundColor: MaterialStateProperty.all<Color>(PSColors.app_color),
                           backgroundColor: MaterialStateProperty.all<Color>(PSColors.app_color),
                           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                               RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(14.0),
                                   side: BorderSide(color: PSColors.app_color))
                           )
                       ),
                       child:Text('Yes',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color:Colors.white ),),
                       onPressed: () async{
                        subjectService?.addData({'leave_request_id':leave!.leaveRequestId.toString(),
                          'action':'decision-on-leave-request','usersid':userId,'leave_status':type,'leave_comments':type==2?"Accepted":"Decline"})
                            .then((value){
                          if(value.data!.status=="200") {
                            printLog("message",value.data!.message!);
                            // Navigator.pop(Get.context!);
                            ScaffoldMessenger.of(Get.context!).showSnackBar(
                              SnackBar(
                                content:  Text(value.data!.message!),
                              ),
                            );
                            Navigator.pop(context);
                            getLeavesList(userId,roleId);
                          }else ToastMessage(value.data!.message!);
                        });

                       },
                     ),
                     const SizedBox(width: 10,),
                     ElevatedButton(
                       style: ButtonStyle(
                           foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                           backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                               RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(14.0),
                                   side:BorderSide(color: PSColors.app_color))
                           )
                       ),
                       child:  Text('No',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color:PSColors.app_color ),),

                       onPressed: () {

                         Navigator.pop(context);
                       },
                     )


                   ],
                 );
               });


               printLog("callback Type", type);
               printLog("callback value", leave!.leaveRequestId);
             }))).toList() ));
           }
         }

       } else _errorMsg.add('Invalid');
     }else _errorMsg.add('Invalid');


   }
   );

  }

}