


import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:intl/intl.dart';
import 'package:publicschool_app/common/bloc/info_bloc.dart';
import 'package:publicschool_app/model/leave/leaves_list.dart';
import 'package:publicschool_app/model/subject/subject_list_data.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

import '../../../app/arch/bloc_provider.dart';
import '../../../common/widgets/bottom_sheet/calende_bottom_sheet.dart';
import '../../../common/widgets/container_widget/container_widget.dart';
import '../../../common/widgets/toast/toast.dart';
import '../../../helper/logger/logger.dart';
import '../../../manager/user_data_store/user_data_store.dart';
import '../../../model/base_response/request_response.dart';
import '../../../model/login/login_response.dart';
import '../../../repositories/menu_list/subject_api.dart';


class LeaveRequestBloc extends InfoBloc {
  String? type;
  SubjectService? subjectService;
  UserDataStore? _userDataStore;
  final BehaviorSubject<String> _errorMsg=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _leaveType=BehaviorSubject.seeded("");
  final BehaviorSubject<int> _leaveSection=BehaviorSubject.seeded(0);
  final BehaviorSubject<String> _reason=BehaviorSubject.seeded("");

  BehaviorSubject<bool> _requestValid =BehaviorSubject.seeded(false);
  PublishSubject<void> _request_submit = PublishSubject();
  PublishSubject<Map<String,dynamic>> _submitRequest = PublishSubject();
  Sink<Map<String,dynamic>> get submitRequest=> _submitRequest;
  Sink<void> get request_submit=> _request_submit;


  Stream<String> get reason => _reason;
  Sink<String> get addReason => _reason;
  Stream<String> get leaveType => _leaveType;
  Sink<String> get addLeaveType => _leaveType;
  Stream<int> get leaveSection => _leaveSection;
  Sink<int> get addLeaveSection => _leaveSection;

  String userId="";
  Map<String,dynamic> paramsData={};
  LeaveRequestBloc(this.type,this._userDataStore,this.subjectService):super(subjectService,_userDataStore,type,null){

    setListeners();
  }
   setListeners() async {
    UserDetails? userDetails=await  _userDataStore?.getUser();
    userId=userDetails!.usersid!;

    CombineLatestStream.combine5(_leaveType, startDateStream, endDateStream, _reason, _leaveSection,  (String a, String b, String c, String d, int e ) => a.isNotEmpty && b.isNotEmpty && c.isNotEmpty && d.isNotEmpty && e!=-1)
        .listen(_requestValid.add)
         .addTo(disposeBag);

    _request_submit.withLatestFrom(_requestValid,(_, bool v) {
      if(v!=true) printLog('error','Enter Details');
      addLoading.add(false);
      return v;
    }).where((event) => event).withLatestFrom5(_leaveType, startDateStream, endDateStream, _reason, _leaveSection,
        (t, String a, String b, String c, String d, int e) => {'action':'add-faculty-leave-request','usersid':userId,"leave_type":(a=='Annual Leave')?'1':(a=='Sick Leave')?'2':'3',
          'leave_reason':d,'start_date':b,'end_date':c,'leave_range':(e==1)?2:1
        }
        ).listen(_submitRequest.add).addTo(disposeBag);

    _submitRequest.
    doOnData((_)=> addLoading.add(true))
        .map(subjectService!.addData)
        .listen((event) {
      addLoading.add(false);
      _handleAuthResponse(event);
    })
        .addTo(disposeBag);

  }



  submit(){
    addLoading.add(true);
    request_submit.add(null);

  }

  int daysBetwwenDates(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();

  }


  _handleAuthResponse(Future<RequestResponse<SubjectListData>> result) {
    result
        .asStream()
        .where((r) => r.error == null)
        .map((r) => r.data)
        .listen((u) async {
      if (u != null){
        if(u.status=="200") {
          printLog("message",u.message!);
           Navigator.pop(Get.context!);
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(
              content:  Text(u.message!),
            ),
          );

        }else ToastMessage(u.message!);
      }

    }).addTo(disposeBag);

    _handleError(result);
  }

  _handleError(Future<RequestResponse> result) {
    result
        .asStream()
        .where((r) => r.error != null)
        .map((r) => r.error)
        .doOnData((_) => addLoading.add(false))
        .listen((e) {
      if (e != null){
        printLog("data", e.statusCode);
        //if(e.statusCode!=401)
      }
    }).addTo(disposeBag);


  }

}
