class Movie {
  final int? id;
  final String MovieName;
  final String MoviePoster;
  final String MovieDescription;
  final String? ReleaseYear;
  final String? Director;
  final List<String?>? Cast;
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
    this.id,
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
      id: json['id'],
      MovieName: json['movieName'],
      MoviePoster: json['moviePoster'],
      MovieDescription: json['movieDescription'],
      ReleaseYear: json['releaseYear'],
      Director: json['director'],
      //Cast: json['cast'],
      //Category: json['category'],
      Views: json['views'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'movieName': MovieName,
      'moviePoster': MoviePoster,
      'movieDescription': MovieDescription,
      'releaseYear': ReleaseYear,
      'director': Director,
      'cast': Cast,
      'category': Category,
      'views': Views,
    };
  }
}
