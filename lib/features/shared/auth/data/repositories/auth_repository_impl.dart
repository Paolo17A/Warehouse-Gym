import 'package:dartz/dartz.dart';
import 'package:the_warehouse_gym/core/errors/failures.dart';
import 'package:the_warehouse_gym/core/network/api_client.dart';
import 'package:the_warehouse_gym/core/network/network_info.dart';
import 'package:the_warehouse_gym/core/session/session_service.dart';
import 'package:the_warehouse_gym/features/shared/auth/data/models/user_model.dart';
import 'package:the_warehouse_gym/features/shared/auth/data/services/auth_service.dart';
import 'package:the_warehouse_gym/features/shared/auth/domain/entities/app_user.dart';
import 'package:the_warehouse_gym/features/shared/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final NetworkInfo _networkInfo;
  final AuthService _authService;
  final SessionService _sessionService;

  const AuthRepositoryImpl({
    required NetworkInfo networkInfo,
    required AuthService authService,
    required SessionService sessionService,
  })  : _networkInfo = networkInfo,
        _authService = authService,
        _sessionService = sessionService;

  @override
  Future<Either<Failure, AppUser>> signIn(
    String email,
    String password,
  ) async {
    if (!await _networkInfo.isConnected) return const Left(NetworkFailure());

    try {
      final result = await _authService.login(email, password);
      await _sessionService.setSession(
        token: result.token,
        email: email,
        password: password,
        user: result.user.toEntity(),
      );
      return Right(result.user.toEntity());
    } on ApiException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    if (!await _networkInfo.isConnected) return const Left(NetworkFailure());

    try {
      final result = await _authService.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
      );
      await _sessionService.setSession(
        token: result.token,
        email: email,
        password: password,
        user: result.user.toEntity(),
      );
      return const Right(null);
    } on ApiException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _sessionService.signOut();
      return const Right(null);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    if (!await _networkInfo.isConnected) return const Left(NetworkFailure());

    try {
      await _authService.forgotPassword(email);
      return const Right(null);
    } on ApiException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getCurrentUserData() async {
    if (!await _networkInfo.isConnected) return const Left(NetworkFailure());

    try {
      final user = _sessionService.currentUser;
      if (user == null) {
        return const Left(AuthFailure('No authenticated user found.'));
      }
      final model = await _authService.getMe();
      return Right(_userModelToMap(model));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateCurrentUserData(
    Map<String, dynamic> data,
  ) async {
    if (!await _networkInfo.isConnected) return const Left(NetworkFailure());

    try {
      final user = _sessionService.currentUser;
      if (user == null) {
        return const Left(AuthFailure('No authenticated user found.'));
      }
      return const Right(null);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  Map<String, dynamic> _userModelToMap(UserModel model) {
    return {
      'uid': model.uid,
      'email': model.email,
      'accountType': model.accountType,
      'accountInitialized': model.accountInitialized,
      'profileImageURL': model.profileImageURL,
    };
  }
}
