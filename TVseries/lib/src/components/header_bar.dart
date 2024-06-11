import 'package:flutter/material.dart';

class CustomHeaderBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomHeaderBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Wayang Digital'),
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(Icons.menu),
        tooltip: 'Side Menu',
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      /*
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.navigate_next),
          tooltip: 'Go to the next page',
          onPressed: () {
            Navigator.of(context).pushNamed('/shows');
          },
        ),
      ],
      */
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
