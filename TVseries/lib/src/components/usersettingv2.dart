import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tv_series/src/constants/routes.dart';
import 'package:tv_series/src/models/subUserSub.dart';

class SubUserSettingsPage extends StatefulWidget {
  const SubUserSettingsPage({super.key, required this.selectedUser});
  final SubUser selectedUser;
  @override
  State<SubUserSettingsPage> createState() => _SubUserSettingsPageState();
}

class _SubUserSettingsPageState extends State<SubUserSettingsPage> {
  int selectedUserNo = apiService.subUserId;
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController surnameController = TextEditingController(text: "");
  TextEditingController imageController = TextEditingController(text: "");
  TextEditingController titleController = TextEditingController(text: "");
  TextEditingController descriptionController = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.selectedUser.name);
    surnameController =
        TextEditingController(text: widget.selectedUser.surname);
    imageController = TextEditingController(text: widget.selectedUser.image);
    titleController = TextEditingController(text: widget.selectedUser.title);
    descriptionController =
        TextEditingController(text: widget.selectedUser.description);
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
        context.goNamed(initialLocation, extra: "Update Success");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update SubUser.'),
          ),
        );
      }
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
              //to do
              //profil image
            ),
          ),
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
                          if (selectedUserNo != -1) {
                            _updateSubUser(widget.selectedUser);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Please select a User.'),
                            ));
                          }
                        },
                        child: Text('Update ${widget.selectedUser.userId}'),
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
