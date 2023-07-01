import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:publicschool_app/app/arch/bloc_provider.dart';
import 'package:publicschool_app/common/widgets/listview_widget/listview_widget.dart';
import 'package:publicschool_app/common/widgets/textfield/my_text_field.dart';
import 'package:publicschool_app/di/app_injector.dart';
import 'package:publicschool_app/di/i_subject_list.dart';
import 'package:publicschool_app/pages/dialogues/faculty_dialogue.dart';
import 'package:publicschool_app/pages/dialogues/student_dialogue.dart';
import 'package:publicschool_app/pages/dialogues/subject_dialogue.dart';
import 'package:publicschool_app/pages/students/bloc/add_student_bloc.dart';
import 'package:publicschool_app/utilities/fonts.dart';
import 'package:publicschool_app/utilities/ps_colors.dart';
import '../../common/widgets/load_container/load_container.dart';
import '../../model/subject/faculity_list.dart';
import '../dialogues/class_dialogue.dart';
import '../faculty/widgets/add_faculty.dart';
import 'bloc/subject_list_bloc.dart';

class Subjects extends StatefulWidget {
  const Subjects({Key? key}) : super(key: key);

  @override
  _SubjectState createState() => _SubjectState();

}
class _SubjectState extends State<Subjects> {
  late SubjectListBloc _bloc;
  late AddStudentBloc bloc;
  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _bloc.getData();

  }

  Widget build(BuildContext context) {
    return LoaderContainer(
      stream: _bloc.isLoading,
      child: StreamBuilder<String>(
          initialData: '',
          stream: _bloc.title,
          builder: (context, snapshot) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: PSColors.app_color,
                centerTitle: true,
                title: Text(snapshot.data!,style: TextStyle(fontFamily:WorkSans.semiBold ,),),

              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyTextField(
                      hintText: 'search',
                      onChange: (value){
                      _bloc.onSearch(value);
                      },
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Expanded(
                      child: ListviewWidget(
                        onListUpdate: _bloc.onListUpdate,

                      )


                  ),
                ],
              ),
              floatingActionButton: DraggableFab(child: FloatingActionButton(

                child: Icon(Icons.add,color:Colors.white,),

                backgroundColor: PSColors.app_color,
                foregroundColor: Colors.green,
                onPressed: () {
                  (snapshot.data == "Faculty") ?
                  Get.to(AppInjector.instance.addFaculty(null))!.then((value) {
                    _bloc.getData();
                  }) :(snapshot.data == "Students") ?  Get.to(AppInjector.instance.studentAdd(null))!.then((value) =>_bloc.getData()) :
                  Get.dialog(
                    (snapshot.data == "Subjects") ? AddSubject(
                        listBloc: _bloc) : (snapshot.data == "Classes")
                        ? onFacultyInfo('faculityList')
                        : const SizedBox(),
                  );

                },
              ),
                
              ),


            );
          }
      ),
    );
  }
  onFacultyInfo(String type) {
    _bloc.getFacultyList(type);
    if (type == "subjectList") {
      // Navigator.push(context, MaterialPageRoute(builder: (context)=> AddFaculty(facultyList: null,))).then((value) {
      //   _bloc.getData();
      // });
      Get.to(AppInjector.instance.addFaculty(null))!.then((value) {
        _bloc.getData();
      });

    } else if (type == "studentList") {
      //Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddStudent()));
      Get.to(AppInjector.instance.studentAdd(null))!.then((value) => _bloc.getData());

    }
    else{
      return StreamBuilder<List<FaculityList>>(
          initialData: [],
          stream: _bloc.faculityList,
          builder: (c, s) {
            return (s.data!.isNotEmpty) ?
            AddClass(listBloc: _bloc, facultyList: s.data!) : const SizedBox();
          });
    }
  }
}