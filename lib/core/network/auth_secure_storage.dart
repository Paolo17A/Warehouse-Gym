import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthSecureStorage {
  static const _tokenKey = 'auth_token';
  static const _emailKey = 'saved_email';
  static const _passwordKey = 'saved_password';

  final FlutterSecureStorage _storage;

  const AuthSecureStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  Future<String?> getToken() => _storage.read(key: _tokenKey);

  Future<void> saveToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  Future<String?> getEmail() => _storage.read(key: _emailKey);

  Future<String?> getPassword() => _storage.read(key: _passwordKey);

  Future<void> saveCredentials({
    required String email,
    required String password,
  }) async {
    await _storage.write(key: _emailKey, value: email);
    await _storage.write(key: _passwordKey, value: password);
  }

  Future<void> saveAuth({
    required String token,
    required String email,
    required String password,
  }) async {
    await saveToken(token);
    await saveCredentials(email: email, password: password);
  }

  Future<void> clearAll() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _emailKey);
    await _storage.delete(key: _passwordKey);
  }
}
