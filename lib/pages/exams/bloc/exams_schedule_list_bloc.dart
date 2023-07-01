
import 'package:publicschool_app/model/exams/exams_schedule_data.dart';
import 'package:rxdart/rxdart.dart';

import '../../../app/arch/bloc_provider.dart';
import '../../../manager/user_data_store/user_data_store.dart';
import '../../../model/exams/exams_data.dart';
import '../../../model/login/login_response.dart';
import '../../../repositories/menu_list/subject_api.dart';

typedef BlocProvider<ExamsScheduleListBloc> ExamsScheduleListFactory(String type,ExamsList examsList);
class ExamsScheduleListBloc extends BlocBase {
  SubjectService? subjectService;
  UserDataStore? _userDataStore;
  String? type;
  ExamsList examsList;
  final BehaviorSubject<String> _errorMsg=BehaviorSubject.seeded("");
  final BehaviorSubject<bool> _isLoading = BehaviorSubject.seeded(false);
  final BehaviorSubject<ExamsList> _examsList=BehaviorSubject();
  Stream<String> get  errorMsg=> _errorMsg;
  Stream<bool> get isLoading => _isLoading;
  Stream<ExamsList> get getExamsList => _examsList;
  final PublishSubject<List<ExamScheduleList>> _examsSchedule=PublishSubject();
  Stream<List<ExamScheduleList>> get examsSchedule => _examsSchedule;

  ExamsScheduleListBloc(this.type,this.subjectService,this._userDataStore,this.examsList){
    _examsList.add(examsList);
    getExamsSchedule();
  }
  void getExamsSchedule() async{
    _isLoading.add(true);
    UserDetails? userDetails=await  _userDataStore?.getUser();
    String userId=userDetails!.usersid!;
    Map<String,dynamic> map={};
    map.addAll({
      'action': 'examScheduleList',
      'usersid': userId,
      'exam_id':examsList.examId,
      'exam_name': examsList.examName,
      'class_name':examsList.className,
    });
    subjectService!.getExamsScheduleData(map).then((value) {
      _isLoading.add(false);
      if(value.data!.status=="200") {
        if(value.data!.examScheduleList!=null){
          if(value.data!.examScheduleList!.isNotEmpty){
            _examsSchedule.add(value.data!.examScheduleList!);
          }
        }

      }
    });

  }

}