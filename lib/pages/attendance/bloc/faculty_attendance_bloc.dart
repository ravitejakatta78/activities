
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:publicschool_app/model/subject/faculity_list.dart';
import 'package:rxdart/rxdart.dart';

import '../../../app/arch/bloc_provider.dart';
import '../../../common/widgets/bottom_sheet/calende_bottom_sheet.dart';
import '../../../common/widgets/bottom_sheet/validate_date_bottom_sheet.dart';
import '../../../helper/logger/logger.dart';
import '../../../manager/user_data_store/user_data_store.dart';
import '../../../model/dashboard/dashboard_data.dart';
import '../../../model/faculty/faculty_list_data.dart';
import '../../../model/login/login_response.dart';
import '../../../repositories/menu_list/subject_api.dart';
import '../../../utilities/constants.dart';

typedef BlocProvider<FacultyAttendanceBloc> FacultyAttendanceFactory(String type);

class FacultyAttendanceBloc extends BlocBase {

  String type;
  SubjectService? subjectService;
  UserDataStore? _userDataStore;
  final BehaviorSubject<String> _errorMsg=BehaviorSubject.seeded("");
  final BehaviorSubject<bool> _isLoading=BehaviorSubject.seeded(true);
  final BehaviorSubject<String> _startDate=BehaviorSubject.seeded(new DateFormat('yyyy-MM-dd').format(new DateTime.now()));
  final BehaviorSubject<String> _endDate=BehaviorSubject.seeded(new DateFormat('yyyy-MM-dd').format(new DateTime.now()));
  final PublishSubject<List<FaculityList>> _facultyList=PublishSubject();
  final PublishSubject<List<FacultyAttendanceHistory>> _facultyHistory=PublishSubject();
  Stream<List<FacultyAttendanceHistory>> get facultyHistory => _facultyHistory;
  final BehaviorSubject<String> _roleId=BehaviorSubject.seeded("");
  Stream<String> get roleId => _roleId;
  Sink<String> get addRoleId => _roleId;
  Stream<String> get startDateStream => _startDate;
  Sink<String> get addStartDate => _startDate;

  Stream<String> get endDateStream => _endDate;
  Sink<String> get addEndDate => _endDate;
  Stream<List<FaculityList>> get facultyList => _facultyList;
  Stream<bool> get isLoading => _isLoading;
  String? startDate=new DateFormat('yyyy-MM-dd').format(new DateTime.now());
  String? endDate=new DateFormat('yyyy-MM-dd').format(new DateTime.now());

  FacultyAttendanceBloc(this.type,this._userDataStore,this.subjectService);

  void getFaculityList(String type) async {
    UserDetails? userDetails=await  _userDataStore?.getUser();
    String userId=userDetails!.usersid!;

    subjectService!.subjectList(DashboardData(type, userId)).then((value) {
      _isLoading.add(false);
      if(value.error==null){
        if(value.data!.status=="200"){
          if(value.data!.faculityList!=null){
            if(value.data!.faculityList!.isNotEmpty){

              _facultyList.add(value.data!.faculityList!);

            }

          }

        } else _errorMsg.add('Invalid');
      }else _errorMsg.add('Invalid');
    });


  }

  void addFacultyAttendance(String type) async{

    UserDetails? userDetails=await  _userDataStore?.getUser();
    String userId=userDetails!.usersid!;
    String? startDate=DateFormat('yyyy-MM-dd').format(DateTime.now());
    String? startDateTime= DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    subjectService!.addData({'attendance_date':startDate,'action':'add-faculty-attendance','usersid':userId,type:startDateTime}).then((value) {
      if(value.data!.status=="200") {
        printLog("message", value.data!.message!);
        // Navigator.pop(Get.context!);
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text(value.data!.message!),
          ),
        );
        getFacultyAttendance();
      }
    });
  }


  void getFacultyAttendance() async{
    _isLoading.add(true);
      UserDetails? userDetails=await  _userDataStore?.getUser();
      String userId=userDetails!.usersid!;
     // String? startDate=DateFormat('yyyy-MM-dd').format(DateTime.now());
      Map<String,dynamic> map={};
      if(userDetails.roleId==Constants.school) {
        map.addAll({
          'start_date': startDate,
          'action': 'get-faulty-attendance-history',
          'usersid': userId,
          'end_date': endDate,
        });
      } else if(userDetails.roleId==Constants.faculty) {
        map.addAll({
          'start_date': startDate,
          'action': 'get-faulty-attendance-history',
          'usersid': userId,
        });
      }

      subjectService!.getAttendanceData(map).then((value) {
        _isLoading.add(false);
        if(value.data!.status=="200") {
          if(value.data!.data!=null){
            if(value.data!.data!.isNotEmpty){
              _facultyHistory.add(value.data!.data!);
            }
          }

        }
      });




  }

  getStartDate(){
    calenderBottomSheet(onCallback: (dateTime){
      startDate=dateTime.toString();
      addStartDate.add(startDate!);
    },selectedDate:DateTime.parse(startDate!),type:1 );

  }
  getEndDate(){
    endDate=startDate;
    ValidateDateBottomSheet(onCallback: (dateTime){
      endDate=dateTime.toString();
      addEndDate.add(endDate!);
    },selectedDate:DateTime.parse(startDate!) );

  }

}



