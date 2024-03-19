import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tv_series/src/components/header_bar.dart';
import 'package:tv_series/src/components/navbar.dart';
import 'package:tv_series/src/constants/routes.dart';
import 'package:tv_series/src/screens/login_v2/login.dart';
import 'package:tv_series/src/screens/login_v2/widgets/whoWatching.dart';
import 'package:tv_series/src/screens/shows/shows_screen.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return _loginPage();
      },
      //routes: <RouteBase>[],
    ),
    GoRoute(
      path: homePageRoute,
      builder: (BuildContext context, GoRouterState state) {
        return _loginPage();
      },
    ),
    GoRoute(
        path: loginPageRoute,
        builder: (BuildContext context, GoRouterState state) {
          return _loginPage();
        }),
    GoRoute(
        path: whoIsWatchingPageRoute,
        builder: (BuildContext context, GoRouterState state) {
          return _whoIsWatchingPage();
        }),
    GoRoute(
        path: showsPageRoute,
        builder: (BuildContext context, GoRouterState state) {
          return _showsPage();
        }),
  ],
);

Widget _loginPage() {
  return const Scaffold(
    appBar: CustomHeaderBar(),
    drawer: NavBar(),
    body: LoginPage(),
  );
}

Widget _whoIsWatchingPage() {
  return const Scaffold(
    appBar: CustomHeaderBar(),
    drawer: NavBar(),
    body: WhoIsWatchingPage(),
  );
}

Widget _showsPage() {
  return const Scaffold(
    appBar: CustomHeaderBar(),
    drawer: NavBar(),
    body: ShowsPage(),
  );
}

/*
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
*/
