import 'package:flutter/material.dart';
import 'package:tv_series/src/models/movie.dart';

import './media_card.dart';

class MediaGrid extends StatelessWidget {
  final List<Movie> media;

  MediaGrid({required this.media});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      
      itemCount: media.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
      ),
      itemBuilder: (context, index) {
        return MediaCard(media: media[index]);
      },
    );
  }
}
