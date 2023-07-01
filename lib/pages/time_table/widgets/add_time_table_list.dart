
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:publicschool_app/app/arch/bloc_provider.dart';
import 'package:publicschool_app/common/widgets/load_container/load_container.dart';
import 'package:publicschool_app/helper/logger/logger.dart';
import 'package:publicschool_app/model/sections/sections_data.dart';
import 'package:publicschool_app/model/subject/faculity_list.dart';
import 'package:publicschool_app/utilities/ps_colors.dart';

import '../../../common/widgets/dropdown/custom_dropdown.dart';
import '../../../model/subject/subject_list_data.dart';
import '../../../utilities/fonts.dart';
import '../bloc/add_time_table_bloc.dart';

class AddTimeTableList extends StatefulWidget {

  AddTimeTableListState createState() => AddTimeTableListState();
}

class AddTimeTableListState extends State<AddTimeTableList>{
  AddTimeTableBloc? _bloc;
  final List<String> days = ['Sunday', 'Monday', 'Tuesday','Wednesday','Thursday','Friday','Saturday'];
  @override
  void initState() {
    super.initState();
    _bloc=BlocProvider.of(context);
   // _bloc?.getInfo();
  //  _bloc?.addDays.add(days[0]);

  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: PSColors.bg_color,
    appBar: AppBar(
      backgroundColor: PSColors.app_color,
      centerTitle: true,
      title: Text("Add Time Table",style: TextStyle(fontSize: 20,fontFamily:WorkSans.semiBold),)
    ),
   body: LoaderContainer(
      stream: _bloc?.isLoading,
     child: Padding(
       padding: const EdgeInsets.all(20.0),
       child: SingleChildScrollView(
         child:Column(
           children: [
             StreamBuilder<List<FaculityList>>(
                 initialData: [],
                 stream: _bloc?.facultyList,
                 builder: (context, s){
                   List<String> value = [];
                   if (s.data!.isNotEmpty) {
                     for (int i = 0; i < s.data!.length; i++) {
                       value.add(s.data![i].faculityName!);
                     }
                   }
                   return (s.data!.isNotEmpty) ?StreamBuilder<String>(
                       initialData: null,
                       stream: _bloc?.facultyName,
                       builder: (context, snapshot) {
                         return  CustomDropdown(
                           hint: 'Select Faculty',
                           dropdownItems: value,
                           buttonWidth: 500,
                           buttonHeight: 60,
                           value: snapshot.data,
                           onChanged: (value) {
                        for (int i = 0; i < s.data!.length; i++) {
                          if (value == s.data![i].faculityName!) {
                            _bloc?.addFaculty.add(s.data![i].faculityName!);
                            _bloc?.addFacultyId.add(s.data![i].id!);
                            _bloc?.addFaculty.add(value!);
                            break;
                           }
                  }
                        },) ;
                       }):SizedBox();
                 }

             ),
             const SizedBox(height: 20,),
             StreamBuilder<List<ClassList>>(
                 initialData: [],
                 stream: _bloc?.classList,
                 builder: (context, s){
                   List<String> value = [];
                   List<String> valueId = [];
                   if (s.data!.isNotEmpty) {

                     for (int i = 0; i < s.data!.length; i++) {
                       value.add(s.data![i].className!);
                     }
                   }
                   return (s.data!.isNotEmpty) ?StreamBuilder<String>(
                       initialData: null,
                       stream: _bloc?.class_name,
                       builder: (context, snapshot) {
                         return  CustomDropdown(
                           hint: 'Select Class',
                           dropdownItems: value,
                           buttonWidth: 500,
                           buttonHeight: 60,
                           value: snapshot.data,
                           onChanged: (value) {

                             for (int i = 0; i < s.data!.length; i++) {
                               if(value==s.data![i].className!) {
                                 printLog("addClassId",s.data![i].classId!);
                                 printLog("addClass",s.data![i].className!);
                                 _bloc?.getSections(s.data![i].classId!);
                                 _bloc?.addClassId.add(s.data![i].classId!);
                                 _bloc?.addClass.add(value!);
                                 break;
                               }
                             }
                           },
                         )
                             ;
                       }
                   ):const SizedBox();
                 }

             ),
             const SizedBox(height: 10,),
             StreamBuilder<List<SectionsList>>(
                 initialData: [],
                 stream: _bloc?.sectionsList,
                 builder: (context, s){
                   List<String> value = [];
                   if (s.data!.isNotEmpty) {
                   //  _bloc?.addSection.add(s.data![0].sectionName!);
                     for (int i = 0; i < s.data!.length; i++) {
                       value.add(s.data![i].sectionName!);
                     }
                     value=value.toSet().toList();
                   }
                   return (value.isNotEmpty) ?StreamBuilder<String>(
                       initialData: null,
                       stream: _bloc?.sectionName,
                       builder: (context, snapshot) {
                         return  CustomDropdown(
                           hint: 'Select Section',
                           dropdownItems: value,
                           buttonWidth: 500,
                           buttonHeight: 60,
                           value: snapshot.data,
                           onChanged: (value) {

                             for (int i = 0; i < s.data!.length; i++) {
                               if(value==s.data![i].sectionName!) {
                                 _bloc?.addSection.add(s.data![i].sectionName!);
                                 _bloc?.addSectionId.add(s.data![i].sectionId!);
                                 break;
                               }

                             }
                           },
                         );
                       }
                   ):SizedBox();
                 }

             ),
             const SizedBox(height: 20,),
             StreamBuilder<List<SubjectList>>(
                 initialData: [],
                 stream: _bloc?.subjectList,
                 builder: (context, s){
                   List<String> value = [];
                   if (s.data!.isNotEmpty) {
                     for (int i = 0; i < s.data!.length; i++) {
                       value.add(s.data![i].subjectName!);
                     }
                     value=value.toSet().toList();
                     value.add('Others');
                   }
                   return (s.data!.isNotEmpty) ?StreamBuilder<String>(
                       initialData: null,
                       stream: _bloc?.subject,
                       builder: (context, snapshot) {
                         return  CustomDropdown(
                           hint: 'Select Subject',
                           dropdownItems: value,
                           buttonWidth: 500,
                           buttonHeight: 60,
                           value: snapshot.data,
                           onChanged: (value) {
                             _bloc?.addSubject.add(value!);
                           },
                         )
                             ;
                       }
                   ):SizedBox();
                 }

             ),
             const SizedBox(height: 20,),
             StreamBuilder<String>(
                 initialData: null,
                 stream: _bloc?.days,
                 builder: (context, b) {
                   return  CustomDropdown(
                     hint: 'Select Day',
                     dropdownItems: days,
                     buttonWidth: 500,
                     buttonHeight: 60,
                     value: b.data,
                     onChanged: (String? value) {
                       _bloc?.addDays.add(value!);
                       _bloc?.addDayId.add(days.indexOf(value!).toString());
                     },
                   ) ;
                 }
             ),
             const SizedBox(height: 20,),
             StreamBuilder<String>(
                 initialData: 'Time',
                 stream: _bloc?.time,
                 builder: (c,s){
                   return   TextField(
                     textInputAction: TextInputAction.done,
                     maxLines: 1,
                     controller: TextEditingController(text:s.data),
                     decoration: InputDecoration(
                       focusedBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(10)),
                       enabledBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(10)),
                       hintText: 'Time',
                     ),
                     readOnly: true,  //set it true, so that user will not able to edit text
                     onTap: () async {
                       TimeOfDay? pickedTime =  await showTimePicker(
                         initialTime: TimeOfDay.now(),
                         context: context,

                       );
                       if(pickedTime != null ){
                         print(pickedTime.format(context));   //output 10:51 PM
                         DateTime parsedTime = DateFormat.jm().parseLoose(pickedTime.format(context).toString());
                         print(parsedTime); //output 1970-01-01 22:53:00.000
                         String formattedTime = DateFormat('h:mm a').format(parsedTime);
                         print(formattedTime); //output 14:59:00
                         _bloc?.addTime.add(formattedTime);
                       }else{
                         print("Time is not selected");
                       }
                     },

                   );
                 }),

             const SizedBox(height:50,),
             SizedBox(
               height: 50,
               width: MediaQuery.of(context).size.width,
               child: ElevatedButton(
                 child: Text('Submit',style: TextStyle(color: Colors.white)),
                 style: ButtonStyle(
                     foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                     backgroundColor: MaterialStateProperty.all<Color>( PSColors.app_color),
                     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                         RoundedRectangleBorder(
                             borderRadius: const BorderRadius.only(
                                 topLeft:Radius.circular(10.0),
                                 bottomLeft: Radius.circular(10.0),
                                 topRight:Radius.circular(10.0),
                                 bottomRight: Radius.circular(10.0)
                             ),
                             side: BorderSide(color: PSColors.app_color,width: 1)
                         )
                     )
                 ),
                 onPressed: () {
                   _bloc?.time_table_submit.add(null);
                 },
               ),
             )
           ],
         ),
       ),
     ),

     ),

    );

  }

}