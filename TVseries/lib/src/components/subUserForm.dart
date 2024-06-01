import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tv_series/src/constants/routes.dart';
import 'package:tv_series/src/models/subUserSub.dart';

class SubUserForm extends StatefulWidget {
  @override
  _SubUserFormState createState() => _SubUserFormState();
}

class _SubUserFormState extends State<SubUserForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final custId = apiService.customerId;

  Future<void> _saveSubUser() async {
    if (_formKey.currentState!.validate()) {
      SubUser subCreateUser = SubUser(
        customerId: custId,
        name: _nameController.text,
        surname: _surnameController.text,
        image: _imageController.text,
        title: _titleController.text,
        description: _descriptionController.text,
      );

      String msj = await apiService.postSubUser(subCreateUser);
      context.goNamed(initialLocation, extra: msj);

      // Here, you can handle the subUser object as needed,
      // such as sending it to a server or saving it locally
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _surnameController,
              decoration: InputDecoration(labelText: 'Surname'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a surname';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _imageController,
              decoration: InputDecoration(labelText: 'Image URL'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an image URL';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            //TextFormField(
            //  controller: _pinController,
            //  decoration: InputDecoration(labelText: 'PIN'),
            //  keyboardType: TextInputType.number,
            //  validator: (value) {
            //    if (value == null || value.isEmpty) {
            //      return 'Please enter a PIN';
            //    }
            //    if (int.tryParse(value) == null) {
            //      return 'Please enter a valid number';
            //    }
            //    return null;
            //  },
            //),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveSubUser,
              child: Text('Save User'),
            ),
          ],
        ),
      ),
    );
  }
}
