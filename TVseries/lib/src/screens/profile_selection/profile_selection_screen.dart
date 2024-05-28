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
  
  
  SubUser subCreateUser = SubUser();
  late Widget subUserWidgetList = subUserWidgetCreate(subCreateUser);

  String titlePage = "eren";
  String idno = "11";

  @override
  void initState() {
    super.initState();
    _fetchCustomerData();
  }
  


  Future<void> _fetchCustomerUserData(String idno) async {
    subUserList = await apiService.getSubUsers(int.parse(idno));
    setState(() {
      subUserWidgetList = subUserWidgetListGet(subUserList);
    });
  }

  Future<void> _fetchCustomerData() async {
    String customerId = apiService.customerId.toString();
    setState(() {
      idno = customerId;
    });
    await _fetchCustomerUserData(idno);
  }

  Widget subUserWidgetListGet(List<SubUser> userList) {
    List<Widget> userWidget = [];
    for (var i = 0; i < userList.length; i++) {
      userWidget.add(subUserWidgetCreate(userList[i]));
    }
    userWidget.add(InkWell(
      onTap: () {
        context.goNamed(user_form_route);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          image: DecorationImage(
            image: AssetImage('assets/images/simp.png'),
            fit: BoxFit.contain,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.bottomCenter,
        child: Container(
          color: Colors.black54,
          padding: EdgeInsets.symmetric(vertical: 5),
          width: double.infinity,
          child: Text(
            'user add',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ));

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 50.0,
      mainAxisSpacing: 50.0,
      padding: EdgeInsets.fromLTRB(30, 50, 30, 0),
      children: userWidget,
    );
  }

  Widget subUserWidgetCreate(SubUser user) {
    return InkWell(
      onTap: () {
        _submit(user.userId);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          image: DecorationImage(
            image:
                //NetworkImage(user.image ?? 'https://via.placeholder.com/150'),
                NetworkImage('https://via.placeholder.com/150'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.bottomCenter,
        child: Container(
          color: Colors.black54,
          padding: EdgeInsets.symmetric(vertical: 5),
          width: double.infinity,
          child: Text(
            user.title ?? '',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _submit(int? userNo) {
    if (userNo != null) {
      apiService.subUserId = userNo;
    } else {
      apiService.subUserId = -1;
    }

    context.go('/$shows_route');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
            
            child: const Text(
              'Choose a user',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
              flex: 3,
              child: Container(
                child: subUserWidgetList,
              )),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.grey),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0)),
                ),
                onPressed: () {
                  context.goNamed(user_settings_route);
                },
                child: Text(
                  'User Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
