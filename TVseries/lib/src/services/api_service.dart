import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tv_series/src/models/censor.dart';
import 'package:tv_series/src/models/movie.dart';
import 'package:tv_series/src/models/subUserSub.dart';
import 'package:tv_series/src/models/user.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class ApiDataService {
  //String serverName = "https://192.168.1.39:7242/api";
  //String securityServerName = "https://192.168.1.39:7089/api";
  String serverName = "https://10.0.2.2:7242/api";
  String securityServerName = "https://10.0.2.2:7089/api";
  //String serverName = "https://192.168.52.18:7242/api";
  //String securityServerName = "https://192.168.52.18:7089/api";

  int customerId = -1;
  int subUserId = -1;

  Future<bool> isLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final prefMail = prefs.getString('userMail');
    if (token != null) {
      logger.d('MY_LOG: user is token string is : $token');
      logger.d('MY_LOG: user is mail string is : $prefMail');
      if (customerId != -1) {
        return true;
      } else if (prefMail != null) {
        customerId = await getCustomerIdByMail(prefMail);
        if (customerId == -1) {
          logger.d('MY_LOG: user is login id is  : $customerId Unauthorized');
          return false;
        }
        logger.d('MY_LOG: user is login id is  : $customerId');
        return true;
      }
      return false;
    } else {
      logger.d('MY_LOG: user is not login');
      return false;
    }
  }

  Future<bool> isUserSelected() async {
    if (subUserId != -1) {
      logger.d('MY_LOG: user selected and id is : $subUserId');
      return true;
    } else {
      logger.d('MY_LOG: user is not selected');
      return false;
    }
  }

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

      final fetchedData = fromJson(data['value']);
      logger.d('MY_LOG: fetched data is: $fetchedData');
      return fetchedData;
    } else {
      logger.d('MY_LOG: response.statusCode is : ${response.statusCode}');
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
      logger.d('MY_LOG: List of data is : $list');
      return list.map((item) => fromJson(item)).toList();
    } else {
      logger.d('MY_LOG: response.statusCode is : ${response.statusCode}');
      return null;
    }
  }

  // Login Operations
  Future<bool> registerUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$securityServerName/Register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
        {
          'eMail': email,
          'password': password,
        },
      ),
    );

    if (response.statusCode == 200) {
      logger.d('MY_LOG: register success');

      return true;
    } else {
      logger.d('MY_LOG: response.statusCode is : ${response.statusCode}');
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
      logger.d("MY_LOG: login success");
      final token = response.body;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('userMail', email);
      logger.d("MY_LOG: token is : $token");
      return true; // Giriş başarılı
    } else {
      logger.d('MY_LOG: response.statusCode is : ${response.statusCode}');
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
      logger.d('MY_LOG: this is empty data');
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
    } else {
      logger.d('MY_LOG: this is empty data');
    }
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
      logger.d('MY_LOG: Movie posted successfully.');
      return ('Movie posted successfully.');
    } else {
      // Hata durumu
      logger.d(
          'MY_LOG: Failed to post movie. Status code: ${response.statusCode}');
    }
    return ('Failed to post movie. Status code: ${response.statusCode}');
  }

  // Censors Operations
  Future<List<Censor>> getCensors() async {
    final censorList = await _fetchProtectedDataList<Censor>(
      '$serverName/Censors',
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
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final String url = '$serverName/Customers/GetCustomerIdByMail?Email=$mail';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        // Assuming the response body contains a JSON object with an 'id' field
        final Map<String, dynamic> responseData = json.decode(response.body);
        customerId = responseData['value'];
        return responseData['value'];
      } else {
        throw Exception('Failed to load customer ID');
      }
    } catch (e) {
      logger.d('MY_LOG: Error: $e');
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

  Future<List<SubUser>> getSubUsers(int myCustomerId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final response = await http.get(
      Uri.parse('$serverName/Customers/GetCustomerWithUsers?id=$myCustomerId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      Iterable users = data['value']['users'];
      logger.d('MY_LOG: Users data is: $users');
      return users.map((user) => SubUser.fromJson(user)).toList();
    } else {
      logger.d('MY_LOG: response.statusCode is : ${response.statusCode}');
      return [];
    }
  }

  Future<SubUser> getSubUser(int subUserId) async {
    final user = await _fetchProtectedData<SubUser>(
      '$serverName/Users/$subUserId',
      (data) => (SubUser.fromJson(data)),
    );
    if (user != null) {
      return user;
    } else {}
    return SubUser();
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
      logger.d('MY_LOG: SubUser posted successfully.');
      return 'SubUser posted successfully.';
    } else {
      // Hata durumu
      logger.d(
          'MY_LOG: Failed to post subUser. Status code: ${response.statusCode}');
      logger.d('MY_LOG: subuser is : ${subUser.toJson()}');
    }
    return 'Failed to post subUser. Status code: ${response.statusCode}';
  }

  Future<bool> updateSubUser(SubUser subUser) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = '$serverName/Users';
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(subUser.toJsonUpdate()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      logger.d('MY_LOG: Failed to update subuser: ${response.statusCode}');
      return false;
    }
  }


  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userMail');
    customerId = -1;
    subUserId = -1;
    logger.d('MY_LOG: User logged out successfully');
  }
}
