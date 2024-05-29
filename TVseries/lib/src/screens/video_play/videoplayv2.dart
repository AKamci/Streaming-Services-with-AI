import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:path_provider/path_provider.dart';

class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  String _videoFilePath = '';

  @override
  void initState() {
    super.initState();
    _checkForExistingVideo();
  }

  Future<void> _checkForExistingVideo() async {
    final downloadsDir = await getExternalStorageDirectory();

    final videoFile = File('${downloadsDir!.path}/video.mp4');

    if (await videoFile.exists()) {
      _videoFilePath = videoFile.path;
      _initializeVideoPlayer();
    } else {
      _fetchVideoFromTCP();
    }
  }

  Future<void> _fetchVideoFromTCP() async {
    final String ip = '192.168.118.18';
    final int port = 9999;

    try {
      Socket socket = await Socket.connect(ip, port);
      List<int> videoData = [];
      String filename = '858';
      socket.add(Uint8List.fromList(filename.codeUnits));
      await socket
          .listen((Uint8List data) {
            videoData.addAll(data);
          })
          .asFuture()
          .then((_) async {
            socket.close();

            final downloadsDir = await getExternalStorageDirectory();
            final videoFile = File('${downloadsDir!.path}/video.mp4');
            await videoFile.writeAsBytes(videoData);

            setState(() {
              _videoFilePath = videoFile.path;
            });
            _initializeVideoPlayer();
          });
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _initializeVideoPlayer() {
    _videoPlayerController = VideoPlayerController.file(File(_videoFilePath))
      ..initialize().then((_) {
        setState(() {
          _isLoading = false;
        });
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController!,
          aspectRatio: _videoPlayerController!.value.aspectRatio,
          autoPlay: true,
          looping: true,
          errorBuilder: (context, errorMessage) {
            return Center(
              child: Text(
                errorMessage,
                style: TextStyle(color: Colors.white),
              ),
            );
          },
        );
      }).catchError((error) {
        print('Video initialization error: $error');
        setState(() {
          _isLoading = false;
        });
      });
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
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
            : _chewieController != null &&
                    _chewieController!.videoPlayerController.value.isInitialized
                ? Chewie(
                    controller: _chewieController!,
                  )
                : Text('Error loading video'),
      ),
    );
  }
}
