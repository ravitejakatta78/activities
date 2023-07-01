

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:publicschool_app/common/widgets/bottom_sheet/calende_bottom_sheet.dart';
import 'package:publicschool_app/common/widgets/container_widget/container_widget.dart';
import 'package:publicschool_app/common/widgets/dropdown/custom_dropdown.dart';
import 'package:publicschool_app/common/widgets/dropdown/white_dropdown.dart';
import 'package:publicschool_app/common/widgets/load_container/load_container.dart';
import 'package:publicschool_app/pages/leaves/bloc/leave_request_bloc.dart';

import '../../app/arch/bloc_provider.dart';
import '../../utilities/fonts.dart';
import '../../utilities/ps_colors.dart';
import 'bloc/leave_management_bloc.dart';

class LeaveRequest extends StatefulWidget {

  @override
  LeaveRequestState createState() => LeaveRequestState();
}
class LeaveRequestState extends State<LeaveRequest>{
  final List<String> leaveType = ['Leave Type','Annual Leave', 'Sick Leave','Others'];
  LeaveRequestBloc?  _bloc;
  @override
  void initState() {
    super.initState();
    _bloc=BlocProvider.of(context);
    _bloc!.addLeaveType.add(leaveType[0]);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PSColors.bg_color,
     appBar: AppBar(
      backgroundColor: PSColors.app_color,
      centerTitle: true,
      title: const Text('Leaves Request',style:TextStyle(fontFamily: WorkSans.semiBold,fontSize: 20)),
    ),
      body: LoaderContainer(
        stream: _bloc?.isLoading,
        child: Container(
          padding: EdgeInsets.all(20),
          child: ListView(
            children: [
              StreamBuilder<String>(
                  initialData: '',
                  stream: _bloc?.leaveType,
                  builder: (context, b) {
                    return (b.data!.isNotEmpty) ? WhiteDropdown(
                      hint: 'Leave Type',
                      dropdownItems: leaveType,
                      buttonHeight: 57,
                      value: b.data,
                      onChanged: (String? value) {
                        if(value!="Leave Type")
                        _bloc?.addLeaveType.add(value!);
                      },
                    ) : const SizedBox();
                  }
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 5,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width/2.4,
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
                        _bloc?.getStateDate(2);
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
                      width: MediaQuery.of(context).size.width/2.4,
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
                      _bloc?.getEndDate(2);
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
                ],
              ),
              SizedBox(height: 25,),
              Container(
                height: 50,
                child: StreamBuilder<int>(
                  initialData: 0,
                  stream: _bloc?.leaveSection,
                  builder: (c,s){
                    return Row(
                      children: [
                        Expanded(
                          flex:1,
                            child: SizedBox(
                          height: 57,
                          child: ElevatedButton(
                            child: Text('Full Day',style: TextStyle(color: PSColors.text_color)),
                            style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                backgroundColor: MaterialStateProperty.all<Color>((s.data==0)? PSColors.app_color_lite:Colors.white),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft:Radius.circular(10.0),
                                            bottomLeft: Radius.circular(10.0)
                                        ),
                                        side: BorderSide(color: (s.data==0)? PSColors.app_color_lite:PSColors.app_color_lite,width: 1)
                                    )
                                )
                            ), onPressed: () { _bloc?.addLeaveSection.add(0); },
                          ),
                        )),
                        Expanded( flex:1,child: SizedBox(
                          height: 57,
                          child: ElevatedButton(
                            child: Text('Half Day',style: TextStyle(color: PSColors.text_color),),
                            style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                backgroundColor: MaterialStateProperty.all<Color>((s.data==1)? PSColors.app_color_lite:Colors.white),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topRight:Radius.circular(10.0),
                                            bottomRight: Radius.circular(10.0)
                                        ),
                                        side: BorderSide(color: (s.data==1)? PSColors.app_color_lite:PSColors.app_color_lite,width: 1)
                                    )
                                )
                            ), onPressed: () { _bloc?.addLeaveSection.add(1); },
                          ),
                        ))
                      ],
                    );


                  },
                ),
              ),
              SizedBox(height: 25,),
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 6,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Reason'
                  ),
                onChanged: (value){

                    _bloc?.addReason.add(value);
                },

                ),
              ),
              SizedBox(height: 25,),
              SizedBox(
                height: 50,
                child: ElevatedButton(onPressed: (){
                   _bloc?.submit();
                },style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(PSColors.text_color),
                    backgroundColor: MaterialStateProperty.all<Color>(PSColors.app_color_lite),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side:  BorderSide(color: PSColors.app_color_lite))
                    )
                ),
                    child: Text("Submit Request",style: TextStyle(fontSize: 16,fontFamily: WorkSans.semiBold,color: PSColors.text_color),)),
              )



            ],
          ),

        ),
      ),
    );
  }



}