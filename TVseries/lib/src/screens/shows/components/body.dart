import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'grid_view.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            height: 50,
            color: Colors.red,
          ),
        ),
        Expanded(
          flex: 15,
          child: Grid(),
        ),
      ],
    );
  }
}
