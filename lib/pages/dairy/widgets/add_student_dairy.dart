
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:toast/toast.dart';

import '../../../app/arch/bloc_provider.dart';
import '../../../common/widgets/dropdown/custom_dropdown.dart';
import '../../../common/widgets/load_container/load_container.dart';
import '../../../helper/logger/logger.dart';
import '../../../model/sections/sections_data.dart';
import '../../../model/subject/subject_list_data.dart';
import '../../../utilities/fonts.dart';
import '../../../utilities/ps_colors.dart';
import '../bloc/add_student_dairy_bloc.dart';

class AddStudentDairy extends StatefulWidget{

  @override
  AddStudentDairyState createState() => AddStudentDairyState();
}
class AddStudentDairyState extends State<AddStudentDairy>{
  AddStudentDairyBloc? _bloc;
  TextEditingController? _controller;
  void initState() {
    super.initState();
    _bloc=BlocProvider.of(context);
    _controller = new TextEditingController();
    _controller!.text="Hello";
    ToastContext().init(context);
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       backgroundColor: PSColors.app_color,
       centerTitle: true,
       title: const Text('Add Student Dairy',style:TextStyle(fontFamily: WorkSans.semiBold,fontSize: 20)),
     ),
     body: LoaderContainer(
       stream: _bloc?.isLoading,
       child: Padding(
         padding: const EdgeInsets.all(20.0),
         child: SingleChildScrollView(
           child:Column(
             children: [
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
                                   _bloc?.getSections({"action":"section-list","class_id":s.data![i].classId!},2);
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
                      // _bloc?.addSection.add(s.data![0].sectionName!);
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
                           )
                               ;
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

                               for (int i = 0; i < s.data!.length; i++) {
                                 if(value==s.data![i].subjectName!) {
                                   _bloc?.addSubject.add(s.data![i].subjectName!);
                                   _bloc?.addSubjectId.add(s.data![i].id!);
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

               StreamBuilder<String>(
                   initialData: '',
                   stream: _bloc!.startDateStream,
                   builder:(c,s)=>
                       TextField(
                         decoration:   InputDecoration(
                           hintText: 'Date',
                           suffixIcon: Icon(Icons.calendar_month),
                           border: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(15),
                             borderSide: BorderSide(color: Colors.black, width: 1)
                           ),
                           focusedBorder: OutlineInputBorder(
                               borderSide: BorderSide(color: Colors.black, width: 1)),
                         ),
                         controller: TextEditingController(text: s.data!),
                         onTap: () async {
                           _bloc!.getStateDate(2);

                         },

                       ),

               ),
               SizedBox(height: 25,),
               StreamBuilder<String>(
                 initialData: '',
                 stream: _bloc!.description,
                 builder: (context, snapshot) {
                   _controller!.value = _controller!.value.copyWith(text: snapshot.data!);
                     return Container(
                     padding: EdgeInsets.all(6),
                     decoration: BoxDecoration(
                       color: Colors.white,
                       borderRadius: BorderRadius.circular(10),
                     ),
                     child: TextField(
                       controller: _controller,
                       keyboardType: TextInputType.multiline,
                       maxLines: 6,
                       textInputAction: TextInputAction.done,
                       decoration: InputDecoration(
                           border: InputBorder.none,
                           hintText: 'Description'
                       ),
                       onChanged: (value){
                           _bloc!.addDescription.add(value);
                       },

                     ),
                   );
                 }
               ),



               const SizedBox(height:50,),
               SizedBox(
                 height: 50,
                 width: MediaQuery.of(context).size.width,
                 child: ElevatedButton(
                   child: Text('Save',style: TextStyle(color: Colors.white)),
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
                     _bloc?.student_dairy_submit.add(null);
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