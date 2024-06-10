import 'package:flutter/material.dart';
import 'package:tv_series/src/constants/routes.dart';
import 'package:tv_series/src/models/favoriteMovie.dart';
import 'package:tv_series/src/models/movie.dart';
import 'package:tv_series/src/screens/shows_favorite/widgets/media_card.dart';

class FavoriteScreen extends StatefulWidget {
  final String title;
  const FavoriteScreen({super.key, required this.title});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late Future<List<Movie?>> moviesFuture;
  late Future<List<favoriteMovie?>> favoriteListFuture;
  late List<favoriteMovie> favoriteList;

  @override
  void initState() {
    super.initState();
    moviesFuture = apiService.getFavorites(apiService.subUserId);
    favoriteListFuture = apiService.getFavoritesClass(apiService.subUserId);
    //favoriteListFuture = apiService.getFavoritesClass(apiService.subUserId);
  }

  favoriteMovie? getFavoriteForMovie(Movie movie) {
    for (var favorite in favoriteList) {
      if (favorite.movieId == movie.id) {
        return favorite;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return FutureBuilder<List<favoriteMovie?>>(
      future: favoriteListFuture,
      builder: (context, favoriteSnapshot) {
        if (favoriteSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (favoriteSnapshot.hasError) {
          return Center(child: Text('Error: ${favoriteSnapshot.error}'));
        } else if (!favoriteSnapshot.hasData ||
            favoriteSnapshot.data!.isEmpty) {
          return Center(child: Text('No favorite movies found.'));
        } else {
          favoriteList = favoriteSnapshot.data!.cast<favoriteMovie>();
          return FutureBuilder<List<Movie?>>(
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
                    children:
                        List.generate((movies.length / 2).ceil(), (index) {
                      return Container(
                        height: screenHeight / 3,
                        child: Row(
                          children: [
                            Expanded(
                              child: MediaCard(
                                media: movies[index * 2]!,
                                favorites:
                                    getFavoriteForMovie(movies[index * 2]!),
                              ),
                            ),
                            if (index * 2 + 1 < movies.length)
                              Expanded(
                                child: MediaCard(
                                  media: movies[index * 2 + 1]!,
                                  favorites: getFavoriteForMovie(
                                      movies[index * 2 + 1]!),
                                ),
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
      },
    );
  }
}
