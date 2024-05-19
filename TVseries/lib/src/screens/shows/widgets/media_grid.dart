import 'package:flutter/material.dart';
import '/src/models/media.dart';
import './media_card.dart';

class MediaGrid extends StatelessWidget {
  final List<Media> media;

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
