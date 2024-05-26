import 'package:flutter/material.dart';
import 'package:tv_series/src/models/movie.dart';

class OverView extends StatelessWidget {
  final Movie movie;

  OverView({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final String movieName = movie.MovieName;
    final String movieDetail = movie.MovieDescription;
    final String? movieYear = movie.ReleaseYear;
    final String? category = movie.Category;
    return Center(
      child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            movieName,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        //Padding(
        //  padding: const EdgeInsets.symmetric(horizontal: 16.0),
        //  child: Text(
        //    'IMDb: 8.8/10',
        //    style: TextStyle(fontSize: 16, color: Colors.grey),
        //  ),
        //),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            '${movieYear?.substring(0,4)} • $category ',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            movieDetail,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        )
      ],
    ),
    ); 
  }
}
