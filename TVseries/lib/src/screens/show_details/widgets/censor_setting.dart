import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class checkBox extends StatelessWidget {
  const checkBox({super.key});

  void _showCheckboxDialog(BuildContext context) {
    bool isChecked = false; // Local state for checkbox

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Censorship'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //Text('Do you agree with the terms and conditions?'),
              Column(
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (bool? value) {
                          // Update the local state of the dialog
                          (context as Element).markNeedsBuild();
                          isChecked = value!;
                        },
                      ),
                      Text('Cigarette'),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (bool? value) {
                          // Update the local state of the dialog
                          (context as Element).markNeedsBuild();
                          isChecked = value!;
                        },
                      ),
                      Text('I Agree'),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (bool? value) {
                          // Update the local state of the dialog
                          (context as Element).markNeedsBuild();
                          isChecked = value!;
                        },
                      ),
                      Text('I Agree'),
                    ],
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                // Here you could return isChecked to the caller
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
    return Expanded(
      child: TextButton(
        onPressed: () => _showCheckboxDialog(context),
        child: Text('Choose Censorship'),
      ),
    );
  }
}
