import 'package:publicschool_app/app/arch/bloc_provider.dart';
import 'package:publicschool_app/helper/logger/logger.dart';
import 'package:publicschool_app/manager/user_data_store/user_data_store.dart';
import 'package:publicschool_app/model/dashboard/dashboard_data.dart';
import 'package:publicschool_app/model/dashboard/dashboard_response.dart';
import 'package:publicschool_app/model/login/login_response.dart';
import 'package:publicschool_app/pages/home/side_menu.dart';
import 'package:publicschool_app/repositories/dashboard/dashboard_api.dart';
import 'package:rxdart/rxdart.dart';

typedef BlocProvider<DashboardBloc> DashboardFactory();
 class DashboardBloc extends BlocBase{
  final PublishSubject<UserDetails> _userDetails=PublishSubject();
  final BehaviorSubject<DashboardResponse> _dashboardResponse=BehaviorSubject();
  final BehaviorSubject<String> _errorMsg=BehaviorSubject.seeded("");
  final BehaviorSubject<bool> _isLoading=BehaviorSubject.seeded(false);
  final BehaviorSubject<bool> _isVisible=BehaviorSubject.seeded(false);
  final BehaviorSubject<String> _calenderDate=BehaviorSubject.seeded("");

  Stream<String> get calenderDate => _calenderDate;
  Stream<bool> get isVisible => _isVisible;
  Stream<String> get errorMsg => _errorMsg;
  Stream<bool> get isLoading => _isLoading;
  Stream<UserDetails> get userDetails =>_userDetails;
  Stream<DashboardResponse> get dashboardResponse =>_dashboardResponse;
  Sink<String> get currentDate => _calenderDate;

  Sink<bool> get imageVisible => _isVisible;
  UserDataStore? _userDataStore;
  DashboardService? dashboardService;

  DashboardBloc(this._userDataStore,this.dashboardService){
    setListner();

  }

  Future<void> setListner() async {



  }
  dispose() {

    imageVisible.close();
  }


  getUser() async{
    UserDetails? userDetails=await  _userDataStore?.getUser();
    printLog("userDetails", userDetails?.userName);
    _userDetails.add(userDetails!);
  }
  getMenu() async{
    _isLoading.add(true);
    UserDetails? userDetails=await  _userDataStore?.getUser();

    dashboardService!.dashboard({'action':'dashboard','usersid':userDetails!.usersid,'roleid':userDetails.roleId}).
    then((value) {
      _isLoading.add(false);
      if(value.error==null){
        if(value.data!.status=="1"){
          printLog("menu", value.data!);
          _dashboardResponse.add(value.data!);
        } else _errorMsg.add('Invalid');
      }else _errorMsg.add('Invalid');

    });
  }



}