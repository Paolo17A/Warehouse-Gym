import 'package:dartz/dartz.dart';
import 'package:the_warehouse_gym/core/errors/failures.dart';
import 'package:the_warehouse_gym/features/shared/account/domain/repositories/account_repository.dart';

abstract class ClientAccountRepository extends AccountRepository {
  Future<Either<Failure, void>> requestTrainer(
    String clientUid,
    String trainerUid,
  );

  Future<Either<Failure, void>> cancelTrainerRequest(
    String clientUid,
    String trainerUid,
  );

  Future<Either<Failure, bool>> hasPendingTrainerRequest(
    String clientUid,
    String trainerUid,
  );
}
