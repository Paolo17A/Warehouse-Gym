import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/repositories/users_repository.dart';
import '../services/users_service.dart';

class UsersRepositoryImpl implements UsersRepository {
  final UsersService _service;
  final NetworkInfo _networkInfo;

  UsersRepositoryImpl({
    required UsersService service,
    required NetworkInfo networkInfo,
  })  : _service = service,
        _networkInfo = networkInfo;

  Future<Either<Failure, T>> _guardedCall<T>(Future<T> Function() call) async {
    if (!await _networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      return Right(await call());
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllClients() =>
      _guardedCall(() => _service.getAllClients());

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllTrainers() =>
      _guardedCall(() => _service.getAllTrainers());

  @override
  Future<Either<Failure, void>> addTrainer({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String idNumber,
  }) =>
      _guardedCall(() => _service.addTrainer(
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
            idNumber: idNumber,
          ));

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getTrainerCurrentClients(
          String trainerUid) =>
      _guardedCall(() => _service.getTrainerCurrentClients(trainerUid));

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getTrainerSchedule(
          String trainerUid) =>
      _guardedCall(() => _service.getTrainerSchedule(trainerUid));

  @override
  Future<Either<Failure, void>> confirmClient(
          String trainerUid, String clientUid) =>
      _guardedCall(() => _service.confirmClient(trainerUid, clientUid));

  @override
  Future<Either<Failure, void>> removeClient(
          String trainerUid, String clientUid) =>
      _guardedCall(() => _service.removeClient(trainerUid, clientUid));

  @override
  Future<Either<Failure, void>> deleteTrainer(String trainerUid) =>
      _guardedCall(() => _service.deleteTrainer(trainerUid));
}
