import '../../core/network/api_client.dart';
import '../models/status_model.dart';

class StatusRepository {
  final ApiClient apiClient = ApiClient();

  Future<List<StatusModel>> fetchUserStatus(String year) async {
    final response = await apiClient.get('/staff/status?year=$year');
    final data = response['data'] as List;
    return data.map((json) => StatusModel.fromJson(json)).toList();
  }

  Future<Map<String, dynamic>> submitStatus(StatusModel status) async {
    // print("Submitting : ${status.toJson()}");
    final data = await apiClient.post('/staff/status', status.toJson());
    return data as Map<String, dynamic>;
  }
}
