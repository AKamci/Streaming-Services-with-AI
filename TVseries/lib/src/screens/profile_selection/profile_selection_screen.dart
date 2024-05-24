import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tv_series/src/constants/routes.dart';
import 'package:tv_series/src/models/subUserSub.dart';

class ProfileSelectionPage extends StatefulWidget {
  const ProfileSelectionPage({super.key});

  @override
  State<ProfileSelectionPage> createState() => _ProfileSelectionState();
}

class _ProfileSelectionState extends State<ProfileSelectionPage> {
  List<SubUser> subUserList = [];

  SubUser subCreateUser = SubUser(
      customerId: 9999,
      name: 'dummydata',
      surname: 'dummydata',
      image: 'dummydata',
      title: 'dummydata',
      description: 'dummydata');
  List<Widget> subUserWidgetList = [];

  String titlePage = "eren";
  String idno = "11";

  @override
  void initState() {
    super.initState();
    _fetchCustomerData();
    subUserWidgetList.add(subUserWidgetCreate(subCreateUser));
  }

  Future<void> _fetchCustomerData() async {
    setState(() {
      idno = apiService.customerId.toString();
    });
  }

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
    return ElevatedButton(
      onPressed: _submit,
      child: Container(
        alignment: Alignment.topCenter,
        child: Text(
          user.title.toString(),
        ),
      ),
    );
  }

  void _submit() {
    GoRouter.of(context).push(shows_route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titlePage),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
              color: Colors.red,
              child: Text(idno),
            ),
            Expanded(
              child: subUserWidgetList[0],
            ),
          ],
        ),
      ),
    );
  }
}
