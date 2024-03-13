import 'package:flutter/material.dart';
import 'package:tv_series/src/components/header_bar.dart';
import 'package:tv_series/src/components/navbar.dart';
import './routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Scaffold(
        appBar: CustomHeaderBar(),
        drawer: NavBar(),
      ),
      title: 'TVseries',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false, // for debug just design material
      initialRoute: '/login',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
