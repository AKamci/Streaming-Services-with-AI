import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tv_series/src/constants/routes.dart';
import 'package:tv_series/src/models/favoriteMovie.dart';
import 'package:tv_series/src/models/movie.dart';

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
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              context.goNamed('fav_details_routes', extra: widget.media);
            },
            splashColor: Colors.white10,
            child: Ink.image(
              fit: BoxFit.fill,
              image: AssetImage(
                  'assets/images/moviePosters/${widget.media.MoviePoster}'),
              height: double.infinity,
              width: double.infinity,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 0.2,
                    blurRadius: 8,
                  ),
                ],
              ),
              child: IconButton(
                iconSize: 36.0, // Default icon size is 24.0, so 1.5x is 36.0
                icon: Icon(
                  isFavorite ? Icons.star : Icons.star_border,
                  color: isFavorite ? Colors.yellow : Colors.white,
                ),
                onPressed: toggleFavorite,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black54,
              padding: EdgeInsets.all(8.0),
              child: Text(
                widget.media.MovieName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
