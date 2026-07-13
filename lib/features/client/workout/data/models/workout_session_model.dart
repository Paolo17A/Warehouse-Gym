import 'package:the_warehouse_gym/features/client/workout/domain/entities/workout_session.dart';

class WorkoutSessionModel {
  final DateTime dateTime;
  final Map<String, dynamic> exercises;

  const WorkoutSessionModel({
    required this.dateTime,
    required this.exercises,
  });

  factory WorkoutSessionModel.fromJson(Map<String, dynamic> data) {
    final rawDate = data['dateTime'];
    final dateTime = rawDate is DateTime
        ? rawDate
        : rawDate is String
            ? DateTime.tryParse(rawDate) ?? DateTime.now()
            : DateTime.now();

    return WorkoutSessionModel(
      dateTime: dateTime,
      exercises: (data['exercises'] as Map<String, dynamic>?) ?? {},
    );
  }

  factory WorkoutSessionModel.fromFirestore(Map<String, dynamic> data) {
    return WorkoutSessionModel.fromJson(data);
  }

  WorkoutSession toEntity() {
    return WorkoutSession(dateTime: dateTime, exercises: exercises);
  }

  Map<String, dynamic> toApi() {
    return {
      'dateTime': dateTime.toIso8601String(),
      'exercises': exercises,
    };
  }

  Map<String, dynamic> toFirestore() => toApi();
}
