import 'dart:async';

import 'package:dio/dio.dart';
import 'package:publicschool_app/manager/user_data_store/user_data_store.dart';
import 'package:publicschool_app/model/dashboard/dashboard_data.dart';
import 'package:publicschool_app/model/exams/exams_marks.dart';
import 'package:publicschool_app/model/exams/exams_schedule_data.dart';
import 'package:publicschool_app/model/faculty/faculty_list_data.dart';
import 'package:publicschool_app/model/login/login_response.dart';
import 'package:publicschool_app/model/subject/subject_list_data.dart';
import 'package:publicschool_app/repositories/base/base_api_service.dart';
import 'package:publicschool_app/repositories/end_point/end_point.dart';
import 'package:publicschool_app/repositories/base/refreshable_api.dart';

import '../../helper/logger/logger.dart';
import '../../model/base_response/request_response.dart';
import '../../model/dairy/dairy_list.dart';
import '../../model/fees/fee_types_list.dart';
import '../../model/fees/fees_list.dart';
import '../../model/leave/leaves_list.dart';
import '../../model/time_table/get_time_table.dart';

abstract class SubjectAPI{
  Future<RequestResponse<SubjectListData>> subjectList(DashboardData data);
  Future<RequestResponse<SubjectListData>> addData(Map<String,dynamic> data);
  Future<RequestResponse<FacultyListData>> getAttendanceData(Map<String,dynamic> data);
  Future<RequestResponse<ExamsMarksData>> getExamsMarksData(Map<String,dynamic> data);
  Future<RequestResponse<SubjectListData>> getRequest(Map<String,dynamic> data);
  Future<RequestResponse<LoginResponse>> getLogin(Map<String,dynamic> data);
  Future<RequestResponse<FeesList>> getFeesList(Map<String,dynamic> data);


}
class SubjectService extends RefreshableService implements SubjectAPI{

  SubjectService(UserDataStore userDataStore):super(userDataStore);
  @override
  Future<RequestResponse<SubjectListData>> subjectList(DashboardData data) {
    return makeRefreshable(RequestType.GET, EndPoints.getSubjects, params: data.toJson(),contentType: ContentType.json)
        .then((result) {
      if (result.data != null) {
        printLog("response", result.data);
        var data=SubjectListData.fromJson(result.data);
        return RequestResponse(data: data);
      } else {
        printLog("response error", result.error!.error);
        return RequestResponse(error: result.error);
      }
    });
  }

  @override
  Future<RequestResponse<SubjectListData>> addData(Map<String,dynamic> data) {
    return makeRefreshable(RequestType.POST, EndPoints.addData, body: data,contentType: ContentType.json)
        .then((result) {
      if (result.data != null) {
        printLog("response", result.data);
        var data=SubjectListData.fromJson(result.data);
        return RequestResponse(data: data);
      } else {
        printLog("response error", result.error!.error);
        return RequestResponse(error: result.error);
      }
    });
  }

  @override
  Future<RequestResponse<SubjectListData>> getRequest(Map<String,dynamic> data) {
    return makeRefreshable(RequestType.GET, EndPoints.getSubjects, params: data,contentType: ContentType.json)
        .then((result) {
      if (result.data != null) {
        printLog("response", result.data);
        var data=SubjectListData.fromJson(result.data);
        return RequestResponse(data: data);
      } else {
        printLog("response error", result.error!.error);
        return RequestResponse(error: result.error);
      }
    });
  }

  @override
  Future<RequestResponse<SubjectListData>> addImageData(Future<FormData> mapvalues) async {
    FormData data = await mapvalues;
    printLog("Mapvalues", mapvalues);

    return makeRefreshable(RequestType.POST, EndPoints.addData, body: data,contentType: ContentType.multipart)
        .then((result) {
      if (result.data != null) {
        printLog("response", result.data);

        var data = SubjectListData.fromJson(result.data);
        return RequestResponse(data: data);
      } else {
        printLog("response error", result.error!.error);
        return RequestResponse(error: result.error);
      }
    });
  }

