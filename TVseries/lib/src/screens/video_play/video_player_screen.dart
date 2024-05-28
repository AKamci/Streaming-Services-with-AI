import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VlcPlayerController? _controller;
  String? _filePath;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _receiveVideo();
  }

  Future<void> _receiveVideo() async {
    final directory = await getTemporaryDirectory();
    _filePath = '${directory.path}/video_stream.mp4';
    final socket = await Socket.connect('192.168.1.5', 4040);
    final file = File(_filePath!).openWrite();
    socket.listen(
      (Uint8List data) {
        file.add(data);
      },
      onDone: () async {
        await file.close();
        if (!_isPlaying) {
          _initializeVideo();
        }
      },
      onError: (error) {
        print('Error: $error');
      },
    );
  }

  Future<void> _initializeVideo() async {
    _controller = VlcPlayerController.file(
      File(_filePath!),
      hwAcc: HwAcc.full,
      autoPlay: false,
      options: VlcPlayerOptions(),
    );

    setState(() {
      _isPlaying = true;
    });

    await _controller!.initialize();
    setState(() {
      _controller!.play();
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
      appBar: AppBar(
        title: Text('TCP Video Player'),
      ),
      body: Center(
        child: _controller != null
            ? VlcPlayer(
                controller: _controller!,
                aspectRatio: 16 / 9,
                placeholder: Center(child: CircularProgressIndicator()),
              )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: _isPlaying
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  if (_controller!.value.isPlaying) {
                    _controller!.pause();
                  } else {
                    _controller!.play();
                  }
                });
              },
              child: Icon(
                _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            )
          : null,
    );
  }
}
