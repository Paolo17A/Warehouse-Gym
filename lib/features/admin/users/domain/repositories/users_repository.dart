import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';

abstract class UsersRepository {
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllClients();
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllTrainers();
  Future<Either<Failure, void>> addTrainer({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String idNumber,
  });
  Future<Either<Failure, List<Map<String, dynamic>>>> getTrainerCurrentClients(
      String trainerUid);
  Future<Either<Failure, List<Map<String, dynamic>>>> getTrainerSchedule(
      String trainerUid);
  Future<Either<Failure, void>> confirmClient(
      String trainerUid, String clientUid);
  Future<Either<Failure, void>> removeClient(
      String trainerUid, String clientUid);
  Future<Either<Failure, void>> deleteTrainer(String trainerUid);
}
