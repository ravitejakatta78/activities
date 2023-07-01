import 'package:get/get_connect/http/src/response/response.dart';
import 'package:publicschool_app/manager/user_data_store/user_data_store.dart';
import 'package:publicschool_app/model/dashboard/dashboard_data.dart';
import 'package:publicschool_app/model/dashboard/dashboard_response.dart';
import 'package:publicschool_app/model/login/login_data.dart';
import 'package:publicschool_app/model/login/login_response.dart';
import 'package:publicschool_app/repositories/base/base_api_service.dart';
import 'package:publicschool_app/repositories/end_point/end_point.dart';
import 'package:publicschool_app/repositories/base/refreshable_api.dart';

import '../../helper/logger/logger.dart';
import '../../model/base_response/request_response.dart';

abstract class DashboardAPI{
  Future<RequestResponse<DashboardResponse>> dashboard(Map<String, String?> data);
}
class DashboardService extends RefreshableService implements DashboardAPI{

  DashboardService(UserDataStore userDataStore):super(userDataStore);

  @override
  Future<RequestResponse<DashboardResponse>> dashboard(Map<String, String?> data) {
    return makeRefreshable(RequestType.GET, EndPoints.dashboard, params: data)
        .then((result) {
      if (result.data != null) {
        printLog("response", result.data);
        var data=DashboardResponse.fromJson(result.data);
        return RequestResponse(data: data);
      } else {
        printLog("response error", result.error!.error);
        return RequestResponse(error: result.error);
      }
    });
  }

}
