import 'dart:async';

import 'package:the_warehouse_gym/core/network/auth_secure_storage.dart';
import 'package:the_warehouse_gym/features/shared/auth/data/services/auth_service.dart';
import 'package:the_warehouse_gym/features/shared/auth/domain/entities/app_user.dart';

class SessionService {
  final AuthSecureStorage _storage;
  final AuthService _authService;

  AppUser? _currentUser;
  bool _isBootstrapping = true;

  final _controller = StreamController<AppUser?>.broadcast();

  SessionService({
    required AuthSecureStorage storage,
    required AuthService authService,
  })  : _storage = storage,
        _authService = authService;

  AppUser? get currentUser => _currentUser;

  bool get isAuthenticated => _currentUser != null;

  bool get isBootstrapping => _isBootstrapping;

  Stream<AppUser?> get authStateChanges => _controller.stream;

  Future<void> tryAutoLogin() async {
    _isBootstrapping = true;
    try {
      final email = await _storage.getEmail();
      final password = await _storage.getPassword();
      if (email == null ||
          password == null ||
          email.isEmpty ||
          password.isEmpty) {
        _setUser(null);
        return;
      }

      final result = await _authService.login(email, password);
      await _storage.saveAuth(
        token: result.token,
        email: email,
        password: password,
      );
      _setUser(result.user.toEntity());
    } catch (_) {
      await _storage.clearAll();
      _setUser(null);
    } finally {
      _isBootstrapping = false;
    }
  }

  Future<void> setSession({
    required String token,
    required String email,
    required String password,
    required AppUser user,
  }) async {
    await _storage.saveAuth(
      token: token,
      email: email,
      password: password,
    );
    _setUser(user);
  }

  Future<void> signOut() async {
    await _storage.clearAll();
    _setUser(null);
  }

  void _setUser(AppUser? user) {
    _currentUser = user;
    _controller.add(user);
  }

  void dispose() {
    _controller.close();
  }
}
