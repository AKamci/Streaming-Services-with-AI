import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tv_series/src/constants/routes.dart';
import 'package:tv_series/src/models/movie.dart';

import 'package:tv_series/src/models/favoriteMovie.dart';

class MediaCard extends StatefulWidget {
  final Movie media;
  final favoriteMovie? favorites;

  MediaCard({super.key, required this.media, this.favorites});

  @override
  State<MediaCard> createState() => _MediaCardState();
}

class _MediaCardState extends State<MediaCard> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    if (widget.favorites != null) {
      isFavorite = true;
    } else {
      isFavorite = false;
    }
  }

  Future<void> toggleFavorite() async {
    bool isSuccess;
    if (!isFavorite) {
      isSuccess =
          await apiService.postFavorites(apiService.subUserId, widget.media);
    } else {
      if (widget.favorites == null) {
        isSuccess = false;
      } else {
        isSuccess = await apiService.deleteFavorites(widget.favorites!);
      }
    }

    if (isSuccess) {
      setState(() {
        isFavorite = !isFavorite;
        // Favori durumunu güncelleyici işlevi burada çağırabilirsiniz, örneğin:
        // apiService.updateFavoriteStatus(widget.media.id, isFavorite);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: InkWell(
              onTap: () {
                context.go('/$shows_route/$details_route', extra: widget.media);
              }, // Image tapped
              splashColor: Colors.white10, // Splash color over image
              child: Ink.image(
                fit: BoxFit.fill, // Fixes border issues
                image: AssetImage(
                    'assets/images/moviePosters/${widget.media.MoviePoster}'),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.media.MovieName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.star : Icons.star_border,
                        color: isFavorite ? Colors.yellow : null,
                      ),
                      onPressed: toggleFavorite,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
