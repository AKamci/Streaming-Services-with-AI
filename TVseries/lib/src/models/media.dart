class Media {
  final String title;
  final String posterPath;
  final String overview;
  final String releaseDate;
  final String season;

  Media({required this.title, required this.posterPath, required this.overview, required this.releaseDate, required this.season});

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      title: json['title'],
      posterPath: json['poster_path'],
      releaseDate: json['release_date'],
      overview: json['overview'],
      season: json['season'],
    );
  }
}
