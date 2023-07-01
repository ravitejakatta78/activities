

import 'package:publicschool_app/pages/splash/intro_page.dart';

import '../app/arch/bloc_provider.dart';
import '../pages/splash/bloc/intro_page.dart';
import 'app_injector.dart';

extension IntroPageExtension on AppInjector{

  IntoPageFactory get introPage => container.get();

  registerIntroPage(){

    container.registerDependency<IntoPageFactory>((){
      return()=> BlocProvider<IntroPageBloc>(bloc: IntroPageBloc() , child: IntroPage());
    });


  }

}
