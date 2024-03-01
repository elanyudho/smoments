import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:smoments/screens/detail_screen.dart';
import 'package:smoments/screens/home_screen.dart';
import 'package:smoments/screens/location_screen.dart';
import 'package:smoments/screens/login_screen.dart';
import 'package:smoments/screens/post_story_screen.dart';
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
      routes: <RouteBase> [
        GoRoute(
          path: pathDetail,
          name: nameDetail,
          builder: (context, state) {
            return const DetailScreen();
          },
          routes: <RouteBase> [
            GoRoute(
              path: pathLocation,
              name: nameLocation,
              builder: (BuildContext context, GoRouterState state) {
                var name = state.uri.queryParameters['name']!;
                var caption = state.uri.queryParameters['caption']!;
                var long = double.parse(state.uri.queryParameters['long']!);
                var lat = double.parse(state.uri.queryParameters['lat']!);
                return LocationScreen(name: name, caption: caption, long: long, lat: lat);
              },
            )
          ]
        ),
        GoRoute(
          path: pathPostStory,
          name: namePostStory,
          builder: (BuildContext context, GoRouterState state) {
            return const PostStoryScreen();
          },
        )
      ],
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
const pathDetail = 'detail';
const nameDetail = 'detail';
const pathPostStory = 'postStory';
const namePostStory = 'postStory';
const pathLocation = 'location';
const nameLocation = 'location';

