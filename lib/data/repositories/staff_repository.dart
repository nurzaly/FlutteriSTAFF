import '../../core/network/api_client.dart';
import '../models/status_model.dart';

class StaffRepository {
  final ApiClient apiClient = ApiClient();

  Future<List<Map<String, dynamic>>> fetchStaff() async {
    final response = await apiClient.get('/staff');
    final data = response['data'] as List;
    return data.map((item) => item as Map<String, dynamic>).toList();
  }

  Future<List<Map<String, dynamic>>> fetchCountUserStatus() async {
    final response = await apiClient.get('/dashboard/status');
    final data = response['data'] as List;
    return data.map((item) => item as Map<String, dynamic>).toList();
  }

  Future<Map<String, dynamic>> submitStatus(StatusModel status) async {
    // print("Submitting : ${status.toJson()}");
    final data = await apiClient.post('/staff/status', status.toJson());
    return data as Map<String, dynamic>;
  }
}
