import 'package:tv_series/src/models/censor.dart';
import 'package:tv_series/src/models/movie.dart';

class SubUser {
  int? customerId;
  int? userId;
  String? name;
  String? surname;
  String? image;
  String? title;
  String? description;
  int? pin;
  int? lastWatchedId;
  Movie? lastWatched;
  List<Movie>? movies;
  List<Movie>? favoriteMovies;
  List<FinishedMovie>? finishedMovies;
  List<int>? censors;

  SubUser({
    this.userId,
    this.customerId,
    this.name,
    this.surname,
    this.image,
    this.title,
    this.description,
    this.pin,
    this.lastWatchedId,
    this.lastWatched,
    this.movies,
    this.favoriteMovies,
    this.finishedMovies,
    this.censors,
  });

  factory SubUser.fromJson(Map<String, dynamic> json) {
    return SubUser(
      userId: json['id'],
      customerId: json['customerId'],
      name: json['name'],
      surname: json['surname'],
      image: json['image'],
      title: json['title'],
      description: json['description'],
      pin: json['pin'],
      lastWatchedId: json['lastWatchedId'],
      lastWatched: json['lastWatched'] != null
          ? Movie.fromJson(json['lastWatched'])
          : null,
      movies: (json['movies'] as List?)
          ?.map((item) => Movie.fromJson(item))
          .toList(),
      favoriteMovies: (json['favoriteMovies'] as List?)
          ?.map((item) => Movie.fromJson(item))
          .toList(),
      finishedMovies: (json['finishedMovies'] as List?)
          ?.map((item) => FinishedMovie.fromJson(item))
          .toList(),
      censors: List<int>.from(json['censorsId'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'name': name,
      'surname': surname,
      'image': image,
      'title': title,
      'description': description
    };
  }

  Map<String, dynamic> toJsonUpdate() {
    return {
      'id': userId,
      'customerId': customerId,
      'name': name,
      'surname': surname,
      'image': image,
      'title': title,
      'description': description,
      'pin': pin,
      'lastWatchedId': lastWatchedId,
      'censorsId': censors
    };
  }
}

class FinishedMovie {
  final String movieName;
  final DateTime finishedDate;

  FinishedMovie({required this.movieName, required this.finishedDate});

  factory FinishedMovie.fromJson(Map<String, dynamic> json) {
    return FinishedMovie(
      movieName: json['movieName'],
      finishedDate: DateTime.parse(json['finishedDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'movieName': movieName,
      'finishedDate': finishedDate.toIso8601String(),
    };
  }
}
