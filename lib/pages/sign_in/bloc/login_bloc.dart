import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:publicschool_app/app/arch/bloc_provider.dart';
import 'package:publicschool_app/common/widgets/validators/validators.dart';
import 'package:publicschool_app/di/app_injector.dart';
import 'package:publicschool_app/di/i_register_dashboard.dart';
import 'package:publicschool_app/helper/logger/logger.dart';
import 'package:publicschool_app/manager/user_data_store/user_data_store.dart';
import 'package:publicschool_app/model/login/login_data.dart';
import 'package:publicschool_app/model/login/login_response.dart';
import 'package:publicschool_app/repositories/login/login_api.dart';
import 'package:rxdart/rxdart.dart';
import 'package:toast/toast.dart';

import '../../../common/widgets/toast/toast.dart';
import '../../../model/base_response/request_response.dart';

typedef BlocProvider<LoginBloc> LoginFactory();

class LoginBloc extends BlocBase{
    LoginService? loginService;
    UserDataStore? userDataStore;
    BehaviorSubject<String> _userName =BehaviorSubject.seeded("");
    BehaviorSubject<String> _password =BehaviorSubject.seeded("");
    BehaviorSubject<bool> _valid =BehaviorSubject.seeded(false);
    PublishSubject<void> _login = PublishSubject();
    PublishSubject<LoginData> _submitLogin = PublishSubject();
    BehaviorSubject<bool> _isLoading =BehaviorSubject.seeded(false);
    Sink<String> get  userName=> _userName;
    Sink<String> get  password=> _password;
    Stream<bool> get  valid=> _valid;
    Sink<void>  get login=> _login;
    Sink<LoginData> get submitLogin=> _submitLogin;
    Stream<bool> get isLoading=> _isLoading;
    BehaviorSubject<String?> _emailValidation = BehaviorSubject<String>();
    Stream<String?> get emailValidation => _emailValidation;

    LoginBloc(this.loginService,this.userDataStore){
      setListeners();
    }
     setListeners() {

      CombineLatestStream.combine2(_userName, _password,
              (String a, String b) => a.isNotEmpty && b.isNotEmpty)
          .listen(_valid.add)
          .addTo(disposeBag);

      _login
          .withLatestFrom(_valid, (_, bool v) {
              if(v!=true) ToastMessage('Enter Details');
            return v;

          })
          .where((event) => event)
          .withLatestFrom2(_userName, _password, (t, String a, String b) => LoginData(a, b,'login'))
          .listen(_submitLogin.add)
          .addTo(disposeBag);

      _submitLogin.
       doOnData((_)=> _isLoading.add(true))
      .map(loginService!.login)
      .listen((event) {

        _handleAuthResponse(event);
      })
      .addTo(disposeBag);

    }
    _handleAuthResponse(Future<RequestResponse<LoginResponse>> result) {
      result
          .asStream()
          .where((r) => r.error == null)
          .map((r) => r.data)
          .listen((u) async {
        _isLoading.add(false);
        if (u != null){
          if(u.status=="200") {
            await userDataStore?.insert(u.userDetails!);
             Get.offAll(AppInjector.instance.dashboard);
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
          .doOnData((_) => _isLoading.add(false))
          .listen((e) {
        if (e != null){
          printLog("data", e.statusCode);
          //if(e.statusCode!=401)
        }
      }).addTo(disposeBag);


    }

}

