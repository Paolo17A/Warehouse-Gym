import 'package:the_warehouse_gym/features/client/workout/domain/entities/workout_prescription.dart';

class WorkoutPlanMapper {
  const WorkoutPlanMapper._();

  static Map<String, dynamic> toCameraExercisesMap(WorkoutPrescription p) {
    final result = <String, dynamic>{};
    p.exercises.forEach((muscle, list) {
      final exerciseMap = <String, dynamic>{};
      for (final e in list) {
        exerciseMap[e.exerciseName] = {'sets': e.sets, 'reps': e.reps};
      }
      result[muscle] = exerciseMap;
    });
    return result;
  }

  static Map<String, dynamic> sessionExtraFromPrescription(
    WorkoutPrescription p,
  ) {
    return {
      'exercises': toCameraExercisesMap(p),
      'description': p.description,
    };
  }

  static bool isSameCalendarDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static WorkoutPrescription? findTodaysPrescription(
    List<WorkoutPrescription> prescriptions,
  ) {
    final now = DateTime.now();
    for (final p in prescriptions) {
      if (isSameCalendarDay(p.workoutDate, now)) return p;
    }
    return null;
  }
}

Map<String, dynamic> parseSessionExtra(Map<String, dynamic>? raw) {
  if (raw == null) return {'exercises': <String, dynamic>{}, 'description': ''};
  return {
    'exercises': raw['exercises'] as Map<String, dynamic>? ?? {},
    'description': raw['description'] as String? ?? '',
  };
}

Map<String, dynamic> exercisesFromExtra(Map<String, dynamic> extra) {
  return extra['exercises'] as Map<String, dynamic>? ?? {};
}

String descriptionFromExtra(Map<String, dynamic> extra) {
  return extra['description'] as String? ?? '';
}
