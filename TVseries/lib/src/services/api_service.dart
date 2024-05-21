import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tv_series/src/models/censor.dart';
import 'package:tv_series/src/models/media.dart';

class ApiDataService {
  String serverName = "localhost:7089/api";

  Future<void> registerUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$serverName/Register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'eMail': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final token = data['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      //return("giris basarili")
    } else {
      // Hata durumunu yönet
    }
  }

  Future<void> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$serverName/Login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'eMail': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final token = data['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
    } else {
      // Hata durumunu yönet
    }
  }

  Future<T?> _fetchProtectedData<T>(
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
      return fromJson(data);
    } else {
      // Hata durumunu yönet
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
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => fromJson(item)).toList();
    } else {
      // Hata durumunu yönet
      return null;
    }
  }

  Future<List<Media>> getMovies() async {
    final media = await _fetchProtectedDataList<Media>(
      '$serverName/Movies',
      (data) => (Media.fromJson(data)),
    );

    if (media != null) {
      return media;
    } else {
      print('this is empty data');
      return List.empty();
    }
  }

  Future<Media?> getMovieById(int id) async {
    final media = await _fetchProtectedData<Media>(
      '$serverName/Movies/$id',
      (data) => Media.fromJson(data),
    );
    if (media != null) {
      return media;
    } else {}
    return null;
  }

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
}
