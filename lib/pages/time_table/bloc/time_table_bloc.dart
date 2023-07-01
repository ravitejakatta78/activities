
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:publicschool_app/di/app_injector.dart';
import 'package:publicschool_app/di/i_time_table.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

import '../../../app/arch/bloc_provider.dart';
import '../../../common/widgets/bottom_sheet/classes_bottom_sheet.dart';
import '../../../common/widgets/bottom_sheet/sections_bottom_sheet.dart';
import '../../../common/widgets/container_widget/container_widget.dart';
import '../../../common/widgets/toast/toast.dart';
import '../../../helper/logger/logger.dart';
import '../../../manager/user_data_store/user_data_store.dart';
import '../../../model/base_response/request_response.dart';
import '../../../model/login/login_response.dart';
import '../../../model/subject/subject_list_data.dart';
import '../../../model/time_table/get_time_table.dart';
import '../../../repositories/menu_list/subject_api.dart';

typedef BlocProvider<TimeTableBloc> TimeTableBlocFactory(String? type);

class TimeTableBloc extends BlocBase {

  String? type;
  SubjectService? subjectService;
  UserDataStore? _userDataStore;

  final BehaviorSubject<String> _errorMsg=BehaviorSubject.seeded("");
  final BehaviorSubject<bool> _isLoading=BehaviorSubject.seeded(true);
  final PublishSubject<List<ClassList>> _classList=PublishSubject();
  BehaviorSubject<int> _selectedPosition = BehaviorSubject.seeded(0);
  final BehaviorSubject<Tuple2<bool,List<ContainerWithWidget>>> _content=BehaviorSubject();
  Stream<Tuple2<bool,List<ContainerWithWidget>>> get onListUpdate => _content;
  final BehaviorSubject<String> _classId=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _sectionId=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _dayId=BehaviorSubject.seeded("");
  BehaviorSubject<bool> _valid =BehaviorSubject.seeded(false);
  PublishSubject<void> _get_time_table = PublishSubject();
  PublishSubject<Map<String,dynamic>> _getTimeTable = PublishSubject();
  final BehaviorSubject<List<TimeTable>> _timeTableList=BehaviorSubject.seeded([]);
  BehaviorSubject<int> _daySelectedPosition = BehaviorSubject.seeded(-1);
  final BehaviorSubject<bool> _isFaculty=BehaviorSubject.seeded(true);
  Stream<bool> get isFaculty=> _isFaculty;
  Sink<bool> get addIsFaculty=> _isFaculty;

  Stream<bool> get valid  => _valid;
  Sink<void>  get get_time_table=> _get_time_table;
  Sink<Map<String,dynamic>> get getTimeTable => _getTimeTable;
  Stream<String> get getDayId  => _dayId;
  Sink<String> get addDayId => _dayId;
  Stream<String> get getClassId  => _classId;
  Sink<String> get addClassId => _classId;
  Stream<String> get getSectionId  => _sectionId;
  Sink<String> get addSectionId => _sectionId;
  Stream<int> get selectedPosition  => _selectedPosition;
  Sink<int> get selectedPos => _selectedPosition;
  Stream<int> get daySelectedPosition  => _daySelectedPosition;
  Sink<int> get dayelectedPos => _daySelectedPosition;
  Stream<List<ClassList>> get classList => _classList;
  Stream<List<TimeTable>> get timeTableList => _timeTableList;
  String? userId ="";
  String? schoolId ="";
  String? classId="-1";
  String? section="-1";




  TimeTableBloc(this.type,this._userDataStore,this.subjectService){
    setListener();
  }

