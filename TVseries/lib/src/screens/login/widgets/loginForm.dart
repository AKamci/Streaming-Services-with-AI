import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tv_series/core/extensions/l10n_extensions.dart';
import 'package:tv_series/src/constants/routes.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  void _submit() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      // Login action
      print('Username: $_username, Password: $_password');
    }
    Navigator.popAndPushNamed(context, whoIsWatchingRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        //alignment: Alignment.topCenter,
        margin: const EdgeInsets.symmetric(vertical: 50.0),
        //color: Colors.red,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.blue.withOpacity(0.5),
                      child: Text(
                        context.translate.login,
                        textAlign: TextAlign.center,
                        textScaler: TextScaler.linear(1.5),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.blue.withOpacity(0.5),
                      child: Text(
                        context.translate.register,
                        textAlign: TextAlign.center,
                        textScaler: TextScaler.linear(1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                onSaved: (value) => _username = value!,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
