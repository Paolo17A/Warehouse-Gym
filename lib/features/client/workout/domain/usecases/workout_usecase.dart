import 'package:dartz/dartz.dart';
import 'package:the_warehouse_gym/core/errors/failures.dart';
import '../entities/workout_prescription.dart';
import '../entities/workout_session.dart';
import '../repositories/workout_repository.dart';

class WorkoutUseCase {
  final WorkoutRepository _repository;

  const WorkoutUseCase(this._repository);

  Future<Either<Failure, List<WorkoutPrescription>>> getPrescribedWorkouts(
    String uid,
  ) =>
      _repository.getPrescribedWorkouts(uid);

  Future<Either<Failure, WorkoutPrescription>> getPrescriptionById(
    String prescriptionId,
  ) =>
      _repository.getPrescriptionById(prescriptionId);

  Future<Either<Failure, void>> savePrescription({
    required String clientId,
    required WorkoutPrescription workout,
    String? trainerId,
  }) =>
      _repository.savePrescription(
        clientId: clientId,
        workout: workout,
        trainerId: trainerId,
      );

  Future<Either<Failure, void>> prescribeWorkout(
    String trainerUid,
    String clientUid,
    WorkoutPrescription workout,
  ) =>
      savePrescription(
        clientId: clientUid,
        workout: workout,
        trainerId: trainerUid,
      );

  Future<Either<Failure, void>> createOwnWorkoutPlan(
    String clientUid,
    WorkoutPrescription workout,
  ) =>
      savePrescription(
        clientId: clientUid,
        workout: workout,
        trainerId: null,
      );

  Future<Either<Failure, void>> completeWorkout(
    String uid,
    WorkoutSession session,
  ) =>
      _repository.completeWorkout(uid, session);

  Future<Either<Failure, List<WorkoutSession>>> getWorkoutHistory(
    String uid,
  ) =>
      _repository.getWorkoutHistory(uid);

  Future<Either<Failure, void>> removePrescription({
    required String clientId,
    required String prescriptionId,
    String? requesterId,
    bool isTrainerRequest = false,
  }) =>
      _repository.removePrescription(
        clientId: clientId,
        prescriptionId: prescriptionId,
        requesterId: requesterId,
        isTrainerRequest: isTrainerRequest,
      );
}
