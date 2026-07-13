import 'package:dartz/dartz.dart';
import 'package:the_warehouse_gym/core/errors/failures.dart';

abstract class TrainerUsersRepository {
  Future<Either<Failure, List<Map<String, dynamic>>>> getTrainerClients(
    String trainerUid,
  );

  Future<Either<Failure, List<Map<String, dynamic>>>> getTrainerSchedule(
    String trainerUid,
  );

  Future<Either<Failure, void>> confirmClient(
    String trainerUid,
    String clientUid,
  );

  Future<Either<Failure, void>> rejectClient(
    String trainerUid,
    String clientUid,
  );

  Future<Either<Failure, void>> removeClient(
    String trainerUid,
    String clientUid,
  );
}
