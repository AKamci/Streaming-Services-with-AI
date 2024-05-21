import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tv_series/core/extensions/l10n_extensions.dart';
import 'package:tv_series/src/constants/routes.dart';
import 'package:tv_series/src/models/subUser.dart';
import 'package:tv_series/src/models/user.dart';
import 'package:tv_series/src/services/api_service.dart';

class ProfileSelectionPage extends StatefulWidget {
  const ProfileSelectionPage({super.key});
  
  @override
  State<ProfileSelectionPage> createState() => _ProfileSelectionState();
}

class _ProfileSelectionState extends State<ProfileSelectionPage> {
  late Future<User> futureUser;
  List<SubUser> subUserList = [];

  @override
  void initState() {
    super.initState();
    fetchCustomerData();
  }

  

  void fetchCustomerData() async {
    ApiDataService apiService = ApiDataService();
    User user = await apiService.getCustomer(1);
    setState(() {
      subUserList = user.Users ?? [];
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
          user.Title,
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
        title: Text(context.translate.who_is_watching),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
              color: Colors.red,
              child: Text(context.translate.who_is_watching),
            ),
            Expanded(
              child: subUserWidgetListGet(subUserList),
            ),
          ],
        ),
      ),
    );
  }
}
