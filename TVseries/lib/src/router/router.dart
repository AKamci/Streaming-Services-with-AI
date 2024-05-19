import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tv_series/src/components/header_bar.dart';
import 'package:tv_series/src/components/navbar.dart';
import 'package:tv_series/src/constants/routes.dart';
import 'package:tv_series/src/models/media.dart';
import 'package:tv_series/src/screens/login/login_screen.dart';
import 'package:tv_series/src/screens/profile_selection/profile_selection_screen.dart';
import 'package:tv_series/src/screens/show_details/show_details_screen.dart';
import 'package:tv_series/src/screens/shows/shows_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: login_route,
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return _loginPage();
      },
      //routes: <RouteBase>[],
    ),
    GoRoute(
      path: home_route,
      builder: (BuildContext context, GoRouterState state) {
        return _loginPage();
      },
    ),
    GoRoute(
        path: login_route,
        builder: (BuildContext context, GoRouterState state) {
          return _loginPage();
        }),
    GoRoute(
        path: profile_selection_route,
        builder: (BuildContext context, GoRouterState state) {
          return _profileSelectionScreen();
        }),
    GoRoute(
      path: shows_route,
      builder: (BuildContext context, GoRouterState state) {
        return _showsPage();
      },
      routes: [
        GoRoute(
          //extra: movie
          path: '$details_route',
          builder: (context, state) {
            return _showDetailsPage(data: state.extra as Media);
          },
        ),
      ],
    ),
  ],
);

Widget _loginPage() {
  return const Scaffold(
    appBar: CustomHeaderBar(),
    drawer: NavBar(),
    body: LoginPage(),
  );
}

Widget _profileSelectionScreen() {
  return const Scaffold(
    appBar: CustomHeaderBar(),
    drawer: NavBar(),
    body: ProfileSelectionPage(),
  );
}

Widget _showsPage() {
  return Scaffold(
    appBar: CustomHeaderBar(),
    drawer: NavBar(),
    body: ShowsPage(
      title: 'Films',
    ),
  );
}

Widget _showDetailsPage({required Media data}) {
  return Scaffold(
    appBar: const CustomHeaderBar(),
    drawer: const NavBar(),
    body: ShowDetailPage(media: data),
  );
}
