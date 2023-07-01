import 'dart:async';

import 'package:publicschool_app/model/login/login_response.dart';
import 'package:rxdart/rxdart.dart';
import '../../helper/logger/logger.dart';
import '../data_base/db_manager.dart';

class UserDataStore {
  final DBManager _dbManager;
  UserDetails? _user;

  BehaviorSubject<void> _permissionChanged = BehaviorSubject();

  Stream<void> get permissionChanged => _permissionChanged;

  UserDataStore(this._dbManager);

  Future<UserDetails?> getUser() async {
    // TODO: add user caching mechanism to no open DB everytime app needs user
    // This was commented because of the issue with user avatar update
    // if (_user != null) return Future.value(_user);

    final user = await _dbManager.queryAllRows<UserDetails>();

    if (user.isNotEmpty) {
      Map<String, dynamic> userMap = Map.from(user.first);

      _user = UserDetails.fromJson(userMap);
      return _user;
    } else {
      return null;
    }
  }


  Future<int> insert(UserDetails u) async {
    printLog("APPLOG", "Insert message");
    await _dbManager.delete<UserDetails>();
    final userJson = u.toJson();

    return _dbManager.insert<UserDetails>(userJson);
  }
  Future<int> update(UserDetails u) async {
    printLog("APPLOG", "Insert message");
    await _dbManager.delete<UserDetails>();
    final userJson = u.toJson();
    return _dbManager.update<UserDetails>(userJson);
  }


  Future<int> deleteUser() async {
    _user = null;

    return _dbManager.delete<UserDetails>();
  }


}