import 'package:tv_series/src/models/subUser.dart';

class User {
  String Email;

  List<SubUser>? Users;

  User({required this.Email, this.Users});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      Email: json['email'],
      Users: json['Users'],
    );
  }
}
