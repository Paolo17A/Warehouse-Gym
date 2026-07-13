import 'package:dartz/dartz.dart';
import 'package:the_warehouse_gym/core/errors/failures.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class AuthUseCase {
  final AuthRepository _repository;

  const AuthUseCase(this._repository);

  Future<Either<Failure, AppUser>> signIn(String email, String password) =>
      _repository.signIn(email, password);

  Future<Either<Failure, void>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) =>
      _repository.signUp(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
      );

  Future<Either<Failure, void>> signOut() => _repository.signOut();

  Future<Either<Failure, void>> forgotPassword(String email) =>
      _repository.forgotPassword(email);

  Future<Either<Failure, Map<String, dynamic>>> getCurrentUserData() =>
      _repository.getCurrentUserData();

  Future<Either<Failure, void>> updateCurrentUserData(
    Map<String, dynamic> data,
  ) =>
      _repository.updateCurrentUserData(data);
}
