import 'package:the_warehouse_gym/core/network/api_client.dart';

class MessagingService {
  final ApiClient _client;

  const MessagingService(this._client);

  Future<List<Map<String, dynamic>>> listThreads() async {
    final list = await _client.getData<List<dynamic>>('/client/messages/threads');
    return list.cast<Map<String, dynamic>>();
  }
}
