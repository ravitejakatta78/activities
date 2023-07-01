
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Sliderwidget extends StatefulWidget{
  List<String>? schoolImages;
 Sliderwidget({this.schoolImages});

  @override
  SliderwidgetState createState() => SliderwidgetState();


}

class SliderwidgetState extends State<Sliderwidget>  {
  int currentPos=0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
    CarouselSlider(
    options: CarouselOptions(
    height: 180,
      viewportFraction: 1.0,
      enlargeCenterPage: false,
       autoPlay: true,
        onPageChanged: (index, reason) {
          setState(() {
            currentPos = index;
          });
        }
    ),
    items: widget.schoolImages!.map((item) => Container(
      margin: EdgeInsets.only(left: 10,right: 10,),
      width: MediaQuery.of(context).size.width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CachedNetworkImage(
          imageUrl: item,
          height: 170, fit: BoxFit.fill, errorWidget: (context, url, error) => Icon(Icons.error),)


       /* Image.network(
        item,
        fit: BoxFit.fill,
        height: 170,
        ),*/
      ),
    )).toList(),
    ),
      
      ],
    );
  }

}

