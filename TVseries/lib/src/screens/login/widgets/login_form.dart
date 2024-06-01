import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

  void _submit() async {
     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('We are trying to log in. Please wait.')),
    );
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      bool loginSuccess = await apiService.loginUser(_username, _password);
      apiService.customerId = (await apiService.getCustomerIdByMail(_username));
      if (loginSuccess) {
        context.go('/$profile_selection_route');
      } else {
        // Giriş başarısızsa kullanıcıya hata mesajı gösterebilirsiniz
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 50.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your username' : null,
                onSaved: (value) => _username = value!,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your password' : null,
                onSaved: (value) => _password = value!,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: _submit,
                child: Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
