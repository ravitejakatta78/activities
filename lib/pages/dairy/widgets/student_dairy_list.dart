
import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:publicschool_app/common/widgets/load_container/load_container.dart';
import 'package:publicschool_app/di/app_injector.dart';
import 'package:publicschool_app/di/i_student_dairy.dart';
import 'package:publicschool_app/model/dairy/dairy_list.dart';

import '../../../app/arch/bloc_provider.dart';
import '../../../common/widgets/listview_widget/listview_widget.dart';
import '../../../common/widgets/no_data/no_data.dart';
import '../../../model/login/login_response.dart';
import '../../../utilities/constants.dart';
import '../../../utilities/fonts.dart';
import '../../../utilities/ps_colors.dart';
import '../bloc/student_dairy_bloc.dart';

class StudentDairy extends StatefulWidget{

  @override
  StudentDairyState createState() => StudentDairyState();
}
class StudentDairyState extends State<StudentDairy>{

  String? roleId;
  late StudentDairyBloc _bloc;
  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _bloc.getClassList({"action":"classList"},0);
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
      appBar: AppBar(
        backgroundColor: PSColors.app_color,
        centerTitle: true,
        title: const Text('Student Dairy List',style:TextStyle(fontFamily: WorkSans.semiBold,fontSize: 20)),
      ),
      body: LoaderContainer(
          stream: _bloc.isLoading,
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
                      itemCount: 4,
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
                                      _bloc.getClassList({"action":"classList"},0);
                                    }else if(s==1){
                                      _bloc.getSections({"action":"section-list"},0);
                                    }else if(s==2){
                                      _bloc.getStateDate(1);
                                    }else {
                                      _bloc.getEndDate(2);
                                    }


                                  },
                                  label: Text((s==0)?'Classes':(s==1)?'Sections':(s==2)?'Start Date':'End Date',style: TextStyle(fontSize: 16,fontFamily:WorkSans.medium,color: (snapshot.data!=s)?PSColors.text_color:Colors.white),),
                                  icon: Icon((s==0)?Icons.menu_book_outlined:(s==1)?Icons.supervisor_account_outlined:
                                  (s==1)?Icons.calendar_today_rounded:Icons.calendar_today_rounded,size: 16,color: (snapshot.data!=s)?PSColors.app_color:Colors.white,),
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
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: StreamBuilder<List<Dairy>>(
                    initialData: [],
                    stream: _bloc.dairyList,
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
                    _bloc.get_dairy.add(null);
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
          return (snapshot.data!)?DraggableFab(child: FloatingActionButton(

            child: Icon(Icons.add,color:Colors.white,),

            backgroundColor: PSColors.app_color,
            foregroundColor: Colors.green,
            onPressed: () {

              Get.to(AppInjector.instance.addStudentDairyPage('',null))!.then((value) => _bloc.get_dairy.add(null));

            },
          ),

          ):SizedBox();
        }
      ),
    );


  }



}