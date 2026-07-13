class WorkoutSession {
  final DateTime dateTime;
  // Nested map: muscle -> exercise -> {sets, reps}
  final Map<String, dynamic> exercises;

  const WorkoutSession({
    required this.dateTime,
    required this.exercises,
  });
}
