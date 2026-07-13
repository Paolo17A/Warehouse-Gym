import 'package:dartz/dartz.dart';
import 'package:the_warehouse_gym/core/errors/failures.dart';
import 'package:the_warehouse_gym/features/client/account/domain/repositories/client_account_repository.dart';
import 'package:the_warehouse_gym/features/shared/account/domain/entities/full_user.dart';

class ClientAccountUseCase {
  final ClientAccountRepository _repository;

  const ClientAccountUseCase(this._repository);

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

  Future<Either<Failure, void>> requestTrainer(
    String clientUid,
    String trainerUid,
  ) =>
      _repository.requestTrainer(clientUid, trainerUid);

  Future<Either<Failure, void>> cancelTrainerRequest(
    String clientUid,
    String trainerUid,
  ) =>
      _repository.cancelTrainerRequest(clientUid, trainerUid);

  Future<Either<Failure, bool>> hasPendingTrainerRequest(
    String clientUid,
    String trainerUid,
  ) =>
      _repository.hasPendingTrainerRequest(clientUid, trainerUid);
}
