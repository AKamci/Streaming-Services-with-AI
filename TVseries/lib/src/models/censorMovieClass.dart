import 'package:tv_series/src/models/censor.dart';
import 'package:tv_series/src/models/movie.dart';

class MovieCensorData {
  final List<Censor> censorList;
  final Movie media;
  MovieCensorData({required this.censorList, required this.media});
}
