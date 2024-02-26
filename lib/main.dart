import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smoments/domain/provider/auth_provider.dart';
import 'package:smoments/domain/provider/preferences_provider.dart';
import 'package:smoments/res/colors.dart';
import 'package:smoments/routes/router.dart';
import 'package:smoments/utils/helper/preference_helper.dart';

import 'data/remote/api/api_service.dart';

void main() {
  runApp(const MyApp());
  /*runApp(DevicePreview(
      enabled: true,
      tools: const [...DevicePreview.defaultTools],
      builder: (context) => const MyApp()));*/
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ThemeColors.primaryColor, // Set the status bar color
    ));
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AuthProvider(apiService: ApiService()),
          ),
          ChangeNotifierProvider(create: (_) => PreferencesProvider(preferencesHelper: PreferencesHelper(sharedPreferences: SharedPreferences.getInstance())))
        ],
        child: MaterialApp.router(
          title: "SMoments",
          theme: ThemeData(
              primaryColor: ThemeColors.primaryColor),
          routerConfig: router,
        ));
  }
}
