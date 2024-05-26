class Censor {
  final int? UserId;
  final int? id;
  final String ClassName;

  Censor({
    this.UserId,
    required this.ClassName,
    this.id,
  });
  factory Censor.fromJson(Map<String, dynamic> json) {
    return Censor(
      id: json['id'],
      UserId: json['userId'],
      ClassName: json['className']
    );
  }

    Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': UserId,
      'className': ClassName
    };
  }
}
