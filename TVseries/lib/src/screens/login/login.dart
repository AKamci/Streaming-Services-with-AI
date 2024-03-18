import 'package:flutter/material.dart';
import 'package:tv_series/src/screens/login/android/android.dart';
import 'package:tv_series/src/screens/login/web/web.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 1000) {
          return _buildWideContainers();
        } else {
          return _buildNormalContainer();
        }
      },
    );
  }

  Widget _buildNormalContainer() {
    return const LoginPage();
  }

  Widget _buildWideContainers() {
    return const WebLoginPage();
  }
}
