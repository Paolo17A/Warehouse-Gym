import 'package:dartz/dartz.dart';
import 'package:the_warehouse_gym/core/errors/failures.dart';
import 'package:the_warehouse_gym/core/network/api_client.dart';
import 'package:the_warehouse_gym/core/network/network_info.dart';
import 'package:the_warehouse_gym/features/admin/account/domain/repositories/admin_account_repository.dart';
import 'package:the_warehouse_gym/features/client/account/domain/repositories/client_account_repository.dart';
import 'package:the_warehouse_gym/features/shared/account/data/models/full_user_model.dart';
import 'package:the_warehouse_gym/features/shared/account/data/services/profile_service.dart';
import 'package:the_warehouse_gym/features/shared/account/data/services/trainer_request_service.dart';
import 'package:the_warehouse_gym/features/shared/account/domain/entities/full_user.dart';
import 'package:the_warehouse_gym/features/trainer/account/domain/repositories/trainer_account_repository.dart';

class AccountRepositoryImpl
    implements
        ClientAccountRepository,
        AdminAccountRepository,
        TrainerAccountRepository {
  final ProfileService _service;
  final TrainerRequestService _trainerRequests;
  final NetworkInfo _networkInfo;

  const AccountRepositoryImpl({
    required ProfileService service,
    required TrainerRequestService trainerRequests,
    required NetworkInfo networkInfo,
  })  : _service = service,
        _trainerRequests = trainerRequests,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, FullUser>> getProfile(String uid) async {
    if (!await _networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final data = await _service.getUserData(uid);
      final model = FullUserModel.fromJson(data);
      return Right(model.toEntity());
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile(
    String uid,
    Map<String, dynamic> data,
  ) async {
    if (!await _networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      await _service.updateUser(data);
      return const Right(null);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfileImage(
    String uid,
    String filePath,
  ) async {
    if (!await _networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final user = await _service.uploadImage(filePath);
      final url = user['profileImageURL'] as String? ?? '';
      return Right(url);
    } on ApiException catch (e) {
      return Left(StorageFailure(e.message));
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> requestTrainer(
    String clientUid,
    String trainerUid,
  ) async {
    if (!await _networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      await _trainerRequests.requestTrainer(trainerUid);
      return const Right(null);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelTrainerRequest(
    String clientUid,
    String trainerUid,
  ) async {
    if (!await _networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      await _trainerRequests.cancelTrainerRequest(trainerUid);
      return const Right(null);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> hasPendingTrainerRequest(
    String clientUid,
    String trainerUid,
  ) async {
    if (!await _networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final hasPending = await _trainerRequests.hasPendingRequest(trainerUid);
      return Right(hasPending);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
