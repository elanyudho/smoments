import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:smoments/screens/home_screen.dart';
import 'package:smoments/screens/login_screen.dart';
import 'package:smoments/screens/register_screen.dart';
import 'package:smoments/screens/splash_screen.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase> [
    GoRoute(path: pathSplash, builder: (BuildContext context, GoRouterState state) {
      return const SplashScreen();
    }),
    GoRoute(
      path: pathHome,
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: pathRegister,
      builder: (BuildContext context, GoRouterState state) {
        return const RegisterScreen();
      },
    ),
    GoRoute(
      path: pathLogin,
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    )
  ]
);

const pathSplash = '/';
const pathHome = '/home';
const pathRegister = '/register';
const pathLogin = '/login';

