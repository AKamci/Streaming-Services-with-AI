import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tv_series/src/constants/routes.dart';

class Grid extends StatelessWidget {
  const Grid({Key? key}) : super(key: key);

  Future<Anime> futureAnime() async {
    return fetchAnime();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      padding: const EdgeInsets.all(5),
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.teal[100],
          child: const Text("He'd have you all unravel at the"),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.teal[200],
          child: const Text("lalalal"),
        ),
        Scaffold(
          body: InkWell(
            onTap: () {
              context.go('$showsPageRoute/$showDetailsPageRoute:123');
            },
            child: Center(
                child: FutureBuilder<Anime>(
                    future: futureAnime(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(snapshot.data!.title);
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }

                      return const CircularProgressIndicator();
                    })),
          ),
        )
      ],
    );
  }
}

/*
class Grid extends StatefulWidget {
  const Grid({super.key});

  @override
  State<Grid> createState() => _Grid();
}

class _Grid extends State<Grid> {
  late Future<Anime> futureAnime;
  @override
  void initState() {
    super.initState();
    futureAnime = fetchAnime();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      padding: const EdgeInsets.all(5),
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.teal[100],
          child: const Text("He'd have you all unravel at the"),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.teal[200],
          child: const Text("lalalal"),
        ),
        Scaffold(
          body: Center(
            child: FutureBuilder<Anime>(
                future: futureAnime,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data!.title);
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  return const CircularProgressIndicator();
                }),
          ),
        )
      ],
    );
  }
}
*/

Future<Anime> fetchAnime() async {
  final response =
      await http.get(Uri.parse('https://api.jikan.moe/v4/anime/47160'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Anime.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Anime');
  }
}

class Anime {
  final String title;

  const Anime({
    required this.title,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      title: json['data']['title'] as String,
    );
  }
}
