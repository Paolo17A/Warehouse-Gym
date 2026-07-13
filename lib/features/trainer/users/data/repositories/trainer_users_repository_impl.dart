import 'package:dartz/dartz.dart';
import 'package:the_warehouse_gym/core/errors/failures.dart';
import 'package:the_warehouse_gym/core/network/api_client.dart';
import 'package:the_warehouse_gym/core/network/network_info.dart';
import 'package:the_warehouse_gym/features/admin/users/data/services/users_service.dart';
import 'package:the_warehouse_gym/features/trainer/users/domain/repositories/trainer_users_repository.dart';

class TrainerUsersRepositoryImpl implements TrainerUsersRepository {
  final UsersService _service;
  final NetworkInfo _networkInfo;

  TrainerUsersRepositoryImpl({
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
  Future<Either<Failure, List<Map<String, dynamic>>>> getTrainerClients(
    String trainerUid,
  ) =>
      _guardedCall(() => _service.getTrainerClientsOverview(trainerUid));

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getTrainerSchedule(
    String trainerUid,
  ) =>
      _guardedCall(() => _service.getTrainerSchedule(trainerUid));

  @override
  Future<Either<Failure, void>> confirmClient(
    String trainerUid,
    String clientUid,
  ) =>
      _guardedCall(() => _service.confirmClient(trainerUid, clientUid));

  @override
  Future<Either<Failure, void>> rejectClient(
    String trainerUid,
    String clientUid,
  ) =>
      _guardedCall(() => _service.rejectClient(trainerUid, clientUid));

  @override
  Future<Either<Failure, void>> removeClient(
    String trainerUid,
    String clientUid,
  ) =>
      _guardedCall(() => _service.removeClient(trainerUid, clientUid));
}
