import 'package:tv_series/src/models/movie.dart';
import 'package:tv_series/src/models/subUser.dart';

class FinishedMovie {

  SubUser? user;
  int? userId;
  Movie movie;
  int movieId;
  
  FinishedMovie(this.movie,this.movieId);
}
