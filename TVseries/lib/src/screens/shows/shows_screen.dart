import 'package:flutter/material.dart';
import 'package:tv_series/src/models/movie.dart';
import 'package:tv_series/src/services/api_service.dart';

class ShowsPage extends StatefulWidget {
  // title = TVshows,Films
  final String title;
  const ShowsPage({super.key, required this.title});

  @override
  State<ShowsPage> createState() => _ShowsPageState();
}

class _ShowsPageState extends State<ShowsPage> {
  late Future<List<Movie>> movies;
  final ApiDataService apiDataService = ApiDataService();

  @override
  void initState() {
    super.initState();
    movies = apiDataService.getMovies();
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
          future: movies,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No movies found.'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final movie = snapshot.data![index];
                  return ListTile(
                    title: Text(movie.MovieName),
                    subtitle: Text(movie.MovieDescription),
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }
}
