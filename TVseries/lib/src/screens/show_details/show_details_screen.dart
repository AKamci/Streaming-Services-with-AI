import 'package:flutter/material.dart';

class ShowInfoPage extends StatelessWidget {
  final String imageUrl = 'https://via.placeholder.com/350x150';
  final String title = 'Show Title';
  final String genre = 'Action, Drama';
  final String rating = '8.5/10';
  final String description =
      'This is a brief description of the show. It talks about the main plot, the characters, and why it is interesting.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(title, style: TextStyle(fontSize: 16)),
              background: Image.network(imageUrl, fit: BoxFit.cover),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          genre,
                          style: TextStyle(
                              fontSize: 16, fontStyle: FontStyle.italic),
                        ),
                      ),
                      Text(
                        '⭐ $rating',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    description,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .secondary, // foreground color
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
          ),
        ],
      ),
    );
  }
}
