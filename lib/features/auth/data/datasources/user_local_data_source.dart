import 'dart:convert';

import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserLocalDataSource {
  CubeUser? getUser();
  Future<bool> saveUser(CubeUser user);
  Future<bool> deleteUser();
}

const CacheUser = 'CacheUser';

class UserLocalDataSourceImp implements UserLocalDataSource {
  const UserLocalDataSourceImp({required this.sharedPreferences});
  final SharedPreferences sharedPreferences;

  @override
  CubeUser? getUser() {
    final jsonString = sharedPreferences.getString(CacheUser);

    if (jsonString != null) {
      return CubeUser.fromJson(json.decode(jsonString));
    }
  }

  @override
  Future<bool> saveUser(CubeUser user) {
    return sharedPreferences.setString(CacheUser, json.encode(user.toJson()));
  }

  @override
  Future<bool> deleteUser() async {
    return await sharedPreferences.remove(CacheUser);
  }
}
