

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:publicschool_app/app/arch/bloc_provider.dart';
import 'package:publicschool_app/common/widgets/load_container/load_container.dart';
import 'package:toast/toast.dart';
import '../../../../utilities/fonts.dart';
import '../../../../utilities/ps_colors.dart';
import '../bloc/change_password_bloc.dart';

class ChangePassword extends StatefulWidget {
  @override
  ChangePasswordState createState() => ChangePasswordState();
}
class ChangePasswordState extends State<ChangePassword>{
  FocusNode _newPasswordFocus=FocusNode();
  ChangePasswordBloc? _bloc;
  @override
  void initState() {
    _bloc=BlocProvider.of(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
   return Scaffold(
      appBar: AppBar(
     backgroundColor: PSColors.app_color,
     centerTitle: true,
     title: const Text('Change Password',style:TextStyle(fontSize: 20,fontFamily: WorkSans.semiBold)),
   ),
     body: LoaderContainer(
       child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
            SizedBox(height: 20,),
             Container(
               padding: EdgeInsets.only(left:20,right: 20),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text('Old Password',style: TextStyle(fontSize: 14,fontFamily: WorkSans.regular,color: PSColors.app_color),),
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
                          onSubmitted: (_)=> _newPasswordFocus.requestFocus(),
                          onChanged: _bloc!.oldPassword.add
                     ),
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
                   Text('New Password',style: TextStyle(fontSize: 14,fontFamily: WorkSans.regular,color: PSColors.app_color),),
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
                        onSubmitted: (_)=>_bloc!.passwordSubmit.add(null),
                        onChanged: _bloc!.newPassword.add
                        ),
                   ),
                 ],
               ),
             ),
             const SizedBox(height: 40,),
             Center(
               child: SizedBox(
                 height: 50,
                 width: 350,
                 child: ElevatedButton(
                   style: ButtonStyle(
                       foregroundColor: MaterialStateProperty.all<Color>(PSColors.app_color),
                       backgroundColor: MaterialStateProperty.all<Color>(PSColors.app_color),
                       shape: MaterialStateProperty.all<
                           RoundedRectangleBorder>(
                           RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0),
                               side: BorderSide(color: PSColors.app_color))
                       )
                   ),
                   child: const Text('Save Password', style: TextStyle(
                       fontSize: 18,
                       fontWeight: FontWeight.bold,
                       color: Colors.white),),
                   onPressed: () {
                     _bloc!.passwordSubmit.add(null);

                   },
                 ),
               ),
             ),

           ]),

     ),

   );

  }
}