import 'package:flutter/material.dart';
import 'package:tv_series/src/constants/routes.dart';
import 'package:tv_series/src/router/router.dart';

import '/src/models/media.dart';

class MediaCard extends StatelessWidget {
  final Media media;

  MediaCard({required this.media});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                
                router.go('$shows_route/$details_route',extra: media);
                }, // Image tapped
              splashColor: Colors.white10, // Splash color over image
              child: Ink.image(
                fit: BoxFit.cover, // Fixes border issues
                image: AssetImage(media.posterPath),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              media.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),//context.go('/movie_detail', extra: movie);
        ],
      ),
    );
  }
}
