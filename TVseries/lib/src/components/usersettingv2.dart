import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tv_series/src/constants/routes.dart';
import 'package:tv_series/src/models/censor.dart';
import 'package:tv_series/src/models/subUserSub.dart';
import 'censor_selection_page.dart'; // Import the new CensorSelectionPage

class SubUserSettingsPage extends StatefulWidget {
  SubUserSettingsPage({super.key, required this.selectedUser});
  final SubUser selectedUser;

  @override
  State<SubUserSettingsPage> createState() => _SubUserSettingsPageState();
}

class _SubUserSettingsPageState extends State<SubUserSettingsPage> {
  int selectedUserNo = apiService.subUserId;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController surnameController;
  late TextEditingController imageController;
  late TextEditingController titleController;
  late TextEditingController descriptionController;

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

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    imageController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

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
        censors: subUser.censors,
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

  void _navigateToCensorSelection() {
    context.goNamed(censor_selection_route, extra: widget.selectedUser);
  }

  void _createPinCodeDialog(SubUser mySubUser) {
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
                mySubUser.pin = int.parse(pinCode);
                _updateSubUser(mySubUser);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image:
                      AssetImage('assets/images/${widget.selectedUser.image}'),
                  fit: BoxFit.contain,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
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
                          _navigateToCensorSelection();
                        },
                        child: Text('Censor Preference'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _createPinCodeDialog(widget.selectedUser);
                        },
                        child: Text('Change PIN'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(),
                        onPressed: () {
                          if (selectedUserNo != -1) {
                            _updateSubUser(widget.selectedUser);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Please select a User.'),
                            ));
                          }
                        },
                        child: Text('Update User'),
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
