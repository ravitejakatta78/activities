

import '../app/arch/bloc_provider.dart';
import '../pages/sign_in/bloc/register_bloc.dart';
import '../pages/sign_in/register.dart';
import 'app_injector.dart';

extension SignUpExtension on AppInjector{

  SignUpFactory get register => container.get();

  registerSignUp(){

    container.registerDependency<SignUpFactory>((){
      return()=> BlocProvider<RegisterBloc>(bloc: RegisterBloc(), child: const MyRegister());
    });


  }

}
