import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:get/get.dart';
import 'package:publicschool_app/utilities/fonts.dart';

import '../../utilities/ps_colors.dart';

class CurvedSplashScreen extends StatefulWidget {
  /// Number of screens you want to add
  final int? screensLength;

  /// Widget that appears on each screen according to index

  final Widget Function(int index)? screenBuilder;

  /// Color of the bottom sheet this will remove the gradiant color.

  final Color? bottomSheetColor;

  /// First Color of the gradiant of the bottom sheet.

  final Color? firstGradiantColor;

  /// Second Color of the gradiant of the bottom sheet.

  final Color? secondGradiantColor;

  /// Text label to the back button.

  final String? backText;

  /// Text label to the skip button.

  final String? skipText;

  /// Color given to the forward button, default is Red
  final Color? forwardColor;

  /// Color given to the forward icon, default is White

  final Color? forwardIconColor;

  /// Color given to the forward back and skip text the, default is White.

  final Color? textColor;

  /// Color given to the backgroud of the screen, default is White.

  final Color? backgroundColor;

  /// Action done when the skip button pressed or to the forward button at the end of the screens. Usually navigate to another screen.
  final Function? onSkipButton;
  const CurvedSplashScreen({
    Key? key,
     this.screensLength,
     this.screenBuilder,
     this.onSkipButton,
     this.firstGradiantColor,
     this.secondGradiantColor,
     this.backText,
     this.skipText,
     this.forwardColor,
     this.forwardIconColor,
     this.textColor,
     this.backgroundColor,
     this.bottomSheetColor,
  }) : super(key: key);

  @override
  _CurvedSplashScreenState createState() => _CurvedSplashScreenState();
}

class _CurvedSplashScreenState extends State<CurvedSplashScreen> {
  int currentPageIndex = 0;
  late PageController _pageController;

  @override
  Widget build(BuildContext context) {
    SizeConfig.initSize(context);
    _pageController = PageController(initialPage: 0);

    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: PageView.builder(
        itemCount: widget.screensLength,
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        itemBuilder: (context, index) => Center(child: widget.screenBuilder!(index)),
      ),
      bottomSheet: CurvedSheet(
        totalPages: widget.screensLength!,
        currentPage: currentPageIndex,
        firstGradiantColor: widget.firstGradiantColor!,
        secondGradiantColor: widget.secondGradiantColor!,
        backText: widget.backText!,
        skipText: widget.skipText!,
        forwardColor: widget.forwardColor!,
        forwardIconColor: widget.forwardIconColor!,
        textColor: widget.textColor!,
        backgroundColor: widget.backgroundColor!,
        bottomSheetColor: widget.bottomSheetColor!,
        skip: () {
          widget.onSkipButton!();
        },
        back: () {
          if (_pageController.page! > 0) {
            _pageController.jumpToPage(_pageController.page!.toInt() - 1);
          }
        },
        onPressed: () {
          if (_pageController.page! < widget.screensLength! - 1) {
            _pageController.animateToPage(
              _pageController.page!.toInt() + 1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          } else {
            widget.onSkipButton!();
          }
        },
      ),
    );
  }
}

class CurvedSheet extends StatelessWidget {
  final int totalPages;
  final int currentPage;
  final Function onPressed;
  final Function back;
  final Function skip;
  final Color firstGradiantColor;
  final Color secondGradiantColor;
  final String backText;
  final String skipText;
  final Color forwardColor;
  final Color forwardIconColor;
  final Color textColor;
  final Color backgroundColor;
  final Color bottomSheetColor;
  final String? text;
  const CurvedSheet({
    Key? key,
    required this.totalPages,
    required this.currentPage,
    required this.onPressed,
    required this.back,
    required this.skip,
    required this.firstGradiantColor,
    required this.secondGradiantColor,
    required this.backText,
    required this.skipText,
    required this.forwardColor,
    required this.forwardIconColor,
    required this.textColor,
    required this.backgroundColor,
    required this.bottomSheetColor,
    this.text

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        Container(
          color: backgroundColor,
          child: CustomPaint(
            painter: NavigationPainter(
                bottomSheetColor: bottomSheetColor,
                firstGradiantColor: firstGradiantColor,
                secondGradiantColor: secondGradiantColor),
            child: Container(
            ),
          ),
        ),

        ForwardButtom(
            forwardColor: forwardColor,
            forwardIconColor: forwardIconColor,
            onPressed: onPressed,
            text:text),
        Positioned.fill(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: getRelativeWidth(0.05))
                  .copyWith(bottom: getRelativeHeight(0.07)),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          back();
                        },
                        child: Text(
                          backText,
                          style: TextStyle(
                            color: textColor,
                            fontSize: getRelativeWidth(0.048),
                          ),
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: getSplashDots(totalPages, currentPage)),
                      GestureDetector(
                        onTap: () {
                          skip();
                        },
                        child: Text(
                          skipText,
                          style: TextStyle(
                            color: textColor,
                            fontSize: getRelativeWidth(0.048),
                          ),
                        ),
                      ),
                    ],
                  )),
            )),
      ],
    );
  }
}

