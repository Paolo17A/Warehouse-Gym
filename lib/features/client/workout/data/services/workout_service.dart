import 'package:the_warehouse_gym/core/network/api_client.dart';
import 'package:the_warehouse_gym/core/session/session_service.dart';

class WorkoutService {
  final ApiClient _client;
  final SessionService _session;

  const WorkoutService(this._client, this._session);

  bool get _isTrainer =>
      _session.currentUser?.accountType.toUpperCase() == 'TRAINER';

  Future<List<Map<String, dynamic>>> getPrescribedWorkouts(String clientId) async {
    final list = await _client.getData<List<dynamic>>('/client/workouts/prescribed');
    return list.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>?> getPrescriptionById(String prescriptionId) async {
    return _client.getData<Map<String, dynamic>?>(
      '/client/workouts/prescribed/$prescriptionId',
    );
  }

  Future<void> savePrescription({
    required String clientId,
    required String prescriptionId,
    required Map<String, dynamic> data,
    String? trainerId,
  }) async {
    if (_isTrainer) {
      await _client.postData<dynamic>(
        '/trainer/workouts/prescribe',
        body: {
          'clientId': clientId,
          'workout': data['workout'],
          'description': data['description'],
        },
      );
      return;
    }

    await _client.postData<dynamic>(
      '/client/workouts/prescribed',
      body: {
        'workout': data['workout'],
        'description': data['description'],
        'workoutDate': data['workoutDate'],
      },
    );
  }

  Future<void> removePrescription(String prescriptionId) {
    return _client.deleteData<dynamic>(
      '/client/workouts/prescribed/$prescriptionId',
    );
  }

  Future<void> completeWorkout(
    String clientId,
    Map<String, dynamic> sessionData,
  ) {
    return _client.postData<void>(
      '/client/workouts/history',
      body: {
        'dateTime': sessionData['dateTime'],
        'exercises': sessionData['exercises'],
      },
      parser: (_) {},
    );
  }

  Future<List<Map<String, dynamic>>> getWorkoutHistory(String clientId) async {
    final list = await _client.getData<List<dynamic>>('/client/workouts/history');
    return list.cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> getTrainerSchedule(String trainerId) async {
    final list = await _client.getData<List<dynamic>>('/trainer/clients/schedule');
    return list.cast<Map<String, dynamic>>();
  }
}
