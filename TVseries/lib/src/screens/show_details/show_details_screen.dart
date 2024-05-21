import 'package:flutter/material.dart';
import 'package:tv_series/src/models/censor.dart';
import 'package:tv_series/src/models/media.dart';
import 'package:tv_series/src/screens/show_details/widgets/overview.dart';
import 'package:tv_series/src/screens/show_details/widgets/censors.dart';
import 'package:tv_series/src/services/api_service.dart';

class ShowDetailPage extends StatefulWidget {
  final Media media;

  ShowDetailPage({required this.media});

  @override
  _ShowDetailPageState createState() => _ShowDetailPageState();
}

class _ShowDetailPageState extends State<ShowDetailPage> {
  String selectedButton = 'OVERVIEW';

  @override
  Widget build(BuildContext context) {
    String title = widget.media.title;
    String posterUrl = widget.media.posterPath;
    String releaseDate = widget.media.releaseDate;
    String description = widget.media.overview;
    late Future<List<Censor>>? censorship = ApiDataService().getCensors();

    Widget getSelectedWidget() {
      if (selectedButton == 'OVERVIEW') {
        return OverView(
          movie: null,
        );
      } else if (selectedButton == 'CENSORS') {
        if (censorship != null) {
          return FutureBuilder<List<Censor>>(
            future: censorship,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return CensorWidget(censorList: snapshot.data!);
              }
            },
          );
        }
      } else {
        return Container();
      }
      return Container();
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {}, // Image tapped
            child: Image.asset(
              posterUrl,
              width: double.infinity,
              //height: 200,
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedButton = 'OVERVIEW';
                    });
                  },
                  child: Text(
                    'OVERVIEW',
                    style: TextStyle(
                      color: selectedButton == 'OVERVIEW'
                          ? Colors.white
                          : Colors.grey,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedButton = 'CENSORS';
                    });
                  },
                  child: Text(
                    'CENSORS',
                    style: TextStyle(
                      color: selectedButton == 'CENSORS'
                          ? Colors.white
                          : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          getSelectedWidget(),
        ],
      ),
    );
  }
}
