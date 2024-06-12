import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tv_series/src/models/censor.dart';
import 'package:tv_series/src/models/censorMovieClass.dart';
import 'package:tv_series/src/models/movie.dart';

class CensorWidget extends StatefulWidget {
  final List<Censor> censorList;
  final Movie media;
  final List<int>? preferencedCensors;
  CensorWidget(
      {super.key,
      required this.censorList,
      required this.media,
      this.preferencedCensors});

  @override
  _CensorWidgetState createState() => _CensorWidgetState();
}

class _CensorWidgetState extends State<CensorWidget> {
  List<bool> isChecked = [];

  @override
  void initState() {
    super.initState();
    isChecked = List<bool>.filled(widget.censorList.length, false);
    censorSelectPreference();
  }

  void censorSelectPreference() {
    for (var i = 0; i < widget.preferencedCensors!.length; i++) {
      for (var j = 0; j < widget.censorList.length; j++) {
        if (widget.preferencedCensors![i] == widget.censorList[j].ClassId) {
          isChecked[j] = true;
        }
      }
    }
  }

  List<Censor> _selectedCensors() {
    List<Censor> selectCensorList = [];
    for (var i = 0; i < isChecked.length; i++) {
      if (isChecked[i] == true) {
        selectCensorList.add(widget.censorList[i]);
      }
    }
    return selectCensorList;
  }

  void _playVideo() {
    List<Censor> censorListSelected = _selectedCensors();
    MovieCensorData videoData =
        MovieCensorData(censorList: censorListSelected, media: widget.media);

    context.pushNamed('video', extra: videoData);
  }

  List<Widget> _censorWidgetBuilder() {
    List<Widget> censorCard = [];

    for (var i = 0; i < widget.censorList.length; i++) {
      censorCard.add(
        TextButton(
          onPressed: () {
            setState(() {
              isChecked[i] = !isChecked[i];
            });
          },
          child: Row(
            children: [
              Checkbox(
                value: isChecked[i],
                onChanged: (bool? value) {
                  // Update the local state of the dialog
                  (context as Element).markNeedsBuild();
                  isChecked[i] = value!;
                },
              ),
              Text(
                widget.censorList[i].ClassName,
                style: TextStyle(
                  color: isChecked[i] ? Colors.green : Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return censorCard;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _censorWidgetBuilder(),
          ),
        ),
        Container(
          width: double.maxFinite,
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          color: Colors.black,
          child: ElevatedButton(
            onPressed: () {
              _playVideo();
            },
            child: Text(
              'play video',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
