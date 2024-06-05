class Censor {
  final int ClassId;
  final int? id;
  final String ClassName;

  Censor({
    required this.ClassId,
    required this.ClassName,
    this.id,
  });
  factory Censor.fromJson(Map<String, dynamic> json) {
    return Censor(
        id: json['id'], ClassId: json['classId'], ClassName: json['className']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'classId': ClassId,
      'className': ClassName,
    };
  }
}
