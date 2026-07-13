import 'package:the_warehouse_gym/core/network/api_client.dart';
import 'package:the_warehouse_gym/features/shared/auth/data/models/user_model.dart';

class AuthResult {
  final String token;
  final UserModel user;

  const AuthResult({required this.token, required this.user});
}

class AuthService {
  final ApiClient _client;

  const AuthService(this._client);

  Future<AuthResult> login(String email, String password) async {
    final data = await _client.postData<Map<String, dynamic>>(
      '/auth/login',
      body: {'email': email, 'password': password},
    );
    return _parseAuthResult(data);
  }

  Future<AuthResult> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final data = await _client.postData<Map<String, dynamic>>(
      '/auth/register',
      body: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
      },
    );
    return _parseAuthResult(data);
  }

  Future<void> forgotPassword(String email) async {
    await _client.postData<dynamic>(
      '/auth/forgot-password',
      body: {'email': email},
    );
  }

  Future<UserModel> getMe() async {
    final data = await _client.getData<Map<String, dynamic>>('/auth/me');
    return UserModel.fromJson(data);
  }

  AuthResult _parseAuthResult(Map<String, dynamic> data) {
    final token = data['token'] as String? ?? '';
    final userJson = data['user'] as Map<String, dynamic>? ?? {};
    return AuthResult(token: token, user: UserModel.fromJson(userJson));
  }
}
