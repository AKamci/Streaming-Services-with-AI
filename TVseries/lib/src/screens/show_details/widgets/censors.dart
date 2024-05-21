import 'package:flutter/material.dart';
import 'package:tv_series/src/models/censor.dart';

class CensorWidget extends StatelessWidget {
  final List<Censor> censorList;

  CensorWidget({super.key, required this.censorList});

  List<Widget> _censorWidgetBuilder() {
    List<Widget> censorCard = [];
    for (var i = 0; i < censorList.length; i++) {
      censorCard.add(
        TextButton(
          onPressed: () {},
          child: Text(
            censorList[i].ClassName,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    }
    return censorCard;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _censorWidgetBuilder(),
    );
  }
}
