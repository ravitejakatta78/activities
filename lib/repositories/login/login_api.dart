import 'package:get/get_connect/http/src/response/response.dart';
import 'package:publicschool_app/model/login/login_data.dart';
import 'package:publicschool_app/model/login/login_response.dart';
import 'package:publicschool_app/repositories/base/base_api_service.dart';
import 'package:publicschool_app/repositories/end_point/end_point.dart';
import 'package:publicschool_app/repositories/base/refreshable_api.dart';

import '../../helper/logger/logger.dart';
import '../../model/base_response/request_response.dart';
import 'dart:async';

import 'package:dio/dio.dart';
abstract class LoginAPI{
  Future<RequestResponse<LoginResponse>> login(LoginData data);
}
class LoginService extends BaseAPIService implements LoginAPI{
  LoginService();
  @override
  Future<RequestResponse<LoginResponse>> login(LoginData data) {
    printLog("login",data.toMap());
    return make(RequestType.POST, EndPoints.login, body: data.toJson(),contentType: ContentType.json)
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
