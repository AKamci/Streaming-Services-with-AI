import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tv_series/src/constants/routes.dart';
import 'package:tv_series/src/models/subUserSub.dart';

class NavBar extends StatelessWidget {
  NavBar({super.key});


  Future<SubUser> userSelection() async {
    return await apiService.getSubUser(apiService.subUserId);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<SubUser>(
        future: userSelection(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading user data'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No user selected'));
          } else {
            SubUser selectedUser = snapshot.data!;
            return ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: const BoxDecoration(),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(selectedUser.image ?? 'assets/images/default_user.png'),
                            ),
                          ),
                        ),
                      ),
                       Text(
                        selectedUser.title??'User',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.verified_user),
                  title: const Text('Home'),
                  onTap: () => {context.go('/$shows_route')},
                ),
                ListTile(
                  leading: const Icon(Icons.input),
                  title: const Text('Favorites'),
                  onTap: () => {context.go('/shows')},
                ),
                ListTile(
                  leading: const Icon(Icons.border_color),
                  title: const Text('User Selection'),
                  onTap: () => {context.goNamed(profile_selection_route)},
                ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text('Logout'),
                  onTap: () async {
                    await apiService.logout();
                    context.go('/');
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
