
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import '../../../utilities/ps_colors.dart';

void ValidateDateBottomSheet({Function(String dateTime)? onCallback , required DateTime selectedDate}){

  showModalBottomSheet(
      context: Get.context!,
      builder: (BuildContext context){
        return BottomSheet(
          onClosing: () {},
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (BuildContext context, setState) => Container(
                color: PSColors.app_color,
                height: 110,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CalendarTimeline(
                      initialDate: selectedDate,
                      firstDate: selectedDate,
                      lastDate: DateTime(2030, 11, 20),
                      onDateSelected: (date) {
                        onCallback!(new DateFormat('yyyy-MM-dd').format(date));
                        Navigator.pop(context);


                      },
                      leftMargin: 20,
                      monthColor: Colors.white,
                      dayColor: Colors.white,
                      activeDayColor: Colors.white,
                      activeBackgroundDayColor: PSColors.app_grdi_color,
                      locale: 'en_ISO',
                    )
                  ],

                ),

              ),
            );
          },
        );

      });

}
