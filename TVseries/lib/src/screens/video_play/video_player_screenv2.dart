import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:tv_series/src/models/censor.dart';
import 'package:tv_series/src/models/movie.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:path_provider/path_provider.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen(
      {super.key, required this.selectedCensors, required this.movie});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
  final List<Censor> selectedCensors;
  final Movie movie;
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

  String censorClassIdList() {
    String myIdStrList = "";
    for (var i = 0; i < widget.selectedCensors.length; i++) {
      if (i == 0) {
        myIdStrList = '${widget.selectedCensors[i].ClassId}';
      } else {
        myIdStrList = '$myIdStrList,${widget.selectedCensors[i].ClassId}';
      }
    }

    return myIdStrList;
  }

  Future<void> _checkForExistingVideo() async {
    final downloadsDir = await getExternalStorageDirectory();

    final videoFile = File('${downloadsDir!.path}/1.mp4');

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

      // Dosya boyutunu alma ve alım işlemi
      int receivedBytes = 0;
      String filename = widget.movie.id.toString();

      String censorList = censorClassIdList();

      // Filenames ve censorList'i socket üzerinden gönderme
      socket.add(Uint8List.fromList(filename.codeUnits));
      socket.add(Uint8List.fromList(censorList.codeUnits));

      final downloadsDir = await getExternalStorageDirectory();
      final videoFile = File('${downloadsDir!.path}/$filename.mp4');
      final videoFileSink = videoFile.openWrite();

      socket.listen((Uint8List data) {
        videoFileSink.add(data);
        receivedBytes += data.length;
        print(
            "Alinan Parça Boyutu: ${data.length} bytes, Toplam Alinan: $receivedBytes bytes");
      }, onDone: () async {
        await videoFileSink.close();
        socket.close();

        setState(() {
          _videoFilePath = videoFile.path;
        });
        _initializeVideoPlayer();
      }, onError: (error) {
        print('Error: $error');
        setState(() {
          _isLoading = false;
        });
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
