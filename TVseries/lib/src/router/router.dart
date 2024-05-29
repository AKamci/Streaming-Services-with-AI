import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tv_series/src/components/header_bar.dart';
import 'package:tv_series/src/components/navbar.dart';
import 'package:tv_series/src/components/subUserForm.dart';
import 'package:tv_series/src/components/usersettingv2.dart';
import 'package:tv_series/src/constants/routes.dart';
import 'package:tv_series/src/models/movie.dart';
import 'package:tv_series/src/screens/login/login_screen.dart';
import 'package:tv_series/src/screens/profile_selection/profile_selection_screen.dart';
import 'package:tv_series/src/screens/show_details/show_details_screen.dart';
import 'package:tv_series/src/screens/shows/shows_screen.dart';
import 'package:tv_series/src/screens/video_play/video_player_screenv2.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      //builder: (BuildContext context, GoRouterState state) {
      //
      //  return _loginPage();
      //},
      redirect: (context, state) async {
        final bool isLoggedIn = await apiService.isLogin();
        final bool isUserSelected = await apiService.isUserSelected();
        if (!isLoggedIn) {
          return login_route;
        } else if (isLoggedIn) {
          if (isUserSelected) {
            return '/$shows_route';
          } else {
            return '/$profile_selection_route';
          }
        }
        return login_route;
      },
    ),
    // not  using to do
    GoRoute(
      path: '/$home_route',
      builder: (BuildContext context, GoRouterState state) {
        return _showsPage();
      },
    ),

    GoRoute(
      path: '/$profile_selection_route',
      name: profile_selection_route,
      builder: (BuildContext context, GoRouterState state) {
        return _profileSelectionScreen();
      },
    ),
    GoRoute(
      path: '/$user_form_route',
      name: user_form_route,
      builder: (BuildContext context, GoRouterState state) {
        return _formSubUser();
      },
    ),
    GoRoute(
      path: '/$user_settings_route',
      name: user_settings_route,
      builder: (BuildContext context, GoRouterState state) {
        return _userSettings();
      },
    ),
    GoRoute(
      path: '/$shows_route',
      builder: (BuildContext context, GoRouterState state) {
        return _showsPage();
      },
      routes: [
        GoRoute(
          path: details_route,
          name: details_route,
          builder: (context, state) {
            return _showDetailsPage(data: state.extra as Movie);
          },
        ),
      ],
    ),

    GoRoute(
      path: login_route,
      builder: (BuildContext context, GoRouterState state) {
        return _loginPage();
      },
    ),

    GoRoute(
      path: '/video',
      name: 'video',
      builder: (BuildContext context, GoRouterState state) {
        return _videoPlay();
      },
    ),
    // navbar navigations
  ],
);

Widget _loginPage() {
  return const Scaffold(
    appBar: CustomHeaderBar(),
    drawer: NavBar(),
    body: LoginPage(),
  );
}

Widget _formSubUser() {
  return Scaffold(
    appBar: CustomHeaderBar(),
    drawer: NavBar(),
    body: SubUserForm(),
  );
}

Widget _userSettings() {
  return Scaffold(
    resizeToAvoidBottomInset: false,
    appBar: CustomHeaderBar(),
    drawer: NavBar(),
    body: SubUserSettingsPage(),
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
  return const Scaffold(
    appBar: CustomHeaderBar(),
    drawer: NavBar(),
    body: ShowsPage(
      title: 'Films',
    ),
  );
}

Widget _showDetailsPage({required Movie data}) {
  return Scaffold(
    appBar: const CustomHeaderBar(),
    drawer: const NavBar(),
    body: ShowDetailPage(media: data),
  );
}

Widget _videoPlay() {
  return Scaffold(
    appBar: const CustomHeaderBar(),
    drawer: const NavBar(),
    body: VideoPlayerScreen(),
  );
}
