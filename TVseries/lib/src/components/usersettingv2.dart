import 'package:flutter/material.dart';
import 'package:tv_series/src/components/subUserForm.dart';
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
  
  List<SubUser> subUserList = [];
  late SubUser chooseSubUser;
  SubUser subCreateUser = SubUser();
  late Widget subUserWidgetList = subUserWidgetCreate(subCreateUser);
  
  @override
  void initState() {
    _fetchCustomerData();
    super.initState();
  }



  Future<void> _fetchCustomerUserData(String idno) async {
    subUserList = await apiService.getSubUsers(int.parse(idno));
    setState(() {
      subUserWidgetList = subUserWidgetListGet(subUserList);
    });
  }

  Future<void> _fetchCustomerData() async {
    String customerId = apiService.customerId.toString();
    
    await _fetchCustomerUserData(customerId);
  }




  Widget subUserWidgetListGet(List<SubUser> userList) {
    List<Widget> userWidget = [];
    for (var i = 0; i < userList.length; i++) {
      userWidget.add(subUserWidgetCreate(userList[i]));
    }
    userWidget.add(InkWell(
      onTap: () {
        
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

    return Row(
      children: userWidget,
    );
  }

  Widget subUserWidgetCreate(SubUser user) {
    return InkWell(
      onTap: () {
        
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






  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _imageController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateSubUser(SubUser subUser) {
    if (_formKey.currentState!.validate()) {
      SubUser updatedSubUser = SubUser(
        userId: subUser.userId,
        customerId: subUser.customerId,
        name: _nameController.text,
        surname: _surnameController.text,
        image: _imageController.text,
        title: _titleController.text,
        description: _descriptionController.text,
      );

      // Asenkron API çağrısı olmadan güncelleme işlemi.
      bool success = true; // Simulated success response.

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
    
      return Column(
        children: [



          Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                
                for (var subUser in subUserList) ...[
                
                  TextFormField(
                    controller: TextEditingController(text: subUser.name),
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: TextEditingController(text: subUser.surname),
                    decoration: InputDecoration(labelText: 'Surname'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a surname';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: TextEditingController(text: subUser.image),
                    decoration: InputDecoration(labelText: 'Image URL'),
                  ),
                  TextFormField(
                    controller: TextEditingController(text: subUser.title),
                    decoration: InputDecoration(labelText: 'Title'),
                  ),
                  TextFormField(
                    controller: TextEditingController(text: subUser.description),
                    decoration: InputDecoration(labelText: 'Description'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _updateSubUser(subUser),
                    child: Text('Update ${subUser.name}'),
                  ),
                  Divider(),
                ]
              ],
            ),
          ),
        ),





















        ],
      );
    
  }
}




