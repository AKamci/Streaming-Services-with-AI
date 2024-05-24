class Movie {
  final String MovieName;
  final String MoviePoster;
  final String MovieDescription;
  final DateTime? ReleaseYear;
  final String? Director;
  final String? Cast;
  final String? Category;
  final int? Views;

  Movie({
    required this.MovieName,
    required this.MoviePoster,
    required this.MovieDescription,
    this.ReleaseYear,
    this.Director,
    this.Cast,
    this.Category,
    this.Views,
  });

  //     var myvalue = json['value'];
  //   List<Movie> movieList= [];
  //   for (var movieVal in myvalue) {
  //     movieList.add(
  //       Movie(MovieName: movieVal, MoviePoster: MoviePoster, MovieDescription: MovieDescription)
  //       );
  //   }

  //Movie({required this.MovieName, required this.MoviePoster, required this.MovieDescription, required this.ReleaseYear, required this.Director, required this.Cast, required this.Category, required this.Views});
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      MovieName: json['value']['movieName'],
      MoviePoster: json['value']['moviePoster'],
      MovieDescription: json['value']['movieDescription'],
      ReleaseYear: json['value']['releaseYear'],
      Director: json['value']['director'],
      Cast: json['value']['cast'],
      Category: json['value']['category'],
      Views: json['value']['views'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'movieName': MovieName,
      'moviePoster': MoviePoster,
      'movieDescription': MovieDescription,
      'releaseYear': ReleaseYear?.toIso8601String(),
      'director': Director,
      'cast': Cast,
      'category': Category,
      'views': Views,
    };
  }
}
