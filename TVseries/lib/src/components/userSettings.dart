import 'package:flutter/material.dart';
import 'package:tv_series/src/constants/routes.dart';
import 'package:tv_series/src/models/subUserSub.dart';

class SubUserSettingsPage extends StatefulWidget {
  final int subUserId;

  const SubUserSettingsPage({
    Key? key,
    required this.subUserId,
  }) : super(key: key);

  @override
  _SubUserSettingsPageState createState() => _SubUserSettingsPageState();
}

class _SubUserSettingsPageState extends State<SubUserSettingsPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _imageController;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  late Future<SubUser> _futureSubUser;

  @override
  void initState() {
    super.initState();
    _futureSubUser = apiService.getSubUser(widget.subUserId);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _imageController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _updateSubUser(SubUser subUser) async {
    if (_formKey.currentState!.validate()) {
      SubUser updatedSubUser = SubUser(
        userId: subUser.userId,
        customerId: subUser.customerId,
        name: _nameController.text,
        surname: _surnameController.text,
        image: _imageController.text,
        title: _titleController.text,
        description: _descriptionController.text,
        pin: subUser.pin,
        lastWatchedId: subUser.lastWatchedId,
        lastWatched: subUser.lastWatched,
        movies: subUser.movies,
        favoriteMovies: subUser.favoriteMovies,
        finishedMovies: subUser.finishedMovies,
        censors: subUser.censors,
      );

      bool success = await apiService.updateSubUser(updatedSubUser);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('SubUser updated successfully!'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to update SubUser.'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update SubUser Settings'),
      ),
      body: FutureBuilder<SubUser>(
        future: _futureSubUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var subUser = snapshot.data!;
            _nameController = TextEditingController(text: subUser.name);
            _surnameController = TextEditingController(text: subUser.surname);
            _imageController = TextEditingController(text: subUser.image);
            _titleController = TextEditingController(text: subUser.title);
            _descriptionController = TextEditingController(text: subUser.description);

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
                    ),
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(labelText: 'Title'),
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _updateSubUser(subUser),
                      child: Text('Update'),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text('No data found'));
          }
        },
      ),
    );
  }
}
