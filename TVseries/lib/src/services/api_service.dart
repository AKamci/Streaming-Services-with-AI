import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tv_series/src/models/censor.dart';
import 'package:tv_series/src/models/movie.dart';
import 'package:tv_series/src/models/subUserSub.dart';
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
  String serverName = "https://192.168.52.18:7242/api";
  String securityServerName = "https://192.168.52.18:7089/api";

  int customerId = -1;
  int subUserId = -1;

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
      print(token);
      final Map<String, dynamic> data = json.decode(response.body);
      return fromJson(data);
    } else {
      print('response.statusCode is : ${response.statusCode}');
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
      final Map<String, dynamic> data = json.decode(response.body);
      Iterable list = data['value'];
      return list.map((item) => fromJson(item)).toList();
    } else {
      print('response.statusCode is : ${response.statusCode}');
      return null;
    }
  }

  // Login Operations
  Future<bool> registerUser(String email, String password) async {
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
      return true;
    } else {
      print('response.statusCode is : ${response.statusCode}');
      return false;
    }
  }

  Future<bool> loginUser(String email, String password) async {
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
      print(token);
      return true; // Giriş başarılı
    } else {
      print('response.statusCode is : ${response.statusCode}');
      return false; // Giriş başarısız
    }
  }

  // Movie Operations
  Future<List<Movie>> getMovies() async {
    final media = await _fetchProtectedDataList<Movie>(
      '$serverName/Movies',
      (data) => Movie.fromJson(data),
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

  Future<String> postMovie(Movie movie) async {
    final response = await http.post(
      Uri.parse('$serverName/Movies'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(movie.toJson()),
    );

    if (response.statusCode == 200) {
      // Başarılı bir şekilde gönderildi
      print('Movie posted successfully.');
      return ('Movie posted successfully.');
    } else {
      // Hata durumu
      print('Failed to post movie. Status code: ${response.statusCode}');
    }
    return ('Failed to post movie. Status code: ${response.statusCode}');
  }

  // Censors Operations
  Future<List<Censor>> getCensors() async {
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
    } else {}
    return User(Email: '');
  }

  Future<int> getCustomerIdByMail(String mail) async {
    final String url = '$serverName/Customers/GetCustomerIdByMail?Email=$mail';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Assuming the response body contains a JSON object with an 'id' field
        final Map<String, dynamic> responseData = json.decode(response.body);
        customerId = responseData['value'];
        return responseData['value'];
      } else {
        throw Exception('Failed to load customer ID');
      }
    } catch (e) {
      print('Error: $e');
      return -1; // Or handle error appropriately
    }
  }

  // Subuser Operations
  //Future<List<SubUser>> getSubUsers(int customerId) async {
  //  final subUserList = await _fetchProtectedDataList<SubUser>(
  //    '$serverName/Customers/$customerId/SubUsers',
  //    (data) => (SubUser.fromJson(data)),
  //  );
  //  if (subUserList != null) {
  //    return subUserList;
  //  } else {}
  //  return List.empty();
  //}
//
  //Future<SubUser> getSubUserById(int customerId) async {
  //  final subUser = await _fetchProtectedData<SubUser>(
  //    '$serverName/Users/$customerId',
  //    (data) => (SubUser.fromJson(data)),
  //  );
  //  if (subUser != null) {
  //    return subUser;
  //  } else {}
  //  return SubUser();
  //}

  Future<List<SubUser>> getSubUsers(int customerId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.get(
      Uri.parse('$serverName/Customers/GetCustomerWithUsers?id=$customerId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      Iterable users = data['value']['users'];
      return users.map((user) => SubUser.fromJson(user)).toList();
    } else {
      print('response.statusCode is : ${response.statusCode}');
      return [];
    }
  }

  Future<String> postSubUser(SubUser subUser) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('$serverName/Users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(subUser.toJson()),
    );

    if (response.statusCode == 200) {
      // Başarılı bir şekilde gönderildi
      print('SubUser posted successfully.');
      return 'SubUser posted successfully.';
    } else {
      // Hata durumu
      print('Failed to post subUser. Status code: ${response.statusCode}');
      print(subUser.toJson());
    }
    return 'Failed to post subUser. Status code: ${response.statusCode}';
  }
}
