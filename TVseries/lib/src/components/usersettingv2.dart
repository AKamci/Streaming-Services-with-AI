import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tv_series/src/constants/routes.dart';
import 'package:tv_series/src/models/subUserSub.dart';

class SubUserSettingsPage extends StatefulWidget {
  const SubUserSettingsPage({super.key});

  @override
  State<SubUserSettingsPage> createState() => _SubUserSettingsPageState();
}

class _SubUserSettingsPageState extends State<SubUserSettingsPage> {
  List<SubUser> subUserList = [];
  SubUser subCreateUser = SubUser();
  late Widget subUserWidgetList = subUserWidgetCreate(subCreateUser, 0);
  String idno = "11";

  int selectedUserNo = -1;
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController surnameController = TextEditingController(text: "");
  TextEditingController imageController = TextEditingController(text: "");
  TextEditingController titleController = TextEditingController(text: "");
  TextEditingController descriptionController = TextEditingController(text: "");



  @override
  void initState() {
    super.initState();
    _fetchCustomerData();
  }

  textEdit(int selectedUserIndex) {
    setState(() {
      nameController =
          TextEditingController(text: subUserList[selectedUserIndex].name);
      surnameController =
          TextEditingController(text: subUserList[selectedUserIndex].surname);
      imageController =
          TextEditingController(text: subUserList[selectedUserIndex].image);
      titleController =
          TextEditingController(text: subUserList[selectedUserIndex].title);
      descriptionController = TextEditingController(
          text: subUserList[selectedUserIndex].description);
    });
  }

  //user form functions
  Future<void> _updateSubUser(SubUser subUser) async {
    if (_formKey.currentState!.validate()) {
      SubUser updatedSubUser = SubUser(
        userId: subUser.userId,
        customerId: subUser.customerId,
        name: nameController.text,
        surname: surnameController.text,
        image: imageController.text,
        title: titleController.text,
        description: descriptionController.text,
        pin: subUser.pin,
        lastWatchedId: subUser.lastWatchedId,
      );

      bool success = await apiService.updateSubUser(updatedSubUser);

      if (success) {
        context.go('/$shows_route');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to update SubUser.'),
        ));
      }
    }
  }

  // user functions
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
      userWidget.add(subUserWidgetCreate(userList[i], i));
    }
    //user add func
    //userWidget.add(InkWell(
    //  onTap: () {
    //    context.goNamed(user_form_route);
    //  },
    //  child: Container(
    //    decoration: BoxDecoration(
    //      color: Colors.red,
    //      image: DecorationImage(
    //        image: AssetImage('assets/images/simp.png'),
    //        fit: BoxFit.contain,
    //      ),
    //      borderRadius: BorderRadius.circular(10),
    //    ),
    //    alignment: Alignment.bottomCenter,
    //    child: Container(
    //      color: Colors.black54,
    //      padding: EdgeInsets.symmetric(vertical: 5),
    //      width: double.infinity,
    //      child: Text(
    //        'user add',
    //        style: TextStyle(
    //          color: Colors.white,
    //          fontSize: 16,
    //        ),
    //        textAlign: TextAlign.center,
    //      ),
    //    ),
    //  ),
    //));

    return GridView.count(
      crossAxisCount: 1,
      scrollDirection: Axis.horizontal,
      crossAxisSpacing: 10.0,
      mainAxisSpacing: 30.0,
      padding: EdgeInsets.fromLTRB(10, 10, 20, 0),
      children: userWidget,
    );
  }

  Widget subUserWidgetCreate(SubUser user, int selectedNo) {
    return InkWell(
      onTap: () {
        _submit(user.userId, selectedNo);
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
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _submit(int? userNo, int selectedNo) {
    if (userNo != null) {
      apiService.subUserId = userNo;
      selectedUserNo = selectedNo;
      textEdit(selectedNo);
    } else {
      apiService.subUserId = -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 25, 10, 30),
                child: subUserWidgetList,
              )),
          Expanded(
            flex: 4,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(labelText: 'Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: surnameController,
                        decoration: InputDecoration(labelText: 'Surname'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a surname';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: imageController,
                        decoration: InputDecoration(labelText: 'Image URL'),
                      ),
                      TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(labelText: 'Title'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a Title';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: descriptionController,
                        decoration: InputDecoration(labelText: 'Description'),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (selectedUserNo!=-1) {
                            _updateSubUser(subUserList[selectedUserNo]);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Please select a User.'),
                            ));
                          }
                          
                        },
                        child: Text('Update $selectedUserNo'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
