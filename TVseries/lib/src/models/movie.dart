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
  //Movie({required this.MovieName, required this.MoviePoster, required this.MovieDescription, required this.ReleaseYear, required this.Director, required this.Cast, required this.Category, required this.Views});
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      MovieName: json['MovieName'],
      MoviePoster: json['MoviePoster'],
      MovieDescription: json['MovieDescription'],
      ReleaseYear: json['ReleaseYear'],
      Director: json['Director'],
      Cast: json['Cast'],
      Category: json['Category'],
      Views: json['Views'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'MovieName': MovieName,
      'MoviePoster': MoviePoster,
      'MovieDescription': MovieDescription,
      'ReleaseYear': ReleaseYear?.toIso8601String(),
      'Director': Director,
      'Cast': Cast,
      'Category': Category,
      'Views': Views,
    };
  }
}
