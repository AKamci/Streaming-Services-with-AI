import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';



class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  bool _isLoading = true;
  String _videoFilePath = '';

  @override
  void initState() {
    super.initState();
    _fetchVideoFromTCP();
  }

  Future<void> _fetchVideoFromTCP() async {
    final String ip = '192.168.1.5';
    final int port = 4040;

    try {
      Socket socket = await Socket.connect(ip, port);
      List<int> videoData = [];
      await socket.listen((Uint8List data) {
        videoData.addAll(data);
      }).asFuture();
      socket.close();

      final tempDir = await getTemporaryDirectory();
      final videoFile = File('${tempDir.path}/video.mp4');
      await videoFile.writeAsBytes(videoData);

      _videoFilePath = videoFile.path;
      _initializeVideoPlayer();
    } catch (e) {
      print('Error: $e');
    }
  }

  void _initializeVideoPlayer() {
    _controller = VideoPlayerController.file(File(_videoFilePath))
      ..initialize().then((_) {
        setState(() {
          _isLoading = false;
        });
        _controller!.play();
      });
  }

  void _playPause() {
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
    });
  }

  void _forward() {
    final currentPosition = _controller!.value.position;
    final duration = _controller!.value.duration;
    final newPosition = currentPosition + Duration(seconds: 10);
    _controller!.seekTo(newPosition < duration ? newPosition : duration);
  }

  void _rewind() {
    final currentPosition = _controller!.value.position;
    final newPosition = currentPosition - Duration(seconds: 10);
    _controller!.seekTo(newPosition > Duration.zero ? newPosition : Duration.zero);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TCP Video Stream Player'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_controller != null && _controller!.value.isInitialized)
                    AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VideoPlayer(_controller!),
                    ),
                  SizedBox(height: 20),
                  if (_controller != null && _controller!.value.isInitialized)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.replay_10),
                          onPressed: _rewind,
                        ),
                        IconButton(
                          icon: Icon(
                            _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                          ),
                          onPressed: _playPause,
                        ),
                        IconButton(
                          icon: Icon(Icons.forward_10),
                          onPressed: _forward,
                        ),
                      ],
                    ),
                ],
              ),
      ),
    );
  }
}
