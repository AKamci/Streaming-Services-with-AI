import 'package:tv_series/src/constants/routes.dart';
import 'package:tv_series/src/screens/login/login.dart';

import 'screens/home/home_screen.dart';
import 'screens/shows/shows_screen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //final args = settings.arguments;
    switch (settings.name) {
      case homeScreenRoute:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case showScreenRoute:
        return MaterialPageRoute(builder: (context) => const ShowsScreen());
      case loginScreenRoute:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      default:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
    }
  }
}
