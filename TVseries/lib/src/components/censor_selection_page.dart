import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tv_series/src/constants/routes.dart';
import 'package:tv_series/src/models/censor.dart';
import 'package:tv_series/src/models/subUserSub.dart';

class CensorSelectionPage extends StatefulWidget {
  CensorSelectionPage({super.key, required this.selectedUser});

  final SubUser selectedUser;

  @override
  State<CensorSelectionPage> createState() => _CensorSelectionPageState();
}

class _CensorSelectionPageState extends State<CensorSelectionPage> {
  late Future<List<Censor>> censorList;
  List<bool> isChecked = [];

  @override
  void initState() {
    super.initState();
    censorList = apiService.getCensors();
  }

  Future<void> _updateSubUser(SubUser subUser, List<Censor> censorsList) async {
    List<Censor> preferencedCensors = censorsList;
    List<int> censorListId = [];
    for (var i = 0; i < preferencedCensors.length; i++) {
      censorListId.add(preferencedCensors[i].ClassId);
    }
    print('censorlistesiiiii :::: $censorListId');
    SubUser updatedSubUser = SubUser(
      userId: subUser.userId,
      customerId: subUser.customerId,
      name: subUser.name,
      surname: subUser.surname,
      image: subUser.image,
      title: subUser.title,
      description: subUser.description,
      pin: subUser.pin,
      lastWatchedId: subUser.lastWatchedId,
      censors: censorListId,
    );
    print(
        'bak bu yolladigim censorlist aaa:: ${preferencedCensors[0].ClassName}');
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

  //_updateCensorList(){
  //  List<Censor> censorArr=[];
  //  for (var i = 0; i < isChecked.length; i++) {
  //    if (isChecked[i]==true) {
  //      censorArr.add(censorList.)
  //
  //    }
  //  }
  //}

  List<Widget> _censorWidgetBuilder(List<Censor> censors) {
    return List.generate(censors.length, (i) {
      return TextButton(
        onPressed: () {
          setState(() {
            isChecked[i] = !isChecked[i];
          });
        },
        child: Row(
          children: [
            Checkbox(
              value: isChecked[i],
              onChanged: (bool? value) {
                setState(() {
                  isChecked[i] = value!;
                });
              },
            ),
            Text(
              censors[i].ClassName,
              style: TextStyle(
                color: isChecked[i] ? Colors.green : Colors.white,
              ),
            ),
          ],
        ),
      );
    });
  }

  List<Censor> selectedCensors(List<Censor> censors) {
    List<Censor> selectCensor = [];
    for (var i = 0; i < censors.length; i++) {
      if (isChecked[i] == true) {
        selectCensor.add(censors[i]);
      }
    }
    return selectCensor;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Censor>>(
      future: censorList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No censors available'));
        } else {
          if (isChecked.isEmpty) {
            isChecked = List<bool>.filled(snapshot.data!.length, false);
          }
          return Scaffold(
            appBar: AppBar(
              title: Text('Censor Selection'),
              actions: [
                TextButton(
                  onPressed: () {
                    _updateSubUser(
                        widget.selectedUser, selectedCensors(snapshot.data!));
                  },
                  child: Text('Save', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: ListBody(
                children: _censorWidgetBuilder(snapshot.data!),
              ),
            ),
          );
        }
      },
    );
  }
}
