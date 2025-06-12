import '../../core/network/api_client.dart';
import '../models/status_model.dart';

class StatusRepository {
  final ApiClient apiClient = ApiClient();

  Future<List<StatusModel>> fetchStatus() async {
    final response = await apiClient.get('/staff/status');
    final data = response['data'] as List;
    return data.map((json) => StatusModel.fromJson(json)).toList();
  }

  Future<void> submitStatus(StatusModel status) async {
    await apiClient.post('/staff/status', status.toJson());
  }
}
