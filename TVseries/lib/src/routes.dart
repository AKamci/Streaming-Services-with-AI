import 'package:tv_series/src/components/header_bar.dart';
import 'package:tv_series/src/components/navbar.dart';
import 'package:tv_series/src/constants/routes.dart';
import 'package:tv_series/src/screens/login/login.dart';
import 'package:tv_series/src/screens/login/widgets/whoWatching.dart';

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
        return MaterialPageRoute(builder: (context) {
          return _showsPage();
        });
      case loginScreenRoute:
        return MaterialPageRoute(builder: (context) {
          return _loginPage();
        });
      case whoIsWatchingRoute:
        return MaterialPageRoute(builder: (context) {
          return _whoIsWatchingPage();
        });
      default:
        return MaterialPageRoute(builder: (context) {
          return _loginPage();
        });
    }
  }

  static Widget _loginPage() {
    return const Scaffold(
      appBar: CustomHeaderBar(),
      drawer: NavBar(),
      body: LoginScreen(),
    );
  }

  static Widget _whoIsWatchingPage() {
    return const Scaffold(
      appBar: CustomHeaderBar(),
      drawer: NavBar(),
      body: WhoIsWatching(),
    );
  }

  static Widget _showsPage() {
    return const Scaffold(
      appBar: CustomHeaderBar(),
      drawer: NavBar(),
      body: ShowsScreen(),
    );
  }
}
