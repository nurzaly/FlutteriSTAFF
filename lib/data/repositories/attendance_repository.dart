import 'package:istaff/data/models/holiday_model.dart';
import 'package:istaff/data/models/status_model.dart';

import '../../core/network/api_client.dart';
import '../models/attendance_model.dart';

class AttendanceResponse {
  final List<Attendance> attendances;
  final List<Holiday> holidays;
  final List<StatusModel> statuses;

  AttendanceResponse({
    required this.attendances,
    required this.holidays,
    required this.statuses,
  });

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceResponse(
      attendances: (json['attendances'] as List)
          .map((e) => Attendance.fromJson(e))
          .toList(),
      holidays: (json['holidays'] as List)
          .map((e) => Holiday.fromJson(e))
          .toList(),
      statuses: (json['statuses'] as List)
          .map((e) => StatusModel.fromJson(e))
          .toList(),
    );
  }
}


class AttendanceRepository {
  final ApiClient apiClient = ApiClient();

  Future<AttendanceResponse> fetchUserAttendances(String month) async {
    final response = await apiClient.get('/staff/attendances?selectedMonth=$month');
    // final data = response['attendances'] as List;
     return AttendanceResponse.fromJson(response);

  // Future<Map<String, dynamic>> submitStatus(StatusModel status) async {
  //   // print("Submitting : ${status.toJson()}");
  //   final data = await apiClient.post('/staff/status', status.toJson());
  //   return data as Map<String, dynamic>;
  }
}
