import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tv_series/src/constants/routes.dart'; // go_router kullanıyorsanız import edin

class LoadingScreen extends StatefulWidget {
  final String message;
  final String directionPage="/";
  const LoadingScreen({Key? key, required this.message}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  void _navigateAfterDelay() async {
    apiService.subUserId=-1;
    await Future.delayed(Duration(seconds: 1));
    if (context.mounted) {
      context.go('/'); // GoRouter kullanarak yönlendirme
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(
              widget.message,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
