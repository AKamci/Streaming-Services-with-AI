import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tv_series/src/services/api_service.dart';
import 'package:url_strategy/url_strategy.dart';

import 'src/app.dart';

void main() {

  setPathUrlStrategy();
  
  HttpOverrides.global = MyHttpOverrides();
  
  runApp(const MyApp());
}
