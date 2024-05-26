import 'package:flutter/material.dart';
import 'package:tv_series/src/models/movie.dart';
import 'package:tv_series/src/screens/shows/widgets/media_card.dart';
import 'package:tv_series/src/services/api_service.dart';

class ShowsPage extends StatefulWidget {
  // title = TVshows, Films
  final String title;
  const ShowsPage({super.key, required this.title});

  @override
  State<ShowsPage> createState() => _ShowsPageState();
}

class _ShowsPageState extends State<ShowsPage> {
  late Future<List<Movie>> moviesFuture;
  final ApiDataService apiDataService = ApiDataService();

  @override
  void initState() {
    super.initState();
    moviesFuture = apiDataService.getMovies();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return FutureBuilder<List<Movie>>(
        future: moviesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No movies found.'));
          } else {
            final movies = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: List.generate((movies.length / 2).ceil(), (index) {
                  return Container(
                    height: screenHeight / 3,
                    
                    child: Row(



                      children: [
                        Expanded(
                          child: MediaCard(media: movies[index * 2]),

                        ),
                        if (index * 2 + 1 < movies.length)
                          Expanded(
                            child: MediaCard(media: movies[index * 2 + 1]),
                          )
                        else
                          Expanded(child: Container()), // Boş Expanded
                      ],






                    ),
                  );
                }),
              ),
            );
          }
        },
      );
  }
}