  void setListener() async {

    UserDetails? userDetails=await  _userDataStore?.getUser();
    userId=userDetails!.usersid!;
    schoolId=userDetails.schoolId;


    CombineLatestStream.combine2(_classId, _dayId, (String a,  String c) =>(a.isNotEmpty &&  c.isNotEmpty)  )
        .listen(_valid.add)
        .addTo(disposeBag);

    _get_time_table
        .withLatestFrom(_valid, (_, bool v){
      printLog("title", "onPressed");
      printLog("_valid", _valid.value);

     // if(v!=true) ToastMessage('Enter Details');

      return v;
    }).where((event) => event).withLatestFrom2(_classId, _dayId,
            (t, String a,String c) =>
        { 'action': 'get-time-table','class_id':a,'day_id':c,'usersid':userId,})
        .listen(_getTimeTable.add)
        .addTo(disposeBag);

    _getTimeTable.doOnData((_)=> _isLoading.add(true))
        .map(subjectService!.getTimeTable)
        .listen((event) {
      _isLoading.add(false);
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
  _handleAuthResponse(Future<RequestResponse<TimeTableList>> result) {
    List<String> colorList=['#F44336','#E91E63','#9C27B0','#673AB7','#FF6D00','#FFD600','#00C853'];

    result
        .asStream()
        .where((r) => r.error == null)
        .map((r) => r.data)
        .listen((u) async {
      if (u != null){
        if(u.status=="1"||u.status=="200") {
          if(u.data!=null){
            _timeTableList.add(u.data!);
            if(u.data!.isNotEmpty){
              List<ContainerWithWidget> containerWithWidget=[];
              int j=0;
              for(int i=0;i<u.data!.length;i++){
                if(i>colorList.length) {
                  if(j>colorList.length)
                    j=0;
                  else
                  j = j+1;
                }else if(i==colorList.length)
                   j=0;
                else j=i;

                containerWithWidget.add(TimeTableContainer(timeTable: u.data![i],userId: userId,colorData: colorList[j],onCallBack: ( type, timeTable){
                  if(type==1){
                    Get.to(AppInjector.instance.addTimeTablePage(timeTable));
                  }else if(type==2){
                    deleteItem(timeTable);

                  }
                }));


              }
              _content.add(Tuple2(false,containerWithWidget));
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
        .doOnData((_) => _isLoading.add(false))
        .listen((e) {
      if (e != null){
        printLog("data", e.statusCode);
        //if(e.statusCode!=401)
      }
    }).addTo(disposeBag);


  }


  void getClassList(Map<String, String?> map) async {
    UserDetails? userDetails=await  _userDataStore?.getUser();
    String userId=userDetails!.usersid!;
    map.addAll({"usersid":userId});
    subjectService!.getRequest(map).then((value) {
      _isLoading.add(false);
      if(value.error==null){
        if(value.data!.status=="200"){
          if(value.data!.classList!=null){
            if(value.data!.classList!.isNotEmpty){

              openClassBottomSheet(classList:value.data!.classList!,onCallback:(classList) {
                //getUsers({'action':'studentList','class_id':classList.classId,'usersid':userId});
                classId=classList.classId;
                _classId.add(classId.toString());
                printLog("classList", classList.className);
              },selectedPos: int.parse(classId!));
              _classList.add(value.data!.classList!);
              printLog('classList',value.data!.classList);

            }

          }

        } else _errorMsg.add('Invalid');
      }else _errorMsg.add('Invalid');
    });
  }

  void getSections(Map<String, String?> map) async {
    UserDetails? userDetails=await  _userDataStore?.getUser();
    String userId=userDetails!.usersid!;
    map.addAll({"usersid":userId,"class_id":classId});
    subjectService!.getRequest(map).then((value) {
      _isLoading.add(false);
      if(value.error==null){
        if(value.data!.status=="200"){
          if(value.data!.sectionList!=null){
            if(value.data!.sectionList!.isNotEmpty){
              // section=value.data!.sectionList![0].sectionId;
              sectionsBottomSheet(sectionsList:value.data!.sectionList!,onCallback:(sectionData) {
                section=sectionData.sectionId;
                _sectionId.add(section.toString());
                printLog("SectionName", sectionData.sectionName);

              },selectedPos: int.parse(section!));


            }
          }

        } else _errorMsg.add('Invalid');
      }else _errorMsg.add('Invalid');
    });
  }

  void deleteItem(TimeTable? timeTable) {

    subjectService!.addData({'usersid':userId,'action':'delete-time-table','time_table_id':timeTable!.id}).then((value) {
      if (value.data!.status == "200") {
        printLog("message", value.data!.message!);
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text(value.data!.message!),
          ),
        );
        get_time_table.add(null);
      }
    });

  }


}