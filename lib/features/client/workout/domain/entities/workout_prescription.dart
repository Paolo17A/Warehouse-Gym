import 'exercise_prescription.dart';

class WorkoutPrescription {
  final String id;
  final String? trainerId;
  final String description;
  final DateTime workoutDate;
  final Map<String, List<ExercisePrescription>> exercises;

  const WorkoutPrescription({
    required this.id,
    this.trainerId,
    required this.description,
    required this.workoutDate,
    required this.exercises,
  });

  bool get isSelfCreated => trainerId == null || trainerId!.isEmpty;
}
