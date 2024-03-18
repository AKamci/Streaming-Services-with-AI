import 'package:flutter/material.dart';
import 'package:tv_series/core/extensions/l10n_extensions.dart';
import 'package:tv_series/src/models/subUser.dart';

class WhoIsWatching extends StatefulWidget {
  const WhoIsWatching({super.key});

  @override
  State<WhoIsWatching> createState() => _WhoIsWatchingState();
}

class _WhoIsWatchingState extends State<WhoIsWatching> {
  List<SubUser> subUser = [
    SubUser('subId', 'name1', 'surname', 'image', 'title', 'description', 123),
    SubUser('subId', 'name2', 'surname', 'image', 'title', 'description', 123),
    SubUser('subId', 'name3', 'surname', 'image', 'title', 'description', 123),
    SubUser('subId', 'name4', 'surname', 'image', 'title', 'description', 123)
  ];

  Widget subUserWidgetListGet(List<SubUser> userList) {
    List<Widget> userWidget = [];
    for (var i = 0; i < userList.length; i++) {
      userWidget.add(subUserWidgetCreate(userList[i]));
    }
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 50.0,
      mainAxisSpacing: 50.0,
      padding: EdgeInsets.fromLTRB(30, 100, 30, 0),
      children: userWidget,
    );
  }

  Widget subUserWidgetCreate(SubUser user) {
    return Container(
      color: Colors.red,
      child: Container(
        alignment: Alignment.topCenter,
        child: Text(
          user.name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
          color: Colors.red,
          child: Text(context.translate.who_is_watching),
        ),
        Expanded(
          child: subUserWidgetListGet(subUser),
        )
      ],
    );
  }
}
