import 'package:tv_series/src/models/censor.dart';
import 'package:tv_series/src/models/movie.dart';

class SubUser {
  int? customerId;
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
  List<Censor>? censors;

  SubUser({
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
      customerId: json['CustomerId'],
      name: json['Name'],
      surname: json['Surname'],
      image: json['Image'],
      title: json['Title'],
      description: json['Description'],
      pin: json['PIN'],
      lastWatchedId: json['LastWatchedId'],
      lastWatched: json['LastWatched'] != null
          ? Movie.fromJson(json['LastWatched'])
          : null,
      movies: (json['Movies'] as List?)
          ?.map((item) => Movie.fromJson(item))
          .toList(),
      favoriteMovies: (json['FavoriteMovies'] as List?)
          ?.map((item) => Movie.fromJson(item))
          .toList(),
      finishedMovies: (json['FinishedMovies'] as List?)
          ?.map((item) => FinishedMovie.fromJson(item))
          .toList(),
      censors: (json['Censors'] as List?)
          ?.map((item) => Censor.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CustomerId': customerId,
      'Name': name,
      'Surname': surname,
      'Image': image,
      'Title': title,
      'Description': description,
      'PIN': pin,
      'LastWatchedId': lastWatchedId,
      'LastWatched': lastWatched?.toJson(),
      'Movies': movies?.map((item) => item.toJson()).toList(),
      'FavoriteMovies': favoriteMovies?.map((item) => item.toJson()).toList(),
      'FinishedMovies': finishedMovies?.map((item) => item.toJson()).toList(),
      'Censors': censors?.map((item) => item.toJson()).toList(),
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
