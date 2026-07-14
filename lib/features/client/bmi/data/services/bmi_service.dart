import 'package:the_warehouse_gym/core/network/api_client.dart';

class BmiService {
  final ApiClient _client;

  const BmiService(this._client);

  Future<List<Map<String, dynamic>>> getBmiHistory(String uid) async {
    final list = await _client.getData<List<dynamic>>('/client/bmi');
    return list.cast<Map<String, dynamic>>();
  }

  Future<void> addBmiEntry(
    String uid, {
    required double bmiValue,
    required double heightCm,
    required double weightKg,
    DateTime? recordedAt,
  }) {
    return _client.postData<dynamic>(
      '/client/bmi',
      body: {
        'bmiValue': bmiValue,
        'heightCm': heightCm,
        'weightKg': weightKg,
        if (recordedAt != null)
          'recordedAt': recordedAt.toUtc().toIso8601String(),
      },
    );
  }

  Future<void> deleteBmiEntry(String entryId) {
    return _client.deleteData<dynamic>('/client/bmi/$entryId');
  }
}
