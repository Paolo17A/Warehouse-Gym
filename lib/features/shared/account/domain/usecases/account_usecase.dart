import 'package:dartz/dartz.dart';
import 'package:the_warehouse_gym/core/errors/failures.dart';
import 'package:the_warehouse_gym/features/shared/account/domain/entities/full_user.dart';
import 'package:the_warehouse_gym/features/shared/account/domain/repositories/account_repository.dart';

class AccountUseCase {
  final AccountRepository _repository;

  const AccountUseCase(this._repository);

  Future<Either<Failure, FullUser>> getProfile(String uid) =>
      _repository.getProfile(uid);

  Future<Either<Failure, void>> updateProfile(
    String uid,
    Map<String, dynamic> data,
  ) =>
      _repository.updateProfile(uid, data);

  Future<Either<Failure, String>> uploadProfileImage(
    String uid,
    String filePath,
  ) =>
      _repository.uploadProfileImage(uid, filePath);
}
