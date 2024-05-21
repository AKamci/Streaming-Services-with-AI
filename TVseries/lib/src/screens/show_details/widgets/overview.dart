import 'package:flutter/material.dart';
import 'package:tv_series/src/models/movie.dart';

class OverView extends StatelessWidget {
  final Movie movie;

  OverView({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final String movieName = movie.MovieName;
    final String movieDetail = movie.MovieDescription;
    final DateTime? movieYear = movie.ReleaseYear;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'The Simpsons',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'IMDb: 8.8/10',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            '1989 • Returning Series • Comedy, Family • Fox Broadcasting Company',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Set in Springfield, the average American town, the show focuses on the antics and everyday adventures of the Simpson family; Homer, Marge, Bart, Lisa and Maggie, as well as a virtual cast of thousands. Since the beginning, the series has been a pop culture icon, attracting hundreds of celebrities to guest star. The show has also made name for itself in its fearless satirical take on politics, media and American life in general.',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        )
      ],
    );
  }
}