  @override
  Future<RequestResponse<LeavesList>> getLeaveList(Map<String,dynamic> data) {
    return makeRefreshable(RequestType.GET, EndPoints.getSubjects, params: data,contentType: ContentType.json)
        .then((result) {
      if (result.data != null) {
        printLog("response", result.data);
        var data=LeavesList.fromJson(result.data);
        return RequestResponse(data: data);
      } else {
        printLog("response error", result.error!.error);
        return RequestResponse(error: result.error);
      }
    });
  }
  @override
  Future<RequestResponse<FeesList>> getFeesList(Map<String,dynamic> data) {
    return makeRefreshable(RequestType.GET, EndPoints.getSubjects, params: data,contentType: ContentType.json)
        .then((result) {
      if (result.data != null) {
        printLog("response", result.data);
        var data=FeesList.fromJson(result.data);
        return RequestResponse(data: data);
      } else {
        printLog("response error", result.error!.error);
        return RequestResponse(error: result.error);
      }
    });
  }

  @override
  Future<RequestResponse<FacultyListData>> getAttendanceData(Map<String, dynamic> data) {
    return makeRefreshable(RequestType.GET, EndPoints.getSubjects, params: data,contentType: ContentType.json)
        .then((result) {
      if (result.data != null) {
        printLog("response", result.data);
        var data=FacultyListData.fromJson(result.data);
        return RequestResponse(data: data);
      } else {
        printLog("response error", result.error!.error);
        return RequestResponse(error: result.error);
      }
    });
  }

  @override
  Future<RequestResponse<ExamsMarksData>> getExamsMarksData(Map<String, dynamic> data) {
    return makeRefreshable(RequestType.GET, EndPoints.getSubjects, params: data,contentType: ContentType.json)
        .then((result) {
      if (result.data != null) {
        printLog("response", result.data);
        var data=ExamsMarksData.fromJson(result.data);
        return RequestResponse(data: data);
      } else {
        printLog("response error", result.error!.error);
        return RequestResponse(error: result.error);
      }
    });
  }
  @override
  Future<RequestResponse<TimeTableList>> getTimeTable(Map<String,dynamic> data) {
    return makeRefreshable(RequestType.GET, EndPoints.getSubjects, params: data,contentType: ContentType.json)
        .then((result) {
      if (result.data != null) {
        printLog("response", result.data);
        var data=TimeTableList.fromJson(result.data);
        return RequestResponse(data: data);
      } else {
        printLog("response error", result.error!.error);
        return RequestResponse(error: result.error);
      }
    });
  }

  @override
  Future<RequestResponse<DairyList>> getDairy(Map<String,dynamic> data) {
    return makeRefreshable(RequestType.GET, EndPoints.getSubjects, params: data,contentType: ContentType.json)
        .then((result) {
      if (result.data != null) {
        printLog("response", result.data);
        var data=DairyList.fromJson(result.data);
        return RequestResponse(data: data);
      } else {
        printLog("response error", result.error!.error);
        return RequestResponse(error: result.error);
      }
    });
  }


  @override
  Future<RequestResponse<ExamsScheduleData>> getExamsScheduleData(Map<String, dynamic> data) {
    return makeRefreshable(RequestType.GET, EndPoints.getSubjects, params: data,contentType: ContentType.json)
        .then((result) {
      if (result.data != null) {
        printLog("response", result.data);
        var data=ExamsScheduleData.fromJson(result.data);
        return RequestResponse(data: data);
      } else {
        printLog("response error", result.error!.error);
        return RequestResponse(error: result.error);
      }
    });
  }
  @override
  Future<RequestResponse<FeesTypesList>> getFeesTypesList(Map<String, dynamic> data) {
    return makeRefreshable(RequestType.GET, EndPoints.getSubjects, params: data,contentType: ContentType.json)
        .then((result) {
      if (result.data != null) {
        printLog("response", result.data);
        var data=FeesTypesList.fromJson(result.data);
        return RequestResponse(data: data);
      } else {
        printLog("response error", result.error!.error);
        return RequestResponse(error: result.error);
      }
    });
  }

  @override
  Future<RequestResponse<LoginResponse>> getLogin(Map<String, dynamic> data) {
    return makeRefreshable(RequestType.GET, EndPoints.getSubjects, params: data,contentType: ContentType.json)
        .then((result) {
      if (result.data != null) {
        printLog("response", result.data);
        var data=LoginResponse.fromJson(result.data);
        return RequestResponse(data: data);
      } else {
        printLog("response error", result.error!.error);
        return RequestResponse(error: result.error);
      }
    });
  }

}
