import 'package:the_warehouse_gym/features/client/workout/domain/entities/exercise_prescription.dart';
import 'package:the_warehouse_gym/features/client/workout/domain/entities/workout_prescription.dart';

class WorkoutPrescriptionModel {
  final String id;
  final String? trainerId;
  final String description;
  final DateTime workoutDate;
  final Map<String, List<ExercisePrescription>> exercises;

  const WorkoutPrescriptionModel({
    required this.id,
    this.trainerId,
    required this.description,
    required this.workoutDate,
    required this.exercises,
  });

  factory WorkoutPrescriptionModel.fromJson(Map<String, dynamic> data) {
    final id = data['id'] as String? ?? '';
    return WorkoutPrescriptionModel.fromFirestore(id, data);
  }

  factory WorkoutPrescriptionModel.fromFirestore(
    String id,
    Map<String, dynamic> data,
  ) {
    final rawWorkout = _asStringKeyedMap(data['workout']) ?? {};

    final exercises = <String, List<ExercisePrescription>>{};
    rawWorkout.forEach((muscle, exercisesMap) {
      final detailsMap = _asStringKeyedMap(exercisesMap);
      if (detailsMap == null) return;

      final list = <ExercisePrescription>[];
      detailsMap.forEach((exerciseName, details) {
        final detailMap = _asStringKeyedMap(details);
        if (detailMap == null) return;
        list.add(ExercisePrescription(
          exerciseName: exerciseName,
          muscle: muscle,
          sets: (detailMap['sets'] as num?)?.toInt() ?? 0,
          reps: (detailMap['reps'] as num?)?.toInt() ?? 0,
        ));
      });
      exercises[muscle] = list;
    });

    final rawDate = data['workoutDate'];
    final workoutDate = rawDate is DateTime
        ? rawDate
        : rawDate is String
            ? DateTime.tryParse(rawDate) ?? DateTime.now()
            : DateTime.now();

    final rawTrainerId = data['trainerId'];
    final trainerId = rawTrainerId is String && rawTrainerId.isNotEmpty
        ? rawTrainerId
        : null;

    return WorkoutPrescriptionModel(
      id: id,
      trainerId: trainerId,
      description: data['description'] as String? ?? '',
      workoutDate: workoutDate,
      exercises: exercises,
    );
  }

  static Map<String, dynamic>? _asStringKeyedMap(dynamic value) {
    if (value == null) return null;
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, item) => MapEntry(key.toString(), item));
    }
    return null;
  }

  WorkoutPrescription toEntity() {
    return WorkoutPrescription(
      id: id,
      trainerId: trainerId,
      description: description,
      workoutDate: workoutDate,
      exercises: exercises,
    );
  }

  Map<String, dynamic> toApi({required String clientId}) {
    final rawWorkout = <String, dynamic>{};
    exercises.forEach((muscle, list) {
      final exerciseMap = <String, dynamic>{};
      for (final e in list) {
        exerciseMap[e.exerciseName] = {'sets': e.sets, 'reps': e.reps};
      }
      rawWorkout[muscle] = exerciseMap;
    });

    final payload = <String, dynamic>{
      'clientId': clientId,
      'description': description,
      'workoutDate': workoutDate.toUtc().toIso8601String(),
      'workout': rawWorkout,
    };
    if (trainerId != null && trainerId!.isNotEmpty) {
      payload['trainerId'] = trainerId;
    }
    return payload;
  }

  Map<String, dynamic> toFirestore({required String clientId}) =>
      toApi(clientId: clientId);
}
