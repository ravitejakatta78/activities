
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:publicschool_app/pages/attendance/bloc/faculty_register_bloc.dart';

import '../../../app/arch/bloc_provider.dart';
import '../../../common/widgets/load_container/load_container.dart';
import '../../../common/widgets/no_data/no_data.dart';
import '../../../model/faculty/faculty_list_data.dart';
import '../../../utilities/fonts.dart';
import '../../../utilities/ps_colors.dart';
import 'attendance_history.dart';
import 'attendance_item.dart';

class FacultyRegister extends StatefulWidget {

  FacultyRegisterState createState() => FacultyRegisterState();

}
class FacultyRegisterState extends State<FacultyRegister>{
  FacultyRegisterBloc? _bloc;

  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _bloc?.getFacultyAttendance();
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       backgroundColor: PSColors.app_color,
       centerTitle: true,
       title: const Text('Faculty Register History',style:TextStyle(fontFamily: WorkSans.semiBold,fontSize: 20)),
     ),
     body: Column(
       children: [
         Container(
           padding: EdgeInsets.only(left: 10,right: 10,top: 20),
           child: Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Expanded(
                 flex: 5,
                 child: SizedBox(
                   width: MediaQuery.of(context).size.width/3.5,
                   height: 50,
                   child: ElevatedButton.icon(
                     icon: Icon(
                       Icons.calendar_today_outlined,
                       color: PSColors.hint_text_color,
                       size: 25.0,
                     ),
                     label: StreamBuilder<String>(
                         initialData: 'Start Date',
                         stream: _bloc!.startDateStream,
                         builder: (context, snapshot) {
                           return Text(snapshot.data!);
                         }
                     ),
                     onPressed: () {
                       _bloc!.getStartDate();
                     },
                     style: ElevatedButton.styleFrom(
                       primary: HexColor('#FFFFFF'),
                       onPrimary: PSColors.text_color,
                       shape: new RoundedRectangleBorder(
                         borderRadius: new BorderRadius.circular(10.0),
                       ),
                     ),
                   ),
                 ),
               ),
               SizedBox(width: 15,),
               Expanded(
                 flex: 5,
                 child: SizedBox(
                   width: MediaQuery.of(context).size.width/3.5,
                   height: 50,
                   child: ElevatedButton.icon(
                     icon: Icon(
                       Icons.calendar_today_outlined,
                       color: PSColors.hint_text_color,
                       size: 25.0,
                     ),
                     label: StreamBuilder<String>(
                         initialData: 'End Date',
                         stream: _bloc!.endDateStream,
                         builder: (context, snapshot) {
                           return Text(snapshot.data!);
                         }
                     ),
                     onPressed: () {
                       _bloc!.getEndDate();
                     },
                     style: ElevatedButton.styleFrom(
                       primary: HexColor('#FFFFFF'),
                       onPrimary: PSColors.text_color,
                       shape: new RoundedRectangleBorder(
                         borderRadius: new BorderRadius.circular(10.0),
                       ),
                     ),
                   ),
                 ),
               ),
               SizedBox(width: 15,),
               GestureDetector(
                 onTap: ()=> _bloc!.getFacultyAttendance(),
                 child: const Icon(
                     Icons.search),

               )


             ],
           ),
         ),
         StreamBuilder<List<FacultyAttendanceHistory>?>(
             initialData: [],
             stream: _bloc!.facultyHistory,
             builder: (context, snapshot) {
               return (snapshot.data!.isNotEmpty)?LoaderContainer(
                 stream: _bloc!.isLoading,
                 child: Container(
                   alignment: Alignment.centerLeft,
                     margin: const EdgeInsets.only(left: 10,right: 10,top: 20),
                     child:Column(
                       children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text('Faculty Name : ${(snapshot.data!.length>0)?snapshot.data![0].faculityName!:'' }'
                              ,style: TextStyle(fontFamily: WorkSans.semiBold,fontSize: 16,color: PSColors.app_color),)),
                         const SizedBox(height: 15,),
                         ListView.builder(
                             shrinkWrap: true,
                             itemCount: snapshot.data!.length,
                             itemBuilder: (c,s){
                               return AttendanceItem(snapshot.data![s]);

                             }),
                       ],
                     )
                 ),
               ):NoData();
             }
         )
       ],


     ),


   );
  }

}