import 'package:flutter/material.dart';
import 'login_form.dart';
import 'register_form.dart';

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({super.key});

  @override
  _LoginRegisterPageState createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  bool showLogin = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: showLogin ? Colors.blue : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  showLogin = true;
                });
              },
              child: Text('Login'),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: showLogin ? Colors.grey : Colors.blue,
              ),
              onPressed: () {
                setState(() {
                  showLogin = false;
                });
              },
              child: Text('Register'),
            ),
          ],
        ),
        Expanded(
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            child: showLogin ? LoginForm(key: UniqueKey()) : RegisterForm(key: UniqueKey()),
          ),
        ),
      ],
    );
  }
}
