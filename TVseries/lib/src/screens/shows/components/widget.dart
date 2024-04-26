import 'package:flutter/material.dart';

Widget ShowCardContainer() {
  List<int> text = [1, 2, 3, 4];
  return Column(
    children: [
      for (var i in text)
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.teal[100],
          child: Text("the ${i.toString()}"),
        )
    ],
  );
}
