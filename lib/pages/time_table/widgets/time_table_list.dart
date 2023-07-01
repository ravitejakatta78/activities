
import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:publicschool_app/common/widgets/load_container/load_container.dart';
import 'package:publicschool_app/di/i_time_table.dart';
import 'package:publicschool_app/helper/logger/logger.dart';
import 'package:publicschool_app/utilities/ps_colors.dart';

import '../../../app/arch/bloc_provider.dart';
import '../../../common/widgets/listview_widget/listview_widget.dart';
import '../../../common/widgets/no_data/no_data.dart';
import '../../../di/app_injector.dart';
import '../../../model/login/login_response.dart';
import '../../../model/time_table/get_time_table.dart';
import '../../../utilities/constants.dart';
import '../../../utilities/fonts.dart';
import '../bloc/time_table_bloc.dart';

class TimeTableList extends StatefulWidget {

  TimeTableListState createState() => TimeTableListState();
}

class TimeTableListState extends State<TimeTableList>{
  String? roleId;
  late TimeTableBloc _bloc;
 @override
 void initState() {
   super.initState();
   _bloc = BlocProvider.of(context);
   _bloc.getClassList({"action":"classList"});
   getUser();
 }

 getUser() async{
   UserDetails? userDetails=await  AppInjector.instance.userDataStore.getUser();
   roleId=userDetails?.roleId;
   if(roleId==Constants.faculty){
     _bloc.addIsFaculty.add(true);
   }
   else{
     _bloc.addIsFaculty.add(false);
   }
 }

 @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: PSColors.bg_color,
    appBar: AppBar(
      backgroundColor: PSColors.app_color,
      centerTitle: true,
      title: Text("Time Table List",style: TextStyle(fontSize: 20,fontFamily:WorkSans.semiBold),)
    ),
    body: LoaderContainer(
      child: Column(
        children: [
          StreamBuilder<int>(
              initialData: -1,
              stream: _bloc.selectedPosition,
              builder: (context, snapshot) {
                return Container(
                  height: 50,
                  margin: const EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  child: ListView.builder(
                    itemCount: 2,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (c,s){
                      return Container(
                          height: 50,
                          width: 150,
                          margin: const EdgeInsets.all(5),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: ElevatedButton.icon(
                                onPressed: (){
                                  _bloc.selectedPos.add(s);
                                  if(s==0) {
                                    _bloc.getClassList({"action":"classList"});
                                  }else{
                                    _bloc.getSections({"action":"section-list"});
                                  }


                                },
                                label: Text((s==0)?'Classes':'Sections',style: TextStyle(fontSize: 16,fontFamily:WorkSans.medium,color: (snapshot.data!=s)?PSColors.text_color:Colors.white),),
                                icon: Icon((s==0)?Icons.menu_book_outlined:Icons.supervisor_account_outlined,size: 16,color: (snapshot.data!=s)?PSColors.app_color:Colors.white,),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all((snapshot.data!=s)?Colors.white:PSColors.app_color),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5.0),
                                            side: BorderSide(color: PSColors.app_color)
                                        )
                                    )
                                )
                            ),
                          )
                      );
                    },

                  ),
                );
              }
          ),
          StreamBuilder<int>(
              initialData: -1,
              stream: _bloc.daySelectedPosition,
              builder: (context, snapshot) {
                return Container(
                  height: 45,
                  margin: const EdgeInsets.all(10),
                  child: ListView.builder(
                    itemCount: 7,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (c,s){
                      return Container(
                          width: 100,
                          margin: const EdgeInsets.all(5),
                          child: ElevatedButton(
                              onPressed: (){
                                _bloc.dayelectedPos.add(s);
                                _bloc.addDayId.add(s.toString());
                              },
                              child: Text((s==0)?'Sunday':(s==1)?'Monday':(s==2)?'Tuesday':(s==3)?'Wednesday':(s==4)?'Thursday':(s==5)?'Friday':'Saturday',style: TextStyle(fontSize: 13,fontFamily:WorkSans.medium,color: (snapshot.data!=s)?PSColors.text_color:Colors.white),),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all((snapshot.data!=s)?Colors.white:PSColors.app_color),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5.0),
                                          side: BorderSide(color: PSColors.app_color)
                                      )
                                  )
                              )
                          )
                      );
                    },

                  ),
                );
              }
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: StreamBuilder<List<TimeTable>>(
                initialData: [],
                stream: _bloc.timeTableList,
                builder: (context, snapshot) {
                  return (snapshot.data!.isNotEmpty)?ListviewWidget(
                    onListUpdate: _bloc.onListUpdate,

                  ):NoData();
                }
              ),
            ),
          ),
          StreamBuilder<bool>(
              initialData: false,
              stream: _bloc.valid,
              builder: (c,s){
                if(s.data==true){
                  _bloc.get_time_table.add(null);
                }
                return SizedBox();

              })

        ],
      ),

    ),

    floatingActionButton: StreamBuilder<bool>(
      initialData: false,
      stream: _bloc.isFaculty,
      builder: (context, snapshot) {
        return(!snapshot.data!)? DraggableFab(child: FloatingActionButton(

        child: Icon(Icons.add,color:Colors.white,),

        backgroundColor: PSColors.app_color,
        foregroundColor: Colors.green,
        onPressed: () {

        Get.to(AppInjector.instance.addTimeTablePage(null))!.then((value) => _bloc.get_time_table.add(null));
        },
        ),

        ):SizedBox();
      }
    )
  );

  }

}