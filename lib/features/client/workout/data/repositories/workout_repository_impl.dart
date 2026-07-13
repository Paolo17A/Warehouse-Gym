import 'package:dartz/dartz.dart';
import 'package:the_warehouse_gym/core/errors/failures.dart';
import 'package:the_warehouse_gym/core/network/api_client.dart';
import 'package:the_warehouse_gym/core/network/network_info.dart';
import 'package:the_warehouse_gym/features/client/workout/domain/entities/workout_prescription.dart';
import 'package:the_warehouse_gym/features/client/workout/domain/entities/workout_session.dart';
import 'package:the_warehouse_gym/features/client/workout/domain/repositories/workout_repository.dart';
import '../models/workout_prescription_model.dart';
import '../models/workout_session_model.dart';
import '../services/workout_service.dart';

class WorkoutRepositoryImpl implements WorkoutRepository {
  final WorkoutService _service;
  final NetworkInfo _networkInfo;

  WorkoutRepositoryImpl(this._service, this._networkInfo);

  @override
  Future<Either<Failure, List<WorkoutPrescription>>> getPrescribedWorkouts(
    String uid,
  ) async {
    if (!await _networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final raw = await _service.getPrescribedWorkouts(uid);
      final prescriptions = raw.map((entry) {
        return WorkoutPrescriptionModel.fromJson(entry).toEntity();
      }).toList();
      return Right(prescriptions);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WorkoutPrescription>> getPrescriptionById(
    String prescriptionId,
  ) async {
    if (!await _networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final raw = await _service.getPrescriptionById(prescriptionId);
      if (raw == null) {
        return const Left(ServerFailure('Workout plan not found.'));
      }
      return Right(WorkoutPrescriptionModel.fromJson(raw).toEntity());
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> savePrescription({
    required String clientId,
    required WorkoutPrescription workout,
    String? trainerId,
  }) async {
    if (!await _networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final id = workout.id.isEmpty
          ? DateTime.now().millisecondsSinceEpoch.toString()
          : workout.id;
      final model = WorkoutPrescriptionModel(
        id: id,
        trainerId: trainerId,
        description: workout.description,
        workoutDate: workout.workoutDate,
        exercises: workout.exercises,
      );
      await _service.savePrescription(
        clientId: clientId,
        prescriptionId: id,
        data: model.toApi(clientId: clientId),
        trainerId: trainerId,
      );
      return const Right(null);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> completeWorkout(
    String uid,
    WorkoutSession session,
  ) async {
    if (!await _networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final model = WorkoutSessionModel(
        dateTime: session.dateTime,
        exercises: session.exercises,
      );
      await _service.completeWorkout(uid, model.toApi());
      return const Right(null);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WorkoutSession>>> getWorkoutHistory(
    String uid,
  ) async {
    if (!await _networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final raw = await _service.getWorkoutHistory(uid);
      final sessions = raw
          .map((e) => WorkoutSessionModel.fromJson(e).toEntity())
          .toList();
      return Right(sessions);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removePrescription({
    required String clientId,
    required String prescriptionId,
    String? requesterId,
    bool isTrainerRequest = false,
  }) async {
    if (!await _networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final prescription = await _service.getPrescriptionById(prescriptionId);
      if (prescription == null) {
        return const Left(ServerFailure('Workout plan not found.'));
      }

      final ownerClientId = prescription['clientId'] as String? ?? '';
      if (ownerClientId != clientId) {
        return const Left(
          ValidationFailure('You can only delete your own workout plans.'),
        );
      }

      final trainerId = prescription['trainerId'] as String?;
      final isSelfCreated = trainerId == null || trainerId.isEmpty;

      if (isTrainerRequest) {
        if (!isSelfCreated && trainerId != requesterId) {
          return const Left(
            ValidationFailure('You can only delete workouts you prescribed.'),
          );
        }
      } else if (!isSelfCreated) {
        return const Left(
          ValidationFailure('Trainer-assigned plans cannot be deleted.'),
        );
      }

      await _service.removePrescription(prescriptionId);
      return const Right(null);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
