import 'dart:convert';
import 'package:flutter/services.dart';
import '/src/models/media.dart';

class LocalDataService {
  Future<List<Media>> fetchMedia() async {
    final String response = await rootBundle.loadString('assets/data/media_data.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Media.fromJson(json)).toList();
  }
}


