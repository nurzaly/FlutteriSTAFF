class Attendance {
  final int id;
  final int userId;
  final DateTime checktime;

  Attendance({
    required this.id,
    required this.userId,
    required this.checktime,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      checktime: DateTime.parse(json['checktime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'checktime': checktime.toIso8601String(),
    };
  }
}