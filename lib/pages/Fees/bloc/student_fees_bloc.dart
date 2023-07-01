import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:publicschool_app/common/bloc/info_bloc.dart';
import 'package:publicschool_app/di/i_student_fees.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

import '../../../app/arch/bloc_provider.dart';
import '../../../common/widgets/container_widget/container_widget.dart';
import '../../../di/app_injector.dart';
import '../../../helper/logger/logger.dart';
import '../../../manager/user_data_store/user_data_store.dart';
import '../../../model/base_response/request_response.dart';
import '../../../model/fees/fees_list.dart';
import '../../../model/login/login_response.dart';
import '../../../repositories/menu_list/subject_api.dart';


class StudentFeesBloc extends InfoBloc {
  String? type;
  SubjectService? subjectService;
  UserDataStore? _userDataStore;
  PublishSubject<void> _get_fees = PublishSubject();
  PublishSubject<Map<String,dynamic>> _getFees = PublishSubject();
  final BehaviorSubject<List<Fees>> _feesList=BehaviorSubject.seeded([]);
  final BehaviorSubject<Tuple2<bool,List<ContainerWithWidget>>> _content=BehaviorSubject();
  Stream<Tuple2<bool,List<ContainerWithWidget>>> get onListUpdate => _content;
  BehaviorSubject<bool> _valid =BehaviorSubject.seeded(false);
  Stream<bool> get valid  => _valid;
  Stream<List<Fees>> get feesList => _feesList;
  Sink<void>  get get_fees=> _get_fees;
  Sink<Map<String,dynamic>> get getFees => _getFees;

  StudentFeesBloc(this.type,this.subjectService,this._userDataStore):super(subjectService,_userDataStore,type,null){
    setListener();
    getStudents();

  }

  void setListener() async {
    UserDetails? userDetails=await  _userDataStore?.getUser();
    userId=userDetails!.usersid!;
    addEndDate.add(endDate!);
    addStartDate.add(startDate!);

    CombineLatestStream.combine5(getClassId, getSectionId, startDateStream, endDateStream, getStudentId, (String a, String b, String c, String d, String e) => (a.isNotEmpty  && c.isNotEmpty&& d.isNotEmpty) )
        .listen(_valid.add)
        .addTo(disposeBag);
    _get_fees
        .withLatestFrom(_valid, (_, bool v){
      printLog("title", "onPressed");
      printLog("_valid", _valid.value);
      // if(v!=true) ToastMessage('Enter Details');
      return v;
    }).where((event) => event).withLatestFrom5(getClassId, getSectionId, startDateStream,endDateStream,getStudentId,
            (t, String a,String b,String c,String d,String e) =>
        { 'action': 'get-students-fee','classId':a,'startDate':c,'endDate':d,'usersid':userId,'sectionId':b,'studentId':e})
        .listen(_getFees.add)
        .addTo(disposeBag);

    _getFees.doOnData((_)=> addLoading.add(true))
        .map(subjectService!.getFeesList)
        .listen((event) {
      addLoading.add(false);
      event
          .asStream()
          .where((r) => r.error == null)
          .map((r) => r.data)
          .listen((u) async {
         _handleAuthResponse(event);

      }).addTo(disposeBag);

    })
        .addTo(disposeBag);



  }
  _handleAuthResponse(Future<RequestResponse<FeesList>> result) {
    result
        .asStream()
        .where((r) => r.error == null)
        .map((r) => r.data)
        .listen((u) async {
      if (u != null){
        if(u.status==1||u.status==200) {
          if(u.data!=null){
            _feesList.add(u.data!);
            if(u.data!.isNotEmpty){

              _content.add(Tuple2(true,u.data!.map((e) => FeesContainer(feesList: e,userId: '',onCallBack: (pos,data){
                if(pos==2){
                  deleteItem(data);

                }
              })).toList()));
            }
          }
        }else {
        }
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

  void deleteItem(Fees? fees) {
    subjectService!.addData({'usersid':userId,'action':'delete-student-fee','feeId':fees!.feeId}).then((value) {
      if (value.data!.status == "200") {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text(value.data!.message!),
          ),
        );
        get_fees.add(null);
      }
    });

  }






}