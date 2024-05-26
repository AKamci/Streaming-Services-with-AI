import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tv_series/src/constants/routes.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green,
            ),
            child: Text(
              'Side menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.input),
            title: const Text('Favorites'),
            onTap: () => {context.go('/shows')},
          ),
          //ListTile(
          //  leading: const Icon(Icons.verified_user),
          //  title: const Text('Profile'),
          //  onTap: () => {Navigator.of(context).pop()},
          //),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('User add'),
            onTap: () => {context.go(user_form_route)},
          ),
          ListTile(
            leading: const Icon(Icons.border_color),
            title: const Text('User Settings'),
            onTap: () => {context.go(user_settings_route)},
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}
