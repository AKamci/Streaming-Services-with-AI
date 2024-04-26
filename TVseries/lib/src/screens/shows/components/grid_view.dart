import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tv_series/src/constants/routes.dart';
import 'package:tv_series/src/screens/shows/components/widget.dart';

class Grid extends StatefulWidget {
  @override
  State<Grid> createState() => _Grid();
}

class _Grid extends State<Grid> {
  List<int> text = [1, 2, 3, 4];
  var widgets = [];

  @override
  Widget build(BuildContext context) {
    var title = Center(
        child: Text(
      "Scrollable title ${widgets.length}",
      style: TextStyle(fontSize: 30),
    ));
    var contents = [
      ...widgets,
    ];
    var Buttons = Row(
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 100,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  widgets.add(Container(
                    height: 100,
                    child: ListTile(
                      title: Text(widgets.length.toString()),
                      subtitle: Text("Contents BTN1"),
                    ),
                  ));
                });
                // _mycontroller.jumpTo(widgets.length * 100);
              },
              child: Text("BTN1"),
            ),
          ),
        )),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 100,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  if (widgets.length > 0) {
                    widgets.removeLast();
                  }
                });
                // _mycontroller.jumpTo(widgets.length * 100);
              },
              child: Text("BTN2"),
            ),
          ),
        ))
      ],
    );
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            children: [
              for (var i = 0; i < contents.length;)
                Row(
                  children: [
                    for (var z = 0; z < 2; (i++, z++))
                      if (i < contents.length)
                        Expanded(
                          child: contents[i],
                        ),
                  ],
                ),
              title,
              Buttons
            ],
          ),
        )
      ],
    );
  }
}





/*
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
        ShowCardContainer(),
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
*/