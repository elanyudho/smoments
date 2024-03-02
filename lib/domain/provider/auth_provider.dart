import 'package:flutter/cupertino.dart';
import 'package:smoments/data/remote/response/default_response.dart';
import 'package:smoments/data/remote/response/login_response.dart';

import '../../data/remote/api/api_service.dart';

class AuthProvider extends ChangeNotifier {

  final ApiService apiService;

  AuthProvider ({required this.apiService});

  late LoginResult _loginResult;
  late DefaultResponse _registerResult;

  bool isLoadingRegister = false;
  bool isLoadingLogin= false;

  LoginResult get loginResult => _loginResult;

  DefaultResponse get registerResult => _registerResult;
  LoginResult get loginresult => _loginResult;

  Future<dynamic> postRegister(String name, String email, String password) async {
    isLoadingRegister = true;
    notifyListeners();
    try {
      final result = await apiService.postRegister(name, email, password);
      isLoadingRegister = false;
      notifyListeners();
      return result;
    } catch(e) {
      isLoadingRegister = false;
      notifyListeners();
      return DefaultResponse(error: true, message: e.toString());
    }

  }

  Future<dynamic> postLogin(String email, String password) async {
    isLoadingLogin = true;
    notifyListeners();
    try {
      final result = await apiService.postLogin(email, password);
      isLoadingLogin = false;
      notifyListeners();
      return result;
    } catch(e) {
      isLoadingLogin = false;
      notifyListeners();
      return DefaultResponse(error: true, message: e.toString());
    }

  }



}