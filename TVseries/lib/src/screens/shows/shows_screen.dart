import 'package:flutter/material.dart';
import 'package:tv_series/src/components/navbar.dart';
import '../../components/header_bar.dart';
import './components/body.dart';

class ShowsScreen extends StatelessWidget {
  const ShowsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomHeaderBar(),
      drawer: NavBar(),
      body: Center(
        child: Body(),
      ),
    );
  }
}
