import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tv_series/src/components/header_bar.dart';
import 'package:tv_series/src/components/navbar.dart';
import 'package:tv_series/src/constants/routes.dart';
import 'package:tv_series/src/screens/login_v2/login.dart';
import 'package:tv_series/src/screens/login_v2/widgets/whoWatching.dart';
import 'package:tv_series/src/screens/show_details/show_details_screen.dart';
import 'package:tv_series/src/screens/shows/shows_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: loginPageRoute,
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
        },
        routes: [
          GoRoute(
              path: '$showDetailsPageRoute:data',
              builder: (context, state) {
                return _showDetailsPage(
                    data: state.pathParameters['data'].toString());
              }),
        ]),
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

Widget _showDetailsPage({required String data}) {
  return Scaffold(
    appBar: const CustomHeaderBar(),
    drawer: const NavBar(),
    body: ShowInfoPage(),
  );
}
