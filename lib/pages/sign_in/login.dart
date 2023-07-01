import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:publicschool_app/app/arch/bloc_provider.dart';
import 'package:publicschool_app/common/widgets/load_container/load_container.dart';
import 'package:publicschool_app/pages/sign_in/bloc/login_bloc.dart';
import 'package:publicschool_app/pages/splash/curve.dart';
import 'package:publicschool_app/utilities/fonts.dart';
import 'package:toast/toast.dart';
import '../../utilities/ps_colors.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
    LoginBloc? _bloc;
    FocusNode _passwordFocus=FocusNode();
    @override
  void initState() {
    _bloc=BlocProvider.of(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    bool _isObscure = true;

    return LoaderContainer(
      stream: _bloc!.isLoading,

      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body:SingleChildScrollView(
          child:  Column(
            children: [
              Container(
                height:MediaQuery.of(context).size.height * 0.37,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerRight,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/login.png'),fit: BoxFit.fill),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left:MediaQuery.of(context).size.width * 0.50,top:  MediaQuery.of(context).size.height * 0.07,bottom: 10),
                      alignment: Alignment.centerRight,
                      height:MediaQuery.of(context).size.width * 0.27,
                      width: MediaQuery.of(context).size.width * 0.27,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.27)
                        //more than 50% of width makes circle
                      ),
                      child: Center(
                          child: Image.asset('assets/images/logo.png')

                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left:  MediaQuery.of(context).size.width * 0.55,top: 0),
                      alignment: Alignment.centerRight,
                      child: Row(
                        children: [
                          Image(image: AssetImage('assets/images/e.png')),
                          Text('- Schools',style:  TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 25),
                        alignment: Alignment.bottomLeft,
                        child: Text('Login',style:  TextStyle(color: PSColors.app_color,fontSize: 30,fontWeight: FontWeight.bold),),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                  height:  MediaQuery.of(context).size.height * 0.38,
                  color: Colors.white,
                  child:  Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10,),
                            Container(
                              padding: EdgeInsets.only(left:20),
                              child: Text("Please sign in to continue",
                                style: TextStyle(fontSize: 16,color: PSColors.app_color),),
                            ),
                            SizedBox(height: 20,),
                            Container(
                              padding: EdgeInsets.only(left:20,right: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('User Name',style: TextStyle(fontSize: 14,fontFamily: WorkSans.regular,color: PSColors.app_color),),
                                  SizedBox(height: 10,),
                                  SizedBox(
                                    height: 50,
                                    child: TextField(
                                        decoration: InputDecoration(
                                          focusedBorder:
                                          OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                                          enabledBorder:
                                          OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                                        ),
                                        style: TextStyle(fontSize: 12,fontFamily: WorkSans.semiBold,color: PSColors.text_color),
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.name,
                                        onSubmitted: (_)=>_passwordFocus.requestFocus(),
                                        onChanged: _bloc?.userName.add),
                                  ),

                                ],
                              ),
                            ),
                            const SizedBox(height: 20,),
                            Container(
                              padding: EdgeInsets.only(left:20,right: 20),

                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Password',style: TextStyle(fontSize: 14,fontFamily: WorkSans.regular,color: PSColors.app_color),),
                                  SizedBox(height: 10,),
                                  SizedBox(
                                    height: 50,
                                    child: TextField(
                                      decoration: InputDecoration(
                                      //  contentPadding: EdgeInsets.only(left: 12, right: 12),
                                        focusedBorder:
                                          OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                                        enabledBorder:
                                          OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                                      ),
                                      style: TextStyle(fontSize: 12,fontFamily: WorkSans.semiBold,color: PSColors.text_color),
                                      textInputAction: TextInputAction.done,
                                      obscureText: _isObscure,

                                      focusNode: _passwordFocus,
                                      onSubmitted: (_)=>_bloc?.login.add(null),
                                      onChanged: _bloc?.password.add,),
                                  ),
                                ],
                              ),
                            ),
                          ]))),
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                color: Colors.white,
                alignment: Alignment.bottomCenter,
                child: CurvedSheet(bottomSheetColor: PSColors.app_color,
                    forwardIconColor: Colors.white,
                    backgroundColor: Colors.white,
                    secondGradiantColor:Colors.white ,
                    forwardColor:PSColors.red_color ,
                    skipText:"" ,
                    text: '',
                    textColor: Colors.white,
                    firstGradiantColor: Colors.blueAccent ,
                    backText: "", currentPage: 1,back: (){
                      Navigator.pop(context);
                    },onPressed: (){
                      _bloc?.login.add(null);
                    },skip: (){},totalPages: 0),
              ),
              /*  Expanded(
              flex: 3,
                child:  Container(
                  color: Colors.white,
                  alignment: Alignment.bottomCenter,
                  child: CurvedSheet(bottomSheetColor: PSColors.app_color,
                      forwardIconColor: Colors.white,
                      backgroundColor: Colors.white,
                      secondGradiantColor:Colors.white ,
                      forwardColor:PSColors.red_color ,
                      skipText:"" ,
                      text: '',
                      textColor: Colors.white,
                      firstGradiantColor: Colors.blueAccent ,
                      backText: "", currentPage: 1,back: (){
                        Navigator.pop(context);
                      },onPressed: (){
                        _bloc?.login.add(null);
                      },skip: (){},totalPages: 0),
                ),)*/
            ],
          ),
        )




      ),
    );

  }
}
