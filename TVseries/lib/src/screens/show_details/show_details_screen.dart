import 'package:flutter/material.dart';

class ShowInfoPage extends StatelessWidget {
  final String imageUrl = 'https://via.placeholder.com/350x150';
  final String title = 'Show Title';
  final String genre = 'Genre: Action, Drama';
  final String rating = '⭐ 8.5/10';
  final String description =
      'This is a brief description of the show. It talks about the main plot, the characters, and why it is interesting.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Show Information'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(imageUrl),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                genre,
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 4),
              child: Text(
                rating,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                description,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red, // foreground (text) color
                ),
                onPressed: () {
                  // Add your action here
                },
                child: Text('Watch Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
