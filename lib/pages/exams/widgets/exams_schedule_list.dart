import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:publicschool_app/common/widgets/container_widget/container_widget.dart';
import 'package:publicschool_app/model/exams/exams_data.dart';
import 'package:publicschool_app/model/exams/exams_schedule_data.dart';
import 'package:publicschool_app/pages/exams/bloc/exams_schedule_list_bloc.dart';
import '../../../app/arch/bloc_provider.dart';
import '../../../helper/logger/logger.dart';
import '../../../utilities/fonts.dart';
import '../../../utilities/ps_colors.dart';

class ExamsScheduleList extends StatefulWidget {
  @override
  ExamsScheduleListState createState()=> ExamsScheduleListState();
}
class ExamsScheduleListState extends State<ExamsScheduleList>{
 ExamsScheduleListBloc? _bloc;
  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _bloc?.getExamsSchedule();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PSColors.app_color,
        centerTitle: true,
        title: const Text('Exams Schedule List',style:TextStyle(fontFamily: WorkSans.semiBold,fontSize: 20)),
      ),
      body:Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.only(left: 10,right: 10,top: 20),
        child: Column(
          children: [
            StreamBuilder<ExamsList>(
                initialData: null,
                stream: _bloc!.getExamsList,
                builder: (c,s){
                  return(s.data!=null)? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(flex:2,child: Text("Class Name : ",textAlign: TextAlign.center,style: TextStyle(fontFamily: WorkSans.regular,fontSize: 14,color: PSColors.text_black_color),)),

                          Expanded(flex:5,child: Text("${(s.data!.sectionName!.isNotEmpty)?(s.data!.className!+"-"+s.data!.sectionName!):s.data!.className!}",textAlign: TextAlign.start,style: TextStyle(fontFamily: WorkSans.semiBold,fontSize: 13,color: PSColors.text_black_color),)),
                        ],
                      ),
                      SizedBox(height: 5,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(flex:2,child: Text("Exam Name : ",textAlign: TextAlign.center,style: TextStyle(fontFamily: WorkSans.regular,fontSize: 14,color: PSColors.text_black_color),)),
                          Expanded(flex:5,child: Text(s.data!.examName!,textAlign: TextAlign.start,style: TextStyle(fontFamily: WorkSans.semiBold,fontSize: 13,color: PSColors.text_black_color),)),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(flex:2,child: Text("Start Date   : ",textAlign: TextAlign.center,style: TextStyle(fontSize: 14,color: PSColors.text_black_color,fontFamily: WorkSans.regular),)),
                          Expanded(flex:5,child: Text(s.data!.examStartDate!,textAlign: TextAlign.start,style: TextStyle(fontSize: 13,color: PSColors.text_black_color,fontFamily: WorkSans.semiBold),)),

                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(flex:2,
                              child: Text("End Date     : ",textAlign: TextAlign.center,style: TextStyle(fontSize: 14,color: PSColors.text_black_color,fontFamily: WorkSans.regular),)),
                          Expanded(flex:5,
                              child: Text(s.data!.examEndDate!,textAlign: TextAlign.start,style: TextStyle(fontSize: 13,color: PSColors.text_black_color,fontFamily: WorkSans.semiBold),)),

                        ],
                      ),
                    ],

                  ):SizedBox();

                }),

            StreamBuilder<List<ExamScheduleList>?>(
                initialData: [],
                stream: _bloc!.examsSchedule,
                builder: (context, snapshot) {
                  printLog(("Data Length"), snapshot.data!.length);
                  return (snapshot.data!.isNotEmpty)?Column(
                    children: [
                      const SizedBox(height: 15,),
                      Divider(thickness: 1,color: PSColors.hint_text_color,),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (c,s){
                            return   Container(
                              height: 93,
                              width: 346,
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                color: Colors.white, //background color
                                border: Border.all(
                                    color: PSColors.box_border_color// border color
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex:3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(width: 3,color: PSColors.app_color)
                                            ),

                                            child: Text(
                                              (snapshot.data![s].subjectName!=null)?(snapshot.data![s].subjectName!.isNotEmpty)?
                                              _getInitials(snapshot.data![s].subjectName!):'':'',
                                              style: TextStyle(color: PSColors.text_color, fontSize: 14,fontFamily: WorkSans.semiBold),
                                            ),
                                          ),
                                         SizedBox(height: 5,),
                                         Text(snapshot.data![s].subjectName!,style: TextStyle(fontFamily: WorkSans.regular,fontSize: 12,color: PSColors.text_black_color)),
                                ],
                                      ),
                                  ),
                                  VerticalDivider(
                                    color: PSColors.box_border_color,  //color of divider
                                    width: 10, //width space of divider
                                    thickness: 1, //thickness of divier line
                                  ),

                                  Expanded(
                                      flex:8,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                         Image(image: AssetImage('assets/images/clock.png'),),
                                          SizedBox(height: 10,),
                                          Text('${DateFormat('dd-MMM-yyyy \n  H:mm a').format(convertDate(snapshot.data![s].examDate!.toString()))}',style: TextStyle(fontFamily: WorkSans.bold,fontSize: 14,color: PSColors.text_color))

                                        ],
                                      )

                                  ),

                                ],
                              ),
                            );

                          }),
                    ],
                  ):Text('No Data');
                }
            )



          ],
        ),
      ),



    );

  }
 String _getInitials(String user) {
   printLog("user", user);
   if(user.length>0){
     var buffer = StringBuffer();
     var split = user.split(" ");
     for (var s in split) buffer.write(s[0]);

     return buffer.toString().substring(0, split.length);
   }else return '';

 }


 DateTime convertDate(String dateValue){

   DateTime parseDate = new DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateValue);
   var inputDate = DateTime.parse(parseDate.toString());
   var outputFormat = DateFormat('dd-MM-yyyy H:mm a');
   var outputDate = outputFormat.format(inputDate);
   return parseDate;
 }
}
