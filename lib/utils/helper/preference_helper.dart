import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smoments/data/remote/response/login_response.dart';


class PreferencesHelper {
  final Future<SharedPreferences> sharedPreferences;

  PreferencesHelper({required this.sharedPreferences});

  static const loginStatus = 'LOGIN_STATUS';
  static const userPref = 'USER';

  Future<bool> get isLogin async {
    final prefs = await sharedPreferences;
    return prefs.getBool(loginStatus) ?? false;
  }

  void setLoginStatus(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(loginStatus, value);
  }

  Future<LoginResult?> get user async {
    final prefs = await sharedPreferences;
    final jsonString = prefs.getString(userPref);
    if (jsonString != null) {
      return LoginResult.fromJson(json.decode(jsonString));
    }
    return null;
  }

  void setUser(LoginResult value) async {
    final prefs = await sharedPreferences;
    final jsonString = json.encode(value.toJson());
    prefs.setString(userPref, jsonString);
  }
}