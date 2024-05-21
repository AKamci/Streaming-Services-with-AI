import 'package:flutter/material.dart';
import 'package:tv_series/src/models/movie.dart';
import 'package:tv_series/src/screens/shows/widgets/media_grid.dart';
import 'package:tv_series/src/services/api_service.dart';

class ShowsPage extends StatefulWidget {
  // title = TVshows,Films
  final String title;
  const ShowsPage({super.key,required this.title});

  @override
  State<ShowsPage> createState() => _ShowsPageState();
}

class _ShowsPageState extends State<ShowsPage> {

  
  late Future<List<Movie>> mediaList;
  final ApiDataService apiDataService = ApiDataService();

  @override
  void initState() {
    super.initState();
    mediaList = apiDataService.getMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        FutureBuilder<List<Movie>>(
          future: mediaList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Expanded(child: MediaGrid(media: snapshot.data!));
            }
          },
        ),
      ],
    );
  }
}
