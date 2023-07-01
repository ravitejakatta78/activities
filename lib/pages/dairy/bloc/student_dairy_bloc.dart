import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:publicschool_app/common/bloc/info_bloc.dart';
import 'package:publicschool_app/di/app_injector.dart';
import 'package:publicschool_app/di/i_student_dairy.dart';
import 'package:publicschool_app/model/dairy/dairy_list.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';
import '../../../common/widgets/container_widget/container_widget.dart';
import '../../../helper/logger/logger.dart';
import '../../../manager/user_data_store/user_data_store.dart';
import '../../../model/base_response/request_response.dart';
import '../../../model/login/login_response.dart';
import '../../../repositories/menu_list/subject_api.dart';


class StudentDairyBloc extends InfoBloc {
  String? type;
  SubjectService? subjectService;
  UserDataStore? _userDataStore;

  PublishSubject<void> _get_dairy = PublishSubject();
  PublishSubject<Map<String,dynamic>> _getDairy = PublishSubject();
  final BehaviorSubject<List<Dairy>> _dairyList=BehaviorSubject.seeded([]);
  final BehaviorSubject<Tuple2<bool,List<ContainerWithWidget>>> _content=BehaviorSubject();
  Stream<Tuple2<bool,List<ContainerWithWidget>>> get onListUpdate => _content;
  BehaviorSubject<bool> _valid =BehaviorSubject.seeded(false);
  final BehaviorSubject<bool> _isFaculty=BehaviorSubject.seeded(true);

  Stream<bool> get isFaculty=> _isFaculty;
  Sink<bool> get addIsFaculty=> _isFaculty;
  Stream<bool> get valid  => _valid;
  Stream<List<Dairy>> get dairyList => _dairyList;
  Sink<void>  get get_dairy=> _get_dairy;
  Sink<Map<String,dynamic>> get getDairy => _getDairy;

  String? schoolId ="";
 
  StudentDairyBloc(this.type,this.subjectService,this._userDataStore):super(subjectService,_userDataStore,type,null){
    setListener();
  }
  void setListener() async {

    UserDetails? userDetails=await  _userDataStore?.getUser();
    userId=userDetails!.usersid!;
    schoolId=userDetails.schoolId;
    addEndDate.add(endDate!);
    addStartDate.add(startDate!);

    CombineLatestStream.combine4(getClassId, getSectionId, startDateStream,endDateStream, (String a, String b, String c,String d) =>(a.isNotEmpty  && c.isNotEmpty&& d.isNotEmpty)  )
        .listen(_valid.add)
        .addTo(disposeBag);

    _get_dairy
        .withLatestFrom(_valid, (_, bool v){
      printLog("title", "onPressed");
      printLog("_valid", _valid.value);
      // if(v!=true) ToastMessage('Enter Details');
      return v;
    }).where((event) => event).withLatestFrom4(getClassId, getSectionId, startDateStream,endDateStream,
            (t, String a,String b,String c,String d) =>
        { 'action': 'get-student-dairy','class_id':a,'start_date':c,'end_date':d,'usersid':userId,'section_id':b})
        .listen(_getDairy.add)
        .addTo(disposeBag);

    _getDairy.doOnData((_)=> addLoading.add(true))
        .map(subjectService!.getDairy)
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
  _handleAuthResponse(Future<RequestResponse<DairyList>> result) {

    result
        .asStream()
        .where((r) => r.error == null)
        .map((r) => r.data)
        .listen((u) async {
      if (u != null){
        if(u.status=="1"||u.status=="200") {
          if(u.data!=null){
            _dairyList.add(u.data!);
            if(u.data!.isNotEmpty){
               List<String> listDates=[];
               u.data!.map((e)=>listDates.add(e.dairyDate!)).toList();
              _content.add(Tuple2(false,(listDates.toSet().map((e) => DairyContainer(
                  stringDate:e,
                  userId: userId,
                  dairyList:u.data!, onCallBack: ( type, dairy){
                if(type==1){
                  Get.to(AppInjector.instance.addStudentDairyPage("",dairy))!.then((value) => _get_dairy.add(null));
                }else if(type==2){
                    deleteItem(dairy);
                }
              }))).toList()));
            }
          }
        }else {
          printLog('message',u.message!);
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

  void deleteItem(Dairy? dairy) {

    subjectService!.addData({'usersid':userId,'action':'delete-student-dairy','dairy_id':dairy!.id}).then((value) {
      if (value.data!.status == "200") {
        printLog("message", value.data!.message!);
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text(value.data!.message!),
          ),
        );
        get_dairy.add(null);
      }
    });

  }

}
