import 'package:dartz/dartz.dart';
import 'package:the_warehouse_gym/core/errors/failures.dart';
import '../entities/app_user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AppUser>> signIn(String email, String password);

  Future<Either<Failure, void>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, void>> forgotPassword(String email);

  Future<Either<Failure, Map<String, dynamic>>> getCurrentUserData();

  Future<Either<Failure, void>> updateCurrentUserData(
    Map<String, dynamic> data,
  );
}
