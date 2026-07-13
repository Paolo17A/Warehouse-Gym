import 'package:dartz/dartz.dart';
import 'package:the_warehouse_gym/core/errors/failures.dart';
import '../repositories/users_repository.dart';

class UsersUseCase {
  final UsersRepository _repository;

  const UsersUseCase(this._repository);

  Future<Either<Failure, List<Map<String, dynamic>>>> getAllClients() =>
      _repository.getAllClients();

  Future<Either<Failure, List<Map<String, dynamic>>>> getAllTrainers() =>
      _repository.getAllTrainers();

  Future<Either<Failure, void>> addTrainer({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String idNumber,
  }) =>
      _repository.addTrainer(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        idNumber: idNumber,
      );

  Future<Either<Failure, List<Map<String, dynamic>>>> getTrainerCurrentClients(
    String trainerUid,
  ) =>
      _repository.getTrainerCurrentClients(trainerUid);

  Future<Either<Failure, List<Map<String, dynamic>>>> getTrainerSchedule(
    String trainerUid,
  ) =>
      _repository.getTrainerSchedule(trainerUid);

  Future<Either<Failure, void>> confirmClient(
    String trainerUid,
    String clientUid,
  ) =>
      _repository.confirmClient(trainerUid, clientUid);

  Future<Either<Failure, void>> removeClient(
    String trainerUid,
    String clientUid,
  ) =>
      _repository.removeClient(trainerUid, clientUid);

  Future<Either<Failure, void>> deleteTrainer(String trainerUid) =>
      _repository.deleteTrainer(trainerUid);
}
