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

  String titlePage = "eren";
  String idno = "11";

  bool isSettingSelected = false;

  double profileImageOpacity = 1.0;
  double pencilIconOpacity = 0.0;
  double userAddOpacity = 1.0;

  late Future<void> _fetchDataFuture;

  @override
  void initState() {
    super.initState();
    _fetchDataFuture = _fetchCustomerData();
  }

  Future<void> _fetchCustomerUserData(String idno) async {
    subUserList = await apiService.getSubUsers(int.parse(idno));
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
    userWidget.add(
      InkWell(
        onTap: () {
          if (!isSettingSelected) {
            context.goNamed(user_form_route);
          }
        },
        child: AnimatedOpacity(
          opacity: userAddOpacity,
          duration: const Duration(milliseconds: 200),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.red,
              image: DecorationImage(
                opacity: profileImageOpacity,
                image: AssetImage('assets/images/simp.png'),
                fit: BoxFit.contain,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Flexible(
                  flex: 2,
                  child: Container(),
                ),
                Flexible(
                  flex: 2,
                  child: Container(),
                ),
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
                Container(
                  color: Colors.black54,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  width: double.infinity,
                  child: const Text(
                    'user add',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 50.0,
      mainAxisSpacing: 50.0,
      padding: const EdgeInsets.fromLTRB(30, 50, 30, 0),
      children: userWidget,
    );
  }

  Widget subUserWidgetCreate(SubUser user) {
    return InkWell(
      onTap: () {
        if (!isSettingSelected) {
          if (user.pin != 0) {
            _showPinCodeDialog(user);
          } else {
            _submit(user.userId);
          }
        } else {
          if (user.pin != 0) {
            _showPinCodeDialog(user);
          } else {
            _submitSettings(user, user.userId);
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          image: DecorationImage(
            opacity: profileImageOpacity,
            //image: AssetImage('assets/images/simp.png'),
            image: AssetImage(user.image ?? 'assets/images/simp.png'),
            fit: BoxFit.contain,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Flexible(
              flex: 2,
              child: Container(),
            ),
            Flexible(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    opacity: pencilIconOpacity,
                    image: const AssetImage('assets/images/pencil.png'),
                    fit: BoxFit.fitHeight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(),
            ),
            Container(
              color: Colors.black54,
              padding: const EdgeInsets.symmetric(vertical: 5),
              width: double.infinity,
              child: Text(
                user.title ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
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

  void _submitSettings(SubUser user, int? userNo) {
    if (userNo != null) {
      apiService.subUserId = userNo;
    } else {
      apiService.subUserId = -1;
    }
    context.goNamed(user_settings_route, extra: user);
    //context.go('/$shows_route');
  }

  void _showPinCodeDialog(SubUser mySubUser) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String pinCode = '';
        return AlertDialog(
          title: const Text('Enter PIN Code'),
          content: TextField(
            keyboardType: TextInputType.number,
            obscureText: true,
            maxLength: 4,
            onChanged: (value) {
              pinCode = value;
            },
            decoration: const InputDecoration(
              hintText: 'PIN Code',
              counterText: '',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                if (pinCode == mySubUser.pin.toString()) {
                  Navigator.of(context).pop();
                  if (!isSettingSelected) {
                    _submit(mySubUser.userId);
                  } else {
                    _submitSettings(mySubUser, mySubUser.userId);
                  }
                } else {
                  // Hatalı PIN kodu durumunda yapılacaklar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid PIN Code')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Center(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
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
                      child: subUserWidgetListGet(subUserList),
                    )),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.grey),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 50.0)),
                      ),
                      onPressed: () {
                        setState(() {
                          isSettingSelected = !isSettingSelected;
                          if (isSettingSelected) {
                            profileImageOpacity = .7;
                            pencilIconOpacity = 1.0;
                            userAddOpacity = 0.0;
                          } else {
                            profileImageOpacity = 1.0;
                            pencilIconOpacity = 0;
                            userAddOpacity = 1.0;
                          }
                        });
                        //context.goNamed(user_settings_route);
                      },
                      child: const Text(
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
      },
    );
  }
}
