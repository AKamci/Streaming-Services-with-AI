import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoReceiverScreen extends StatefulWidget {
  @override
  _VideoReceiverScreenState createState() => _VideoReceiverScreenState();
}

class _VideoReceiverScreenState extends State<VideoReceiverScreen> {
  VideoPlayerController? _controller;
  bool _isPlaying = false;
  String videoFilePath = '/path_to_store_video_file/video.mp4';

  @override
  void initState() {
    super.initState();
    _receiveVideo();
  }

  void _receiveVideo() async {
    final socket = await Socket.connect('192.168.1.5', 4040);
    List<int> videoData = [];
    socket.listen((Uint8List data) {
      videoData.addAll(data);
    }, onDone: () async {
      await File(videoFilePath).writeAsBytes(videoData);
      _playVideo(videoFilePath);
      socket.close();
    });
  }

  void _playVideo(String videoFilePath) {
    _controller = VideoPlayerController.file(File(videoFilePath))
      ..initialize().then((_) {
        setState(() {
          _isPlaying = true;
          _controller?.play();
        });
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video Receiver')),
      body: Center(
        child: _isPlaying && _controller != null
            ? AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              )
            : Text('Waiting for video...'),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: VideoReceiverScreen(),
  ));
}
