import 'package:dartz/dartz.dart';
import 'package:the_warehouse_gym/core/errors/failures.dart';
import '../entities/workout_prescription.dart';
import '../entities/workout_session.dart';

abstract class WorkoutRepository {
  Future<Either<Failure, List<WorkoutPrescription>>> getPrescribedWorkouts(
    String uid,
  );

  Future<Either<Failure, WorkoutPrescription>> getPrescriptionById(
    String prescriptionId,
  );

  Future<Either<Failure, void>> savePrescription({
    required String clientId,
    required WorkoutPrescription workout,
    String? trainerId,
  });

  Future<Either<Failure, void>> completeWorkout(
    String uid,
    WorkoutSession session,
  );

  Future<Either<Failure, List<WorkoutSession>>> getWorkoutHistory(String uid);

  Future<Either<Failure, void>> removePrescription({
    required String clientId,
    required String prescriptionId,
    String? requesterId,
    bool isTrainerRequest = false,
  });
}
