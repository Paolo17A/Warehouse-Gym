import 'package:the_warehouse_gym/core/network/api_client.dart';

class TrainerRequestService {
  final ApiClient _client;

  const TrainerRequestService(this._client);

  Future<void> requestTrainer(String trainerId) {
    return _client.postData<dynamic>('/client/trainer-requests/$trainerId');
  }

  Future<void> cancelTrainerRequest(String trainerId) {
    return _client.deleteData<dynamic>('/client/trainer-requests/$trainerId');
  }

  Future<bool> hasPendingRequest(String trainerId) async {
    final data = await _client.getData<Map<String, dynamic>>(
      '/client/trainer-requests/pending/$trainerId',
    );
    return data['pending'] as bool? ?? false;
  }

  Future<void> acceptRequest(String clientId) {
    return _client.postData<dynamic>('/trainer/clients/$clientId/confirm');
  }

  Future<void> rejectRequest(String clientId) {
    return _client.postData<dynamic>('/trainer/clients/$clientId/reject');
  }

  Future<List<Map<String, dynamic>>> getPendingForTrainer() async {
    final list = await _client.getData<List<dynamic>>('/trainer/requests');
    return list.cast<Map<String, dynamic>>();
  }
}
