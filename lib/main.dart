import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smoments/domain/provider/auth_provider.dart';
import 'package:smoments/domain/provider/post_provider.dart';
import 'package:smoments/domain/provider/preferences_provider.dart';
import 'package:smoments/domain/provider/stories_provider.dart';
import 'package:smoments/res/colors.dart';
import 'package:smoments/routes/router.dart';
import 'package:smoments/utils/helper/preference_helper.dart';

import 'data/remote/api/api_service.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: ThemeColors.primaryColor,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AuthProvider(apiService: ApiService()),
          ),
          ChangeNotifierProvider(
              create: (_) => PreferencesProvider(
                  preferencesHelper: PreferencesHelper(
                      sharedPreferences: SharedPreferences.getInstance()))),
          ChangeNotifierProvider(
              create: (_) => StoriesProvider(
                  apiService: ApiService(),
                  preferencesHelper: PreferencesHelper(
                      sharedPreferences: SharedPreferences.getInstance()))),
          ChangeNotifierProvider(
              create: (_) => PostProvider(
                  apiService: ApiService(),
                  preferenceHelper: PreferencesHelper(
                      sharedPreferences: SharedPreferences.getInstance()))),
        ],
        child: MaterialApp.router(
          title: "SMoments",
          theme: ThemeData(
            primaryColor: ThemeColors.primaryColor,
            bottomSheetTheme: const BottomSheetThemeData(
              backgroundColor: Colors.white
            ),
          ),
          routerConfig: router,
        ));
  }
}
