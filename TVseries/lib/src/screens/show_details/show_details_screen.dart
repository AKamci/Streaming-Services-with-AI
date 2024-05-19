import 'package:flutter/material.dart';
import 'package:tv_series/src/models/media.dart';
import 'package:tv_series/src/router/router.dart';

import '../../constants/routes.dart';

class ShowDetailPage extends StatelessWidget {
  final Media media;

  ShowDetailPage({required this.media});

  @override
  Widget build(BuildContext context) {
    String title = media.title;
    String posterUrl = media.posterPath;
    String releaseDate = media.releaseDate;
    String description = media.overview;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
              onTap: () {}, // Image tapped
              child: Image.asset(
                posterUrl,
                width: double.infinity,
                //height: 200,
                fit: BoxFit.fill,
              ),
          ),
          
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    // Overview butonuna tıklama işlemleri
                  },
                  child: Text(
                    'OVERVIEW',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Season butonuna tıklama işlemleri
                  },
                  child: Text(
                    'SEASON',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                //TextButton(
                //  onPressed: () {
                //    // See Also butonuna tıklama işlemleri
                //  },
                //  child: Text(
                //    'SEE ALSO',
                //    style: TextStyle(color: Colors.grey),
                //  ),
                //),
              ],
            ),
          ),




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
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              '1989 • Returning Series • Comedy, Family • Fox Broadcasting Company',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Set in Springfield, the average American town, the show focuses on the antics and everyday adventures of the Simpson family; Homer, Marge, Bart, Lisa and Maggie, as well as a virtual cast of thousands. Since the beginning, the series has been a pop culture icon, attracting hundreds of celebrities to guest star. The show has also made name for itself in its fearless satirical take on politics, media and American life in general.',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          
        ],
      ),
    );
  }
}
