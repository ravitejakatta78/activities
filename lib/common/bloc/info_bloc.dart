
import 'package:intl/intl.dart';
import 'package:publicschool_app/app/arch/bloc_provider.dart';
import 'package:publicschool_app/model/subject/student_list.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

import '../../helper/logger/logger.dart';
import '../../manager/user_data_store/user_data_store.dart';
import '../../model/dairy/dairy_list.dart';
import '../../model/dashboard/dashboard_data.dart';
import '../../model/exams/exams_data.dart';
import '../../model/exams/exams_item.dart';
import '../../model/login/login_response.dart';
import '../../model/sections/sections_data.dart';
import '../../model/subject/subject_list_data.dart';
import '../../repositories/menu_list/subject_api.dart';
import '../widgets/bottom_sheet/calende_bottom_sheet.dart';
import '../widgets/bottom_sheet/classes_bottom_sheet.dart';
import '../widgets/bottom_sheet/sections_bottom_sheet.dart';
import '../widgets/container_widget/container_widget.dart';

class InfoBloc extends BlocBase{
  SubjectService? subjectService;
  UserDataStore? _userDataStore;
  Dairy? dairy;
  String? type;

   BehaviorSubject<bool> _isLoading=BehaviorSubject.seeded(false);

   BehaviorSubject<int> _selectedPosition = BehaviorSubject.seeded(0);
   PublishSubject<List<ClassList>> _classList=PublishSubject();
   BehaviorSubject<String> _className=BehaviorSubject();
   PublishSubject<List<SubjectList>> _subjectList=PublishSubject();
   BehaviorSubject<String> _sectionName=BehaviorSubject();
   PublishSubject<List<SectionsList>> _sectionsList=PublishSubject();
   PublishSubject<List<StudentList>> _studentList=PublishSubject();

   BehaviorSubject<String> _classId=BehaviorSubject.seeded("");
   BehaviorSubject<String> _sectionId=BehaviorSubject.seeded("");
   BehaviorSubject<String> _studentId=BehaviorSubject.seeded("");
   BehaviorSubject<String> _startDate=BehaviorSubject.seeded("Start Date");
   BehaviorSubject<String> _endDate=BehaviorSubject.seeded("End Date");
   BehaviorSubject<Tuple2<bool,List<ContainerWithWidget>>> _content=BehaviorSubject();
   BehaviorSubject<String> _subject=BehaviorSubject();
   BehaviorSubject<String> _subjectId=BehaviorSubject();
   BehaviorSubject<int> _subjectCount=BehaviorSubject.seeded(1);
   BehaviorSubject<String> _errorMsg=BehaviorSubject.seeded("");

  Stream<int> get subjectCount => _subjectCount;
  Sink<int> get addSubjectCount => _subjectCount;

  Stream<String> get subject => _subject;
  Sink<String> get addSubject => _subject;
  Stream<String> get subjectId => _subjectId;
  Sink<String> get addSubjectId => _subjectId;
  Stream<Tuple2<bool,List<ContainerWithWidget>>> get onListUpdate => _content;
  Stream<List<SectionsList>> get sectionsList => _sectionsList;
  Stream<List<StudentList>> get studentList => _studentList;

  Stream<int> get selectedPosition  => _selectedPosition;
  Sink<int> get selectedPos => _selectedPosition;

  Stream<bool> get isLoading => _isLoading;
  Sink<bool> get addLoading => _isLoading;
  Stream<List<ClassList>> get classList => _classList;
  Stream<String> get class_name => _className;
  Sink<String> get addClass => _className;
  Stream<String> get sectionName => _sectionName;
  Sink<String> get addSection => _sectionName;

  Stream<String> get getClassId  => _classId;
  Sink<String> get addClassId => _classId;
  Stream<String> get getSectionId  => _sectionId;
  Sink<String> get addSectionId => _sectionId;
  Stream<String> get getStudentId  => _studentId;
  Sink<String> get addStudentId => _studentId;
  Stream<String> get startDateStream => _startDate;
  Sink<String> get addStartDate => _startDate;
  Stream<List<SubjectList>> get subjectList => _subjectList;
  Stream<String> get endDateStream => _endDate;
  Sink<String> get addEndDate => _endDate;
  String? startDate=new DateFormat('yyyy-MM-dd').format(new DateTime.now());
  String? endDate=new DateFormat('yyyy-MM-dd').format(new DateTime.now());
  String? classId="-1";
  String? section="-1";
  String? subjectid="";
  String userId="";
  String? subjectName="";

