import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:publicschool_app/di/app_injector.dart';
import 'package:publicschool_app/di/i_register_dashboard.dart';
import 'package:publicschool_app/di/i_register_login.dart';
import 'package:publicschool_app/model/login/login_response.dart';
import 'package:publicschool_app/pages/home/profile/widget/user_profile.dart';
import 'package:publicschool_app/utilities/fonts.dart';

import '../../helper/logger/logger.dart';
import '../../utilities/ps_colors.dart';

class SideMenu extends StatefulWidget {

  SideMenu();
  @override
  SidemenuState createState() => SidemenuState();

}
class SidemenuState extends State<SideMenu> {

   UserDetails? userDetails;
  @override
  void initState() {
    super.initState();
    getUser();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text((userDetails!=null)?userDetails!.firstName!:''),
            ),
            accountEmail: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text((userDetails!=null)?userDetails!.email!:''),
            ),
            currentAccountPicture:  CircleAvatar(
              backgroundColor: PSColors.bg_color,
              child:  CachedNetworkImage(
                imageBuilder: (context, imageProvider) => Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),

                imageUrl: (userDetails!.imgUrl!=null)?userDetails!.imgUrl!:
                'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg',
                errorWidget: (context, url, error) => CircleAvatar(
                    radius: 30,
                    backgroundColor: PSColors.bg_color,
                    child: Image(image: AssetImage('assets/images/logo.png'),)),

              ),


            ),
            decoration: BoxDecoration(
              color: PSColors.app_color,
              image: const DecorationImage(
                  fit: BoxFit.fill,
                  image: CachedNetworkImageProvider(
                      'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Get.to(AppInjector.instance.profile);
            }
          ),
          ListTile(
            leading: const Icon(Icons.rate_review),
            title: const Text('Rate Public School'),
            onTap: () {

            },),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Change Password'),
            onTap: () {

              Get.to(AppInjector.instance.changePassword);

            },          ),

          const Divider(),

          ListTile(
            title: const Text('Log Out'),
            leading: const Icon(Icons.exit_to_app),
            onTap: ()  {
              showDialog(context: context, builder: (BuildContext context){
                return  AlertDialog(
                  title: Text("Are you sure want to logout ?" ,style: TextStyle(fontSize: 18,fontFamily: WorkSans.bold,color: PSColors.text_black_color),),
                  actions: [
                    ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.0),
                                  side:BorderSide(color: PSColors.app_color))
                          )
                      ),
                      child:  Text('No',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color:PSColors.app_color ),),

                      onPressed: () {

                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 10,),
                    ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(PSColors.app_color),
                          backgroundColor: MaterialStateProperty.all<Color>(PSColors.app_color),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.0),
                                  side: BorderSide(color: PSColors.app_color))
                          )
                      ),
                      child:const Text('Yes',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color:Colors.white ),),
                      onPressed: () async{
                        await  AppInjector.instance.userDataStore.deleteUser();

                        Get.offAll(AppInjector.instance.login);
                        Navigator.pop(context);

                      },
                    ),




                  ],
                );
              });




            },        ),
        ],
      ),
    );
  }

  void getUser() async {
    userDetails= (await AppInjector.instance.userDataStore.getUser())!;
    setState(() {

    });
  }
  }

