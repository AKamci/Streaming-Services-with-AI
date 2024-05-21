import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tv_series/src/models/censor.dart';
import 'package:tv_series/src/models/movie.dart';
import 'package:tv_series/src/models/subUser.dart';


import 'dart:io';

import 'package:tv_series/src/models/user.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class ApiDataService {
  String serverName = "https://10.0.2.2:7242/api";
  String securityServerName = "https://10.0.2.2:7089/api";


    // General Operations
    Future<T?> _fetchProtectedData<T>(
      String apiPath, T Function(Map<String, dynamic>) fromJson) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      Uri.parse(apiPath),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return fromJson(data);
    } else {
      print('response.statusCode is : ${response.statusCode}' );
      return null;
    }
  }

  Future<List<T>?> _fetchProtectedDataList<T>(
    String apiPath, T Function(Map<String, dynamic>) fromJson) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    
    final response = await http.get(
      Uri.parse(apiPath),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Iterable data = json.decode(response.body);
      return data.map((item) => fromJson(item)).toList();
    } else {
      print('response.statusCode is : ${response.statusCode}' );
      return null;
    }
  }





  //Login Operations
  Future<void> registerUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$securityServerName/Register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'eMail': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      print('basarili');

    } else {
      print('basarisiz');

    }
  }

  Future<void> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$securityServerName/Login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'eMail': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      print('basarili');
      final token = response.body;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
    } else {
      print('basarisiz');

    }
  }




  //Movie Operations
  Future<List<Movie>> getMovies() async {
    final media = await _fetchProtectedDataList<Movie>(
      '$serverName/Movies',
      (data) => (Movie.fromJson(data)),
    );

    if (media != null) {
      return media;
    } else {
      print('this is empty data');
      return List.empty();
    }
  }

  Future<Movie?> getMovieById(int id) async {
    final media = await _fetchProtectedData<Movie>(
      '$serverName/Movies/$id',
      (data) => Movie.fromJson(data),
    );
    if (media != null) {
      return media;
    } else {}
    return null;
  }


  // Censors Operations
  Future<List<Censor>>? getCensors() async {
    final censorList = await _fetchProtectedDataList<Censor>(
      '$serverName/Censor',
      (data) => (Censor.fromJson(data)),
    );

    if (censorList != null) {
      return censorList;
    } else {}
    return List.empty();
  }


  // Customer Operations
  Future<List<User>> getCustomers() async {
    final userList = await _fetchProtectedDataList<User>(
      '$serverName/Customers',
      (data) => (User.fromJson(data)),
    );
    if (userList != null) {
      return userList;
    } else {}
    return List.empty();
  }

  Future<User> getCustomer(int indexNo) async {
    final user = await _fetchProtectedData<User>(
      '$serverName/Customers/$indexNo',
      (data) => (User.fromJson(data)),
    );
    if (user != null) {
      return user;
    } else {
    }
    return User(Email: '');
  }

  // Subuser Operations
    Future<List<User>> getSubUsers() async {
    final userList = await _fetchProtectedDataList<User>(
      '$serverName/Customers',
      (data) => (User.fromJson(data)),
    );
    if (userList != null) {
      return userList;
    } else {}
    return List.empty();
  }

  Future<User> getSubUserById(int indexNo) async {
    final user = await _fetchProtectedData<User>(
      '$serverName/Customers/$indexNo',
      (data) => (User.fromJson(data)),
    );
    if (user != null) {
      return user;
    } else {
    }
    return User(Email: '');
  }

  Future<User> postSubUser(SubUser subUser) async {
    final user = await _fetchProtectedData<User>(
      '$serverName/Users',
      (data) => (User.fromJson(data)),
    );
    if (user != null) {
      return user;
    } else {
    }
    return User(Email: '');
  }

}
