class Holiday {
  final int id;
  final String name;
  final DateTime date;

  Holiday({
    required this.id,
    required this.name,
    required this.date,
  });

  factory Holiday.fromJson(Map<String, dynamic> json) {
    return Holiday(
      id: json['id'] as int,
      name: json['name'] as String,
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String().split('T').first,
    };
  }
}