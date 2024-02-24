import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smoments/domain/provider/preferences_provider.dart';
import 'package:smoments/res/colors.dart';
import 'package:smoments/routes/router.dart';

import '../res/assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreen();

}

class _SplashScreen extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Provider.of<PreferencesProvider>(context, listen: false).getLoginStatus();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        startScreen();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: ThemeColors.primaryColor,
          child: Column(
            children: [
              Expanded(flex: 5, child: Container()),
              Expanded(
                flex: 1,
                child: Center(
                  child: SvgPicture.asset(assetLogo),
                ),
              ),
              Expanded(flex: 5, child: Container()),
            ],
          ),
        ),
      );

  }

    void startScreen() async {
      final prefRead = Provider.of<PreferencesProvider>(context, listen: false);
      final isLogin = prefRead.isLogin;

      if (isLogin) {
        context.go(pathHome);
      } else {
        context.go(pathLogin);
      }
    }
}
