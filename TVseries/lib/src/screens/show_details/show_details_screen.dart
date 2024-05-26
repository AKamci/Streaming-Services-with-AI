import 'package:flutter/material.dart';
import 'package:tv_series/src/models/censor.dart';
import 'package:tv_series/src/models/movie.dart';
import 'package:tv_series/src/screens/show_details/widgets/overview.dart';
import 'package:tv_series/src/screens/show_details/widgets/censors.dart';
import 'package:tv_series/src/services/api_service.dart';

class ShowDetailPage extends StatefulWidget {
  final Movie media;

  const ShowDetailPage({super.key, required this.media});

  @override
  ShowDetailPageState createState() => ShowDetailPageState();
}

class ShowDetailPageState extends State<ShowDetailPage> {
  String selectedButton = 'OVERVIEW';

  @override
  Widget build(BuildContext context) {
    String title = widget.media.MovieName;
    String posterUrl = widget.media.MoviePoster;
    String? releaseDate = widget.media.ReleaseYear;
    String description = widget.media.MovieDescription;
    late Future<List<Censor>>? censorship = ApiDataService().getCensors();

    Widget getSelectedWidget() {
      if (selectedButton == 'OVERVIEW') {
        return OverView(
          movie: widget.media,
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
                return CensorWidget(
                  censorList: snapshot.data!,
                  media: widget.media,
                );
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
              child: SizedBox(
                width: double.infinity,
                child: Image.asset(
                  posterUrl,

                  //height: 200,
                  fit: BoxFit.fill,
                ),
              )),
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
