
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:publicschool_app/model/subject/subject_list_data.dart';
import 'package:sqflite/sqflite_dev.dart';

import '../../../helper/logger/logger.dart';
import '../../../utilities/ps_colors.dart';

void openClassBottomSheet({List<ClassList>? classList,  Function(ClassList classList)? onCallback,int? selectedPos}){


  showModalBottomSheet(
    context: Get.context!,

        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: PSColors.dialog_bg,
              ),
              height: 300,
              margin: const EdgeInsets.all(10),
              alignment: Alignment.center,
              child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: (1 / .55),
                shrinkWrap: true,
                children: List.generate(classList!.length, (index) {
                  return GestureDetector(
                    onTap: (){
                      onCallback!(classList[index]);
                      setState(() => selectedPos = int.parse(classList[index].classId!));
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        elevation: 2,
                        color: (selectedPos==int.parse(classList[index].classId!))?PSColors.app_color:Colors.white,
                        child: Center(child: Text(classList[index].className!,style: TextStyle(fontSize: 12,color: (selectedPos==int.parse(classList[index].classId!))?Colors.white:PSColors.text_color),))
                        ,
                      ),
                    ),
                  );
                }),
              ),

            ),
          );


    },
  );

}