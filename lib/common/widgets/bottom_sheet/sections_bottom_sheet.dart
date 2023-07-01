
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:publicschool_app/model/sections/sections_data.dart';

import '../../../utilities/ps_colors.dart';

void sectionsBottomSheet({List<SectionsList>? sectionsList,  Function(SectionsList sectionsList)? onCallback,int? selectedPos}){

  showModalBottomSheet(
      context: Get.context!,
      builder: (BuildContext context){
       return BottomSheet(
        onClosing: () {},
         builder: (BuildContext context) {

    return StatefulBuilder(
    builder: (BuildContext context, setState) => Container(
    color: PSColors.bg_color,
    height: 240,
    alignment: Alignment.topLeft,

    child: GridView.count(
      crossAxisCount: 3,
      childAspectRatio: (1 / .55),
      shrinkWrap: true,
      children: List.generate(sectionsList!.length, (index) {
        return GestureDetector(
          onTap: (){
            onCallback!(sectionsList[index]);

            setState(() => selectedPos=int.parse(sectionsList[index].sectionId!));
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(5),
              ),
              elevation: 2,
              color: (selectedPos==int.parse(sectionsList[index].sectionId!))?PSColors.app_color:Colors.white,
              child: Center(child: Text(sectionsList[index].sectionName!,
                style: TextStyle(fontSize: 12,color: (selectedPos==int.parse(sectionsList[index].sectionId!))?Colors.white:PSColors.text_color),))),
          ),
        );
      }),
    ),

    ),);},);
  });
}

