import 'package:tv_series/src/models/subUserSub.dart';

class User {
  String Email;

  List<SubUser>? Users;

  User({required this.Email, this.Users});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      Email: json['value']['email'],
      Users: json['value']['Users'],
    );
  }
}
