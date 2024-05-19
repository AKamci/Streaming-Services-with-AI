import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'widgets/login_register_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late VideoPlayerController _controller;
  double _bottomPosition = 50;
  bool _isSwipedUp = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/introo.mp4')
      ..initialize().then((_) {
        setState(() {
          _controller.play();
          _controller.setLooping(true);
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 0.4,
            child: SizedBox(
              height: screenHeight,
              child: VideoPlayer(_controller),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: _isSwipedUp ? 0 : screenHeight,
            width: MediaQuery.of(context).size.width,
            height: screenHeight,
            child: const LoginRegisterPage(),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: _bottomPosition,
            left: 0,
            right: 0,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                setState(() {
                  _bottomPosition -= details.delta.dy;
                  if (_bottomPosition < 50) _bottomPosition = 50;
                  if (_bottomPosition > screenHeight / 5) {
                    _isSwipedUp = true;
                  } else {
                    _isSwipedUp = false;
                  }
                });
              },
              onVerticalDragEnd: (_) {
                setState(() {
                  _bottomPosition = _isSwipedUp ? screenHeight : 50;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                color: Colors.black.withOpacity(0.5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 30),
                    Text('Swipe Up', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
