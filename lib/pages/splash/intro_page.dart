
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:publicschool_app/di/i_register_login.dart';

import '../../di/app_injector.dart';
import '../../utilities/fonts.dart';
import '../../utilities/ps_colors.dart';
import 'curve.dart';

class IntroPage extends StatefulWidget {
  @override
  IntroPageState createState() => IntroPageState();

}
class IntroPageState extends State<IntroPage>{
  int currentPageIndex = 0;
  late PageController _pageController;
  @override
  Widget build(BuildContext context) {
    _pageController = PageController(initialPage: 0);
    return Material(
      type: MaterialType.transparency,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height:MediaQuery.of(context).size.height * 0.75,
            color: Colors.white,
            child:  PageView.builder(
              itemCount: splashContent.length,
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  currentPageIndex = index;
                });
              },
              itemBuilder: (context, index) => Center(child: SplashContent(
                title: splashContent[index]["title"]!,
                image: splashContent[index]["image"]!,
                text: splashContent[index]["text"]!,
              )),
            ),
          ),
          Container(
            height:MediaQuery.of(context).size.height * 0.25,
            color: Colors.white,
            alignment: Alignment.bottomCenter,
            child: CurvedSheet(
                text: '',
                backgroundColor: Colors.white,
                secondGradiantColor:Colors.white ,
                forwardColor:Colors.red ,
                forwardIconColor:Colors.white ,
                skipText:"Skip" ,
                bottomSheetColor:PSColors.app_color,
                firstGradiantColor: Colors.blueAccent ,
                backText: "Back",
                textColor: Colors.white,
                totalPages: splashContent.length,
                currentPage: currentPageIndex,
                back: (){
                  if (_pageController.page! > 0) {
                    _pageController.jumpToPage(_pageController.page!.toInt() - 1);
                  }
                },onPressed: (){
              if (_pageController.page! <splashContent.length - 1) {
                _pageController.animateToPage(
                  _pageController.page!.toInt() + 1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              } else {
                Get.to(AppInjector.instance.login);
              }

                },skip: (){
              Get.to(AppInjector.instance.login);
            }

                ),
          )
        ],
      ),
    );




  }


}
class SplashContent extends StatelessWidget {
  final String title;
  final String text;
  final String image;

  const SplashContent({
    Key? key,
    required this.title,
    required this.text,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.width/1.6,
              width: MediaQuery.of(context).size.width/1.6,

              child: CachedNetworkImage(imageUrl: image,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) => Icon(Icons.error),),
            ),
            Text(
              title,
              style:  TextStyle(
                color: PSColors.text_black_color,
                fontSize: 20,
                fontFamily: WorkSans.bold,
                //fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: EdgeInsets.only(left: 30,right: 30),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style:  TextStyle(
                  color: PSColors.text_color ,
                  fontSize: 14,
                  fontFamily: 'WorkSansRegular',

                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

final splashContent = [
  {
    "title": "Start Learning",
    "text":
    "Start learning now by using this app,Get your choosen course and start journey.",
    "image": 'https://kyzens.com/dev/eschool/web/mobile-images/startup-images/img-1.png',
  },
  {
    "title": "     Explore Courses    ",
    "text": "     Choose which course is suitable for you.   ",
    "image": 'https://kyzens.com/dev/eschool/web/mobile-images/startup-images/img-2.png',
  },
  {
    "title": "At Any time.",
    "text": "Your courses is available at any time you want. Join us now !",
    "image": 'https://kyzens.com/dev/eschool/web/mobile-images/startup-images/img-3.png'
  },

];