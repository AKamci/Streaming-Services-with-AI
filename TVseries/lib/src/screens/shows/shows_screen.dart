import 'package:flutter/material.dart';
import 'package:tv_series/src/screens/shows/components/grid_view.dart';

class ShowsPage extends StatefulWidget {
  const ShowsPage({super.key});

  @override
  State<ShowsPage> createState() => _ShowsPageState();
}

class _ShowsPageState extends State<ShowsPage> {
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
