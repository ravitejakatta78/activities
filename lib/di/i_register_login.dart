
import 'package:publicschool_app/pages/home/profile/bloc/user_profile_bloc.dart';
import 'package:publicschool_app/pages/home/profile/widget/user_profile.dart';
import 'package:publicschool_app/pages/sign_in/bloc/login_bloc.dart';
import 'package:publicschool_app/repositories/login/login_api.dart';
import '../app/arch/bloc_provider.dart';
import '../pages/home/password/bloc/change_password_bloc.dart';
import '../pages/home/password/widget/change_password.dart';
import '../pages/sign_in/login.dart';
import '../repositories/menu_list/subject_api.dart';
import 'app_injector.dart';

extension LoginExtension on AppInjector{

  LoginFactory get login => container.get();
  ChangePasswordFactory get changePassword => container.get();
  UserProfileFactory get userProfile => container.get();

  registerLogin(){

    container.registerDependency<LoginFactory>((){
      return()=> BlocProvider<LoginBloc>(bloc: LoginBloc(LoginService(),userDataStore), child: const MyLogin());
    });
  }
  registerChangePassword(){
    container.registerDependency<ChangePasswordFactory>((){
      return()=> BlocProvider<ChangePasswordBloc>(bloc: ChangePasswordBloc(userDataStore, SubjectService(userDataStore)), child:  ChangePassword());
    });

  }


}
