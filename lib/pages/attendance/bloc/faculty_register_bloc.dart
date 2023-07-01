

import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import '../../../app/arch/bloc_provider.dart';
import '../../../common/widgets/bottom_sheet/calende_bottom_sheet.dart';
import '../../../common/widgets/bottom_sheet/validate_date_bottom_sheet.dart';
import '../../../manager/user_data_store/user_data_store.dart';
import '../../../model/faculty/faculty_list_data.dart';
import '../../../model/login/login_response.dart';
import '../../../repositories/menu_list/subject_api.dart';
import '../../../utilities/constants.dart';

typedef BlocProvider<FacultyRegisterBloc> FacultyRegisterFactory(String? facultyID,String name);

class FacultyRegisterBloc extends BlocBase {
  String? facultyID;
  String? name;
  SubjectService? subjectService;
  UserDataStore? _userDataStore;
  final BehaviorSubject<String> _errorMsg=BehaviorSubject.seeded("");
  final BehaviorSubject<String> _facultyName=BehaviorSubject.seeded("");
  final BehaviorSubject<bool> _isLoading=BehaviorSubject.seeded(true);
  final BehaviorSubject<String> _startDate=BehaviorSubject.seeded(DateFormat('yyyy-MM-dd').format(new DateTime.now()));
  final BehaviorSubject<String> _endDate=BehaviorSubject.seeded(DateFormat('yyyy-MM-dd').format(new DateTime.now()));
  final PublishSubject<List<FacultyAttendanceHistory>> _facultyHistory=PublishSubject();
  Stream<List<FacultyAttendanceHistory>> get facultyHistory => _facultyHistory;
  final BehaviorSubject<String> _roleId=BehaviorSubject.seeded("");
  Stream<String> get roleId => _roleId;
  Stream<String> get facultyName => _facultyName;
  Sink<String> get addRoleId => _roleId;
  Stream<String> get startDateStream => _startDate;
  Sink<String> get addStartDate => _startDate;
  Stream<String> get endDateStream => _endDate;
  Sink<String> get addEndDate => _endDate;
  Stream<bool> get isLoading => _isLoading;
  String? startDate=new DateFormat('yyyy-MM-dd').format(new DateTime.now());
  String? endDate=new DateFormat('yyyy-MM-dd').format(new DateTime.now());

  FacultyRegisterBloc(this.facultyID,this.name,this._userDataStore,this.subjectService){
    _facultyName.add(name!);
  }


  void getFacultyAttendance() async{
    _isLoading.add(true);
    UserDetails? userDetails=await  _userDataStore?.getUser();
    String userId=userDetails!.usersid!;
    Map<String,dynamic> map={};
    map.addAll({
      'start_date': startDate,
      'action': 'get-faulty-attendance-history',
      'usersid': userId,
      'faculty_id':facultyID,
      'end_date': endDate,
    });

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