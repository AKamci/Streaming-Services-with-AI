import 'package:flutter/material.dart';

class HeaderBar extends StatelessWidget implements PreferredSizeWidget {
  const HeaderBar({
    Key? key,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('TVseries'),
      automaticallyImplyLeading: false,
      
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