class ForwardButtom extends StatelessWidget {
  const ForwardButtom({
    Key? key,
    required this.onPressed,
    required this.forwardColor,
    required this.forwardIconColor,
    this.text

  }) : super(key: key);

  final Function onPressed;
  final Color forwardColor;
  final Color forwardIconColor;
  final String? text;
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () {
          onPressed();
        },
        child: Column(
          children: [
           /* Container(
              alignment: Alignment.center,
              child: Text((text!='')?text.toString():'',style: TextStyle(fontSize:16,color: PSColors.text_black_color,fontFamily: WorkSans.semiBold),),
            ),
            (text!='')?SizedBox(height: 5,):SizedBox(),*/
            Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: forwardColor,
                  boxShadow: [
                    BoxShadow(
                        color: forwardColor != null
                            ? forwardColor.withOpacity(0.38)
                            : Colors.red.withOpacity(0.38),
                        blurRadius: 10,
                        spreadRadius: 6,
                        offset: const Offset(0, 8))
                  ]),
              height: getRelativeWidth((1 / 5.3)),
              width: getRelativeWidth((1 / 5.3)),
              child: Icon(
                Icons.arrow_forward,
                size: getRelativeWidth((0.08)),
                color: forwardIconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<Widget> getSplashDots(int maxLength, int selectedDot) {
  List<Widget> dots = [];
  for (int i = 0; i < maxLength; i++) {
    dots.add(
      Row(
        children: [
          Container(
            height: getRelativeHeight(0.01),
            decoration: BoxDecoration(
                color: selectedDot == i
                    ? Colors.white.withOpacity(0.9)
                    : Colors.white.withOpacity(0.4),
                borderRadius: BorderRadius.circular(15)),
            width: selectedDot == i
                ? getRelativeWidth(0.038)
                : getRelativeWidth(0.022),
          ),
          if (i < maxLength - 1) ...[
            SizedBox(width: getRelativeWidth(0.015)),
          ]
        ],
      ),
    );
  }
  return dots;
}

class SizeConfig {
  static double? screenWidth;
  static double? screenHeight;

  static initSize(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    screenWidth = mediaQuery.size.width;
    screenHeight = mediaQuery.size.height;
  }
}

double getRelativeHeight(double percentage) {
  return percentage *  MediaQuery.of(Get.context!).size.height;
}

double getRelativeWidth(double percentage) {
  return percentage * MediaQuery.of(Get.context!).size.width;
}

class NavigationPainter extends CustomPainter {
  NavigationPainter({
    required this.bottomSheetColor,
    required this.firstGradiantColor,
    required this.secondGradiantColor,
  });
  final Color firstGradiantColor;
  final Color secondGradiantColor;
  final Color bottomSheetColor;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(size.width, 0),
        Offset(size.width, size.height),
        [
          bottomSheetColor != null
              ? bottomSheetColor
              : firstGradiantColor,
          bottomSheetColor != null
              ? bottomSheetColor
              : secondGradiantColor
        ],
      )
      ..style = PaintingStyle.fill;

    double offsetheight = size.height * 0.3;

    var path = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(
        size.width * 0.03,
        offsetheight,
        offsetheight,
        offsetheight,
      )
      ..lineTo(size.width * (2 / 6), offsetheight)
      ..quadraticBezierTo(size.width / 2, size.height * 0.75,
          size.width * (4 / 6), offsetheight)
      ..lineTo(size.width - (offsetheight), offsetheight)
      ..quadraticBezierTo(
        size.width - (size.width * 0.03),
        offsetheight,
        size.width,
        0,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
