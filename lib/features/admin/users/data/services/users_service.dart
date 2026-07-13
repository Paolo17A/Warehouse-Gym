import 'package:the_warehouse_gym/core/network/api_client.dart';
import 'package:the_warehouse_gym/core/session/session_service.dart';
import 'package:the_warehouse_gym/features/client/workout/data/services/workout_service.dart';
import 'package:the_warehouse_gym/features/shared/account/data/services/trainer_request_service.dart';

class UsersService {
  final ApiClient _client;
  final WorkoutService _workoutService;
  final TrainerRequestService _trainerRequests;
  final SessionService _session;

  UsersService(
    this._client,
    this._workoutService,
    this._trainerRequests,
    this._session,
  );

  Future<List<Map<String, dynamic>>> getAllClients() async {
    final list = await _client.getData<List<dynamic>>('/admin/clients');
    return _normalizeUsers(list);
  }

  Future<List<Map<String, dynamic>>> getAllTrainers() async {
    final isAdmin = _session.currentUser?.accountType.toUpperCase() == 'ADMIN';
    final path = isAdmin ? '/admin/trainers' : '/client/trainers';
    final list = await _client.getData<List<dynamic>>(path);
    return _normalizeUsers(list);
  }

  Future<void> addTrainer({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String idNumber,
  }) {
    return _client.postData<dynamic>(
      '/admin/trainers',
      body: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'idNumber': idNumber,
      },
    );
  }

  Future<List<Map<String, dynamic>>> getTrainerCurrentClients(
    String trainerUid,
  ) async {
    final list = await _fetchTrainerClients(trainerUid);
    return list
        .where((c) => (c['clientStatus'] as String? ?? '') == 'CONFIRMED')
        .toList();
  }

  Future<List<Map<String, dynamic>>> getTrainerSchedule(
    String trainerUid,
  ) async {
    return _workoutService.getTrainerSchedule(trainerUid);
  }

  Future<void> confirmClient(String trainerUid, String clientUid) {
    final isAdmin = _session.currentUser?.accountType.toUpperCase() == 'ADMIN';
    if (isAdmin) {
      return _client.postData<dynamic>(
        '/admin/trainers/$trainerUid/clients/$clientUid/confirm',
      );
    }
    return _trainerRequests.acceptRequest(clientUid);
  }

  Future<void> rejectClient(String trainerUid, String clientUid) {
    return _trainerRequests.rejectRequest(clientUid);
  }

  Future<void> removeClient(String trainerUid, String clientUid) {
    final isAdmin = _session.currentUser?.accountType.toUpperCase() == 'ADMIN';
    if (isAdmin) {
      return _client.deleteData<dynamic>(
        '/admin/trainers/$trainerUid/clients/$clientUid',
      );
    }
    return _client.deleteData<dynamic>('/trainer/clients/$clientUid');
  }

  Future<List<Map<String, dynamic>>> getTrainerClientsOverview(
    String trainerUid,
  ) async {
    return _fetchTrainerClients(trainerUid);
  }

  Future<void> deleteTrainer(String trainerUid) {
    return _client.deleteData<dynamic>('/admin/trainers/$trainerUid');
  }

  Future<List<Map<String, dynamic>>> _fetchTrainerClients(
    String trainerUid,
  ) async {
    final isAdmin = _session.currentUser?.accountType.toUpperCase() == 'ADMIN';
    final path = isAdmin
        ? '/admin/trainers/$trainerUid/clients'
        : '/trainer/clients';
    final list = await _client.getData<List<dynamic>>(path);
    return _normalizeUsers(list);
  }

  List<Map<String, dynamic>> _normalizeUsers(List<dynamic> list) {
    return list.map((item) {
      final map = Map<String, dynamic>.from(item as Map);
      final uid = map['uid'] as String? ?? map['id'] as String? ?? '';
      return {'uid': uid, ...map};
    }).toList();
  }
}
