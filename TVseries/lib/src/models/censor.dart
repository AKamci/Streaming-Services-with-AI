class Censor {
  final int? UserId;
  final String ClassName;

  Censor({
    this.UserId,
    required this.ClassName,
  });
  factory Censor.fromJson(Map<String, dynamic> json) {
    return Censor(
      UserId: json['value']['UserId'],
      ClassName: json['value']['ClassName'],
    );
  }

  toJson() {}
}
