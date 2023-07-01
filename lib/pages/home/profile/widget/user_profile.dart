

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:publicschool_app/di/i_register_dashboard.dart';
import 'package:publicschool_app/model/login/login_response.dart';
import 'package:publicschool_app/pages/home/profile/bloc/user_profile_bloc.dart';
import 'package:toast/toast.dart';

import '../../../../app/arch/bloc_provider.dart';
import '../../../../common/widgets/bottom_sheet/bottom_sheet.dart';
import '../../../../common/widgets/dropdown/custom_dropdown.dart';
import '../../../../common/widgets/load_container/load_container.dart';
import '../../../../di/app_injector.dart';
import '../../../../utilities/fonts.dart';
import '../../../../utilities/ps_colors.dart';

class UserProfile extends StatefulWidget {


  UserProfileState createState() => UserProfileState();
}
class UserProfileState extends State<UserProfile>{
  UserProfileBloc? bloc;
  File? imageFile;
  TextEditingController? _controller;
  final List<String> gender = ['Male', 'Female', 'Others'];
  @override
  void initState() {
    super.initState();
    bloc=BlocProvider.of(context);
   // bloc?.addGender.add(gender[0]);
    _controller = new TextEditingController();
    _controller!.text="";
    ToastContext().init(context);
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(backgroundColor: PSColors.app_color, centerTitle: true,
        leading: IconButton(onPressed: () {
          Get.to(AppInjector.instance.dashboard);

        }, icon: Icon(Icons.arrow_back),),
        title: const Text('User Profile',style:TextStyle(fontSize: 20,fontFamily: WorkSans.semiBold,)),
    ),
    body: LoaderContainer(
      stream: bloc!.isLoading,
      child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(onTap: () {
                  openBottomSheet(onCallback:(file) async {
                    Navigator.pop(context);
                    if(file=='Cam'){
                      imageFile=await getImageFromCamera();
                    }else {
                      imageFile=await getImageFromGallery();
                    }
                    bloc?.addImage.add(imageFile);
                  },);

                },child: StreamBuilder<File?>(
                  initialData: null,
                  stream: bloc?.image,
                  builder: (c,s){
                    return  Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor:Colors.grey,
                          child: ClipOval(
                            child: SizedBox.fromSize(
                              size: Size.fromRadius(50), // Image radius
                              child: (s.data!=null)?Image.file
                                (s.data!,fit: BoxFit.fill):Image.asset('assets/images/logo.png',
                                  width: 60, height: 60, fit: BoxFit.fill),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: ClipOval(
                            child: Container(
                              padding: EdgeInsets.all(5),
                              color: Colors.white.withOpacity(0.8),
                              child: Icon(Icons.camera_alt_outlined,size: 16,),
                            ),
                          ),
                        ),
                      ],
                    ) ;
                  },
                )
                ),
                Container(
                  padding: EdgeInsets.only(top:20,left:20,right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('First Name',style: TextStyle(fontSize: 14,fontFamily: WorkSans.regular,color: PSColors.app_color,decoration: TextDecoration.none,),),
                      SizedBox(height: 10,),
                      SizedBox(
                        height: 50,
                        width: 350,
                        child:  StreamBuilder<String>(
                          initialData: '',
                          stream: bloc!.firstName,
                          builder: (context, snapshot) {
                            return TextField(
                                maxLines:1,
                                controller: TextEditingController.fromValue(
                                    new TextEditingValue(
                                        text: snapshot.data!,
                                        selection: new TextSelection.collapsed(
                                            offset: snapshot.data!.length))),
                                textInputAction: TextInputAction.next,
                                style: TextStyle(fontSize: 16,fontFamily: WorkSans.regular,color: PSColors.text_black_color,decoration: TextDecoration.none),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                readOnly: false,
                                onChanged: (value){
                                  bloc!.addFirstName.add(value);
                                }
                            );
                          }
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top:20,left:20,right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Last Name',style: TextStyle(fontSize: 14,fontFamily: WorkSans.regular,color: PSColors.app_color),),
                      SizedBox(height: 10,),
                      SizedBox(
                        height: 50,
                        width: 350,
                        child:  StreamBuilder<String>(
                          initialData: '',
                          stream: bloc!.lastName,
                          builder: (context, snapshot) {
                            return TextField(
                              maxLines:1,
                              controller: TextEditingController.fromValue(
                                  new TextEditingValue(
                                      text: snapshot.data!,
                                      selection: new TextSelection.collapsed(
                                          offset: snapshot.data!.length))),
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              readOnly: false,
                              onChanged: (value){
                                bloc!.addLastName.add(value);
                              }
                      );
                          }
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top:20,left:20,right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email',style: TextStyle(fontSize: 14,fontFamily: WorkSans.regular,color: PSColors.app_color),),
                      SizedBox(height: 10,),
                      SizedBox(
                        height: 50,
                        width: 350,
                        child:  StreamBuilder<String>(
                            initialData: '',
                            stream: bloc!.email,
                            builder: (context, snapshot) {
                              return TextField(
                                  maxLines:1,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  controller: TextEditingController.fromValue(
                                      new TextEditingValue(
                                          text: snapshot.data!,
                                          selection: new TextSelection.collapsed(
                                              offset: snapshot.data!.length))),
                                  readOnly: false,
                                  onChanged: (value){
                                    bloc!.addEmail.add(value);
                                  }
                              );
                            }
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top:20,left:20,right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Gender',style: TextStyle(fontSize: 14,fontFamily: WorkSans.regular,color: PSColors.app_color),),
                      SizedBox(height: 10,),
                      SizedBox(
                        height: 50,
                        width: 350,
                        child: StreamBuilder<String>(
                            initialData: null,
                            stream: bloc?.gender,
                            builder: (context, b) {
                              return  CustomDropdown(
                                hint: 'Select Gender',
                                dropdownItems: gender,
                                buttonWidth: 500,
                                buttonHeight: 60,
                                value: b.data,
                                onChanged: (String? value) {
                                  bloc?.addGender.add(value!);
                                },
                              ) ;
                            }
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(top:20,left:20,right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mobile No',style: TextStyle(fontSize: 14,fontFamily: WorkSans.regular,color: PSColors.app_color),),
                      SizedBox(height: 10,),
                      SizedBox(
                        height: 50,
                        width: 350,
                        child:  StreamBuilder<String>(
                          initialData: '',
                          stream: bloc!.mobile,
                          builder: (context, snapshot) {
                            return TextField(
                                maxLines:1,
                                textInputAction: TextInputAction.next,
                                controller: TextEditingController.fromValue(
                                    new TextEditingValue(
                                        text: snapshot.data!,
                                        selection: new TextSelection.collapsed(
                                            offset: snapshot.data!.length))),
                                  decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                readOnly: false,
                                onChanged: (value){
                                  bloc!.addMobile.add(value);
                                }
                            );
                          }
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  width: 350,
                  margin:EdgeInsets.only(top:40),
                  child: ElevatedButton(onPressed: () {
                    bloc!.user_profile_submit.add(null);
                  },
                      style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(PSColors.text_color),
                      backgroundColor: MaterialStateProperty.all<Color>(PSColors.app_color_lite),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side:  BorderSide(color: PSColors.app_color_lite))
                      )
                  ),
                      child: Text("Save",style: TextStyle(fontSize: 16,fontFamily: WorkSans.semiBold,color: PSColors.text_color),)),
                )

              ],

            ),
          )


    )
  );

  }


}