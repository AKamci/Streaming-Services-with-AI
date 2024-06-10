class favoriteMovie {
  final int? id;
  final int userId;
  final int movieId;

  favoriteMovie({
    this.id,
    required this.userId,
    required this.movieId,
  });

  factory favoriteMovie.fromJson(Map<String, dynamic> json) {
    return favoriteMovie(
      id: json['id'],
      userId: json['userId'],
      movieId: json['movieId'],
    );
  }
  Map<String, dynamic> toJson() {
    return {'userId': userId, 'movieId': movieId};
  }
}
