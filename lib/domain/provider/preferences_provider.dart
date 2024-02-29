import 'package:flutter/cupertino.dart';
import 'package:smoments/data/remote/response/login_response.dart';

import '../../utils/helper/preference_helper.dart';

class PreferencesProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;

  PreferencesProvider({required this.preferencesHelper});

  bool _isLogin = false;

  bool get isLogin => _isLogin;

  LoginResult _user = LoginResult(userId: '', name: '', token: '');

  LoginResult get user => _user;

  void getLoginStatus() async {
    _isLogin = await preferencesHelper.isLogin;
    notifyListeners();
  }

  void setLoginStatus(bool value) {
    preferencesHelper.setLoginStatus(value);
    getLoginStatus();
  }

  void _getUser() async {
    _user = (await preferencesHelper.user)!;
    notifyListeners();
  }

  void setUser(LoginResult value) {
    preferencesHelper.setUser(value);
    _getUser();
  }

  void setLogout() {
    setLoginStatus(false);
    setUser(LoginResult(userId: '', name: '', token: ''));
  }
}