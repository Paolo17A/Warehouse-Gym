import 'package:the_warehouse_gym/core/network/api_client.dart';
import 'package:the_warehouse_gym/core/session/session_service.dart';

class ProfileService {
  final ApiClient _client;
  final SessionService _session;

  const ProfileService(this._client, this._session);

  String get _rolePrefix {
    final type = _session.currentUser?.accountType.toUpperCase() ?? 'CLIENT';
    switch (type) {
      case 'TRAINER':
        return '/trainer';
      case 'ADMIN':
        return '/admin';
      default:
        return '/client';
    }
  }

  Future<Map<String, dynamic>> getMyProfile() async {
  if (_session.currentUser?.accountType.toUpperCase() == 'ADMIN') {
      return _client.getData<Map<String, dynamic>>('/auth/me');
    }
    return _client.getData<Map<String, dynamic>>('$_rolePrefix/profile');
  }

  Future<Map<String, dynamic>> getUserData(String uid) async {
    final currentUid = _session.currentUser?.uid;
    if (currentUid == uid) return getMyProfile();

    final accountType = _session.currentUser?.accountType.toUpperCase() ?? '';
    if (accountType == 'ADMIN') {
      final client = await _findInList('/admin/clients', uid);
      if (client != null) return client;
      final trainer = await _findInList('/admin/trainers', uid);
      if (trainer != null) return trainer;
      throw Exception('User not found.');
    }
    if (accountType == 'TRAINER') {
      final client = await _findInList('/trainer/clients', uid);
      if (client != null) return client;
      throw Exception('User not found.');
    }
    final trainers = await _client.getData<List<dynamic>>('/client/trainers');
    return _findInDynamicList(trainers, uid) ??
        (throw Exception('User not found.'));
  }

  Future<Map<String, dynamic>?> _findInList(String path, String uid) async {
    final list = await _client.getData<List<dynamic>>(path);
    return _findInDynamicList(list, uid);
  }

  Map<String, dynamic>? _findInDynamicList(List<dynamic> list, String uid) {
    for (final item in list) {
      if (item is! Map<String, dynamic>) continue;
      final itemUid = item['uid'] as String? ?? item['id'] as String? ?? '';
      if (itemUid == uid) return item;
    }
    return null;
  }

  Future<Map<String, dynamic>> updateUser(Map<String, dynamic> data) {
    return _client.patchData<Map<String, dynamic>>(
      '$_rolePrefix/profile',
      body: data,
    );
  }

  Future<Map<String, dynamic>> uploadImage(String filePath) {
    return _client.uploadMultipart<Map<String, dynamic>>(
      '$_rolePrefix/profile/image',
      field: 'image',
      filePath: filePath,
    );
  }
}
