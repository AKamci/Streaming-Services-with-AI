import 'package:flutter/material.dart';
import 'package:tv_series/core/extensions/l10n_extensions.dart';
import 'package:tv_series/src/screens/login_v2/widgets/loginForm.dart';
import 'package:tv_series/src/screens/login_v2/widgets/registerForm.dart';

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({super.key});

  @override
  _LoginRegisterPageState createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  bool showLogin = true; // True if showing login form, false for register form

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Login Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: showLogin ? Colors.blue : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  showLogin = true;
                });
              },
              child: Text(context.translate.login),
            ),
            SizedBox(width: 10), // Space between buttons
            // Register Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: showLogin ? Colors.grey : Colors.blue,
              ),
              onPressed: () {
                setState(() {
                  showLogin = false;
                });
              },
              child: Text(context.translate.register),
            ),
          ],
        ),
        Expanded(
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              final inAnimation =
                  Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                      .animate(animation);
              final outAnimation =
                  Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                      .animate(animation);

              return SlideTransition(
                position: showLogin ? inAnimation : outAnimation,
                child: child,
              );
            },
            child: showLogin
                ? LoginForm(key: UniqueKey())
                : RegisterForm(key: UniqueKey()),
          ),
        ),
      ],
    );
  }
}
