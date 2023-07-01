import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:publicschool_app/common/widgets/textfield/my_text_field.dart';
import 'package:publicschool_app/pages/subject/bloc/subject_list_bloc.dart';

import '../../common/widgets/load_container/load_container.dart';
import '../../utilities/ps_colors.dart';

class AddSubject extends StatelessWidget {
  SubjectListBloc? listBloc;

   AddSubject({ this.listBloc});
  @override
  Widget build(BuildContext context) {

    listBloc?.action.add('add-subject');
    return AlertDialog(

      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18.0))),
      contentPadding: const EdgeInsets.all(20.0),
      backgroundColor: Colors.white,
      content: Container(
        height: 130,
        alignment: Alignment.center,
        child: LoaderContainer(
          stream: listBloc!.isLoading,
          child: Column(
            children: [
              MyTextField(hintText: 'Subject Name',
                  inputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  onChange: (value){
                    listBloc!.subject.add(value);
                  }
                  ),
              const SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.0),
                                side:  BorderSide(color: PSColors.app_color))
                        )
                    ),
                    child: Text('Cancel',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: PSColors.app_color),),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 20,),
                  ElevatedButton(
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(PSColors.app_color),
                        backgroundColor: MaterialStateProperty.all<Color>(PSColors.app_color),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.0),
                                side: BorderSide(color: PSColors.app_color))
                        )
                    ),
                    child: const Text('Submit',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.white),),

                    onPressed: () {

                     listBloc!.subject_submit.add(null);
                     Navigator.pop(context);

                    //  listBloc.postData({'action':'add-subject','subject':s.data},context);



                      // ;

                    },
                  ),


                ],
              )
            ],
          ),
        ),
      ),

    );
  }

}