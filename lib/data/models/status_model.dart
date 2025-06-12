class StatusModel {
  final String type;
  final String notes;
  final DateTime startDate;
  final DateTime? endDate;
  final String? startTime;
  final String? endTime;

  StatusModel({
    required this.type,
    required this.notes,
    required this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
  });

  Map<String, dynamic> toJson() {
    return {
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
      type: json['type'],
      notes: json['notes'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }
}
