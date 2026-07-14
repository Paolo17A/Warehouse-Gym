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
      // Seconds-precision UTC ISO avoids Zod rejecting Dart's microsecond strings.
      'dateTime': _toApiDateTime(dateTime),
      'exercises': _deepJsonMap(exercises),
    };
  }

  static String _toApiDateTime(DateTime value) {
    final utc = value.toUtc();
    final y = utc.year.toString().padLeft(4, '0');
    final mo = utc.month.toString().padLeft(2, '0');
    final d = utc.day.toString().padLeft(2, '0');
    final h = utc.hour.toString().padLeft(2, '0');
    final mi = utc.minute.toString().padLeft(2, '0');
    final s = utc.second.toString().padLeft(2, '0');
    return '$y-$mo-${d}T$h:$mi:${s}Z';
  }

  static Map<String, dynamic> _deepJsonMap(Map<dynamic, dynamic> source) {
    return source.map((key, value) {
      final k = key.toString();
      if (value is Map) {
        return MapEntry(k, _deepJsonMap(Map<dynamic, dynamic>.from(value)));
      }
      if (value is List) {
        return MapEntry(
          k,
          value
              .map((item) => item is Map
                  ? _deepJsonMap(Map<dynamic, dynamic>.from(item))
                  : item)
              .toList(),
        );
      }
      return MapEntry(k, value);
    });
  }

  Map<String, dynamic> toFirestore() => toApi();
}
