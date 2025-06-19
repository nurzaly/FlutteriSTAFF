class StatusModel {
  final String? name;
  final String type;
  final String? notes;
  final DateTime startDate;
  final DateTime? endDate;
  final String? startTime;
  final String? endTime;

  StatusModel({
    required this.type,
    required this.startDate,
    this.notes,
    this.name, 
    this.endDate,
    this.startTime,
    this.endTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'notes': notes,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  factory StatusModel.fromJson(Map<String, dynamic> json) {
    return StatusModel(
      name: json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      notes: json['notes']?.toString() ?? '',
      startDate:
          json['startDate'] != null
              ? DateTime.tryParse(json['startDate'].toString()) ??
                  DateTime(1970)
              : DateTime(1970),
      endDate:
          json['endDate'] != null
              ? DateTime.tryParse(json['endDate'].toString())
              : null,
      startTime: json['startTime']?.toString(),
      endTime: json['endTime']?.toString(),
    );
  }
}