  InfoBloc(this.subjectService,this._userDataStore,this.type,this.dairy){
    
  }
  void getClassList(Map<String, String?> map,int type) async {
    UserDetails? userDetails=await  _userDataStore?.getUser();
    String userId=userDetails!.usersid!;
    map.addAll({"usersid":userId});
    subjectService!.getRequest(map).then((value) {
      _isLoading.add(false);
      if(value.error==null){
        if(value.data!.status=="200"){
          if(value.data!.classList!=null){
            if(value.data!.classList!.isNotEmpty){
              if(dairy!=null){
                addClass.add(dairy!.className!);
                addClassId.add(dairy!.classId!);
                getSections({"action":"section-list","class_id":dairy!.classId!},2);
                // getSections(dairy!.classId!);
              }else{
                if(type==0){
                  openClassBottomSheet(classList:value.data!.classList!,onCallback:(classList) {
                    //getUsers({'action':'studentList','class_id':classList.classId,'usersid':userId});
                    classId=classList.classId;
                    _classId.add(classId.toString());
                    _className.add(classList.className!);
                    printLog("classList", classList.className);
                  },selectedPos: int.parse(classId!));
                  _classList.add(value.data!.classList!);
                }else if(type==2){
                 // addClass.add(value.data!.classList![0].className!);
                  addClassId.add(value.data!.classList![0].classId!);
                  getSections({"action":"section-list","class_id":value.data!.classList![0].classId!},2);

                } else{
                  getSections({"action":"section-list","class_id":value.data!.classList![0].classId!},1);
                }
              }
              _classList.add(value.data!.classList!);
              printLog('classList',value.data!.classList);

            }

          }
        } else _errorMsg.add('Invalid');
      }else _errorMsg.add('Invalid');
    });
  }
  void getSections(Map<String, String?> map,int type) async {
    UserDetails? userDetails=await  _userDataStore?.getUser();
    String userId=userDetails!.usersid!;
    if(type==0)
      map.addAll({"usersid":userId,"class_id":classId});
    else map.addAll({"usersid":userId});

    subjectService!.getRequest(map).then((value) {
      _isLoading.add(false);
      if(value.error==null){
        if(value.data!.status=="200"){
          if(value.data!.sectionList!=null){
            if(value.data!.sectionList!.isNotEmpty){
              _sectionsList.add(value.data!.sectionList!);
            //  _sectionName.add(value.data!.sectionList![0].sectionName!);
              _sectionId.add(value.data!.sectionList![0].sectionId!);
              // section=value.data!.sectionList![0].sectionId;
              if(type==0){
                sectionsBottomSheet(sectionsList:value.data!.sectionList!,onCallback:(sectionData) {
                  section=sectionData.sectionId;
                  _sectionId.add(section.toString());
                  printLog("SectionName", sectionData.sectionName);
                },selectedPos: int.parse(section!));
              }else if(type==2){
                if(dairy==null){
                 // addSection.add(value.data!.sectionList![0].sectionName!);
                  addSectionId.add(value.data!.sectionList![0].sectionId!);
                }else{
                  addSection.add(dairy!.sectionName!);
                  addSectionId.add(dairy!.sectionId!);
                }
              } else{
                getSubjects();
              }
            }else{
              _sectionsList.add([]);
            //  _sectionName=BehaviorSubject();
              _sectionId.add('');
            }
          }
        } else _errorMsg.add('Invalid');
      }else _errorMsg.add('Invalid');
    });
  }
  void getSubjects() async{
    UserDetails? userDetails=await  _userDataStore?.getUser();
    printLog("userDetails", userDetails?.userName);
    _isLoading.add(true);
    subjectService!.subjectList(DashboardData('subjectList', userDetails!.usersid)).then((value) {
      _isLoading.add(false);
      if(value.error==null){
        if(value.data!.status=="200"){
          if(value.data!.subjectList!=null){
            if(value.data!.subjectList!.isNotEmpty){
              _subjectList.add(value.data!.subjectList!);
              if(dairy==null){
                //addSubject.add(value.data!.subjectList![0].subjectName!);
                addSubjectId.add(value.data!.subjectList![0].id!);
              }else{
                addSubject.add(dairy!.subjectName!);
                addSubjectId.add(dairy!.sectionId!);
              }
            }
          }

        } else _errorMsg.add('Invalid');
      }else _errorMsg.add('Invalid');
    });
  }
  void getStudents() async{
    UserDetails? userDetails=await  _userDataStore?.getUser();
    printLog("userDetails", userDetails?.userName);
    _isLoading.add(true);
    subjectService!.subjectList(DashboardData('studentList', userDetails!.usersid)).then((value) {
      _isLoading.add(false);
      if(value.error==null){
        if(value.data!.status=="200"){
          if(value.data!.studentList!=null){
            if(value.data!.studentList!.isNotEmpty){
              _studentList.add(value.data!.studentList!);
              _studentId.add(value.data!.studentList![0].id!);
            }
          }
        } else _errorMsg.add('Invalid');
      }else _errorMsg.add('Invalid');
    });
  }

  getStateDate(int type){
    calenderBottomSheet(onCallback: (dateTime){
      startDate=dateTime.toString();
      addStartDate.add(startDate!);
    },selectedDate:DateTime.parse(startDate!),type:type );

  }
  getEndDate(int type){
    calenderBottomSheet(onCallback: (dateTime){
      endDate=dateTime.toString();
      addEndDate.add(endDate!);
    },selectedDate:DateTime.parse(endDate!),type:type );

  }
}
    