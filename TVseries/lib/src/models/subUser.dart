import 'package:tv_series/src/models/censor.dart';
import 'package:tv_series/src/models/movie.dart';

class SubUser {
  int CustomerId=0;

  String Name;

  String Surname;

  String Image;

  String Title;

  String Description;

  int? PIN;

  int LastWatchedId=0;

  Movie? LastWatched;

  List<Movie>? Movies;
  
  List<Movie>? FavoriteMovies ;

  List<FinishedMovie>? FinishedMovies ;

  List<Censor>? Censors;

  SubUser(this.CustomerId, this.Name, this.Surname, this.Image, this.Title, this.Description, this.PIN);
}

class FinishedMovie {
}
