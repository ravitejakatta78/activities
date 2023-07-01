import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:publicschool_app/app/arch/bloc_provider.dart';
import 'package:publicschool_app/common/widgets/load_container/load_container.dart';
import 'package:publicschool_app/helper/logger/logger.dart';

import 'package:publicschool_app/model/dashboard/dashboard_response.dart';
import 'package:publicschool_app/model/login/login_response.dart';
import 'package:publicschool_app/pages/home/dashboard/dashboard_page.dart';
import 'package:publicschool_app/pages/home/side_menu.dart';
import 'package:publicschool_app/pages/home/widgets/menu_widget.dart';
import 'package:publicschool_app/pages/home/widgets/slide_one.dart';
import 'package:publicschool_app/pages/home/widgets/slider_widget.dart';
import 'package:publicschool_app/utilities/ps_colors.dart';

import 'bloc/dashboard_bloc.dart';



class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();


}
class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
 int currentPage = 0;
 DashboardBloc? _bloc;
  late PageController _pageController;
  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return LoaderContainer(
      stream: _bloc!.isLoading,
      child: Scaffold(
        key: _key,
      appBar: AppBar(
        toolbarHeight: 90,
        leading:IconButton(onPressed: (){

          _key.currentState!.openDrawer();
        }, icon: Image.asset('assets/images/menu.png')) ,
        centerTitle: true,
        title: StreamBuilder<bool>(
            initialData: false,
            stream: _bloc!.isVisible,
            builder: (context, snapshot) {
              return GestureDetector(
                onTap: (){
                  if(snapshot.data==true)
                    _bloc?.imageVisible.add(false);
                  else _bloc?.imageVisible.add(true);

                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(

                      alignment: Alignment.center,
                      height:50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50)

                      ),
                      child: Center(
                          child: Image.asset('assets/images/logo.png')

                      ),
                    ),
                    SizedBox(height: 16,),
                    SizedBox(
                      height: 6,
                      width:49,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: PSColors.bg_color
                        ),
                        onPressed: (){

                        }, child: null,
                      ),
                    )
                  ],
                ),
              );
            }
        ),
        actions: [
          IconButton(onPressed: (){

          }, icon: Image.asset('assets/images/voice.png'))
        ],
        backgroundColor: PSColors.app_color,
      ),
        body:SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder<bool>(
                initialData: false,
                stream: _bloc?.isVisible,
                builder: (c, s) {
                  return Visibility(
                      child: Image.network('https://kyzens.com/dev/eschool/web/mobile-images/startup-images/img-3.png',height: 200,),
                      visible: s.data!,
                    maintainState: true,
                  );
                }
              ),
              SizedBox(height: 0,),
              DashboardPage()

            ],

          ),
          //child: DashboardPage(),


        ),

        drawer: SideMenu()

      ),
    );

  }


}