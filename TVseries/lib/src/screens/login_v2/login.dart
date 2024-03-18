import 'package:flutter/material.dart';
import 'package:tv_series/src/screens/login_v2/loginFormScreen.dart';
import 'package:video_player/video_player.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late VideoPlayerController _controller;
  double _bottomPosition = 50; // Initial bottom position
  double _loginTopPosition = 50;
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
    /*_controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
      ..initialize().then((_) {
        setState(() {
          _controller.play();
          _controller.setLooping(true);
        });
      });
      */
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      height: screenHeight,
                      alignment: Alignment.center,
                      child: Opacity(
                        opacity: 0.4,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          top: _loginTopPosition + MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          // Login page widget
          child: LoginRegisterPage(),
        ),
        /*
        Container(
          margin: EdgeInsets.only(top: _bottomPosition),
          child: const LoginForm(),
        ),
        */
        AnimatedPositioned(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          bottom: _bottomPosition,
          left: 0,
          right: 0,
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              setState(
                () {
                  _bottomPosition -= details.delta.dy;
                  if (_bottomPosition < 50) _bottomPosition = 50;
                  if (_bottomPosition >
                      MediaQuery.of(context).size.height / 5) {
                    _isSwipedUp = true;
                  } else {
                    _isSwipedUp = false;
                  }
                },
              );
            },
            onVerticalDragEnd: (details) {
              if (_isSwipedUp) {
                setState(
                  () {
                    _bottomPosition =
                        MediaQuery.of(context).size.height; // Fullscreen
                    _loginTopPosition = -MediaQuery.of(context).size.height;
                  },
                );
              } else {
                setState(() {
                  _bottomPosition = 50; // Initial Position
                });
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              color: Colors.black.withOpacity(0.5),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.keyboard_arrow_up,
                    color: Colors.white,
                    size: 30,
                  ),
                  Text(
                    'Swipe Up',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
