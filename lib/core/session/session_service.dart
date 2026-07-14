import 'dart:async';

import 'package:the_warehouse_gym/core/network/api_client.dart';
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

  /// Restores a previous session from secure storage.
  /// Prefers the saved JWT via `/auth/me`, then falls back to email/password.
  Future<void> tryAutoLogin() async {
    _isBootstrapping = true;
    try {
      final token = await _storage.getToken();
      if (token != null && token.isNotEmpty) {
        final restored = await _restoreFromToken();
        if (restored) return;
      }

      final email = await _storage.getEmail();
      final password = await _storage.getPassword();
      if (email == null ||
          password == null ||
          email.isEmpty ||
          password.isEmpty) {
        _setUser(null);
        return;
      }

      await _restoreFromCredentials(email, password);
    } catch (_) {
      // Keep stored credentials; user can retry when the network is back.
      _setUser(null);
    } finally {
      _isBootstrapping = false;
    }
  }

  Future<bool> _restoreFromToken() async {
    try {
      final user = await _authService.getMe();
      _setUser(user.toEntity());
      return true;
    } on ApiException catch (e) {
      final unauthorized = e.statusCode == 401 || e.statusCode == 403;
      if (unauthorized) {
        // Token is no longer valid — try credentials or clear below.
        return false;
      }
      // Transient server/network error: keep storage, stay logged out for now.
      _setUser(null);
      return true;
    }
  }

  Future<void> _restoreFromCredentials(String email, String password) async {
    try {
      final result = await _authService.login(email, password);
      await _storage.saveAuth(
        token: result.token,
        email: email,
        password: password,
      );
      _setUser(result.user.toEntity());
    } on ApiException catch (e) {
      final unauthorized = e.statusCode == 401 || e.statusCode == 403;
      if (unauthorized) {
        await _storage.clearAll();
      }
      _setUser(null);
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
    // Clear UI session first so home pages don't refetch with a wiped token.
    _setUser(null);
    await _storage.clearAll();
  }

  void markAccountInitialized() {
    final user = _currentUser;
    if (user == null || user.accountInitialized) return;
    _setUser(
      AppUser(
        uid: user.uid,
        email: user.email,
        accountType: user.accountType,
        accountInitialized: true,
        profileImageURL: user.profileImageURL,
      ),
    );
  }

  void _setUser(AppUser? user) {
    _currentUser = user;
    _controller.add(user);
  }

  void dispose() {
    _controller.close();
  }
}
