import 'package:dartz/dartz.dart';
import 'package:the_warehouse_gym/core/errors/failures.dart';
import 'package:the_warehouse_gym/features/trainer/users/domain/repositories/trainer_users_repository.dart';

class TrainerUsersUseCase {
  final TrainerUsersRepository _repository;

  const TrainerUsersUseCase(this._repository);

  Future<Either<Failure, List<Map<String, dynamic>>>> getTrainerClients(
    String trainerUid,
  ) =>
      _repository.getTrainerClients(trainerUid);

  Future<Either<Failure, List<Map<String, dynamic>>>> getTrainerSchedule(
    String trainerUid,
  ) =>
      _repository.getTrainerSchedule(trainerUid);

  Future<Either<Failure, void>> confirmClient(
    String trainerUid,
    String clientUid,
  ) =>
      _repository.confirmClient(trainerUid, clientUid);

  Future<Either<Failure, void>> rejectClient(
    String trainerUid,
    String clientUid,
  ) =>
      _repository.rejectClient(trainerUid, clientUid);

  Future<Either<Failure, void>> removeClient(
    String trainerUid,
    String clientUid,
  ) =>
      _repository.removeClient(trainerUid, clientUid);
}
