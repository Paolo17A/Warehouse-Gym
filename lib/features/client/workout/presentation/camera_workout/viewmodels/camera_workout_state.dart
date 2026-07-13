import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_warehouse_gym/features/client/workout/presentation/camera_workout/viewmodels/workout_phase.dart';

part 'camera_workout_state.freezed.dart';

@freezed
class CameraWorkoutSession with _$CameraWorkoutSession {
  const factory CameraWorkoutSession({
    @Default({}) Map<String, dynamic> prescribedWorkouts,
    @Default('') String workoutDescription,
    @Default([]) List<String> muscleGroups,
    @Default(0) int currentMuscleGroupIndex,
    @Default([]) List<String> workouts,
    @Default(0) int currentWorkoutIndex,
    @Default([]) List<int> repsDone,
    @Default(0) int currentRep,
    @Default(0) int repsQuota,
    @Default(0) int currentSet,
    @Default(0) int setQuota,
    @Default(true) bool mayAddRep,
    @Default({}) Map<String, dynamic> accomplishedWorkouts,
    @Default('') String spokenMessage,
    @Default('') String additionalMessage,
    @Default('') String explanationMessage,
    @Default('assets/images/warmups/stay_away.png') String imageAssetPath,
    @Default(0) int secondsRemaining,
    @Default(false) bool timerInitialized,
    @Default(false) bool isAlreadyUpdating,
    @Default(false) bool navigateHome,
    @Default(false) bool workoutSaved,
  }) = _CameraWorkoutSession;
}

@freezed
class CameraWorkoutState with _$CameraWorkoutState {
  const factory CameraWorkoutState.initial() = Initial;

  const factory CameraWorkoutState.loading() = Loading;

  const factory CameraWorkoutState.none(CameraWorkoutSession session) = None;

  const factory CameraWorkoutState.reminder(CameraWorkoutSession session) =
      Reminder;

  const factory CameraWorkoutState.intro(CameraWorkoutSession session) = Intro;

  const factory CameraWorkoutState.countdown(CameraWorkoutSession session) =
      Countdown;

  const factory CameraWorkoutState.workout(CameraWorkoutSession session) =
      Workout;

  const factory CameraWorkoutState.rest(CameraWorkoutSession session) = Rest;

  const factory CameraWorkoutState.done(CameraWorkoutSession session) = Done;

  const factory CameraWorkoutState.submitting(CameraWorkoutSession session) =
      Submitting;

  const factory CameraWorkoutState.failed(String message) = Failed;
}

extension CameraWorkoutStateX on CameraWorkoutState {
  bool get isLoading => this is Initial || this is Submitting;

  bool get isSubmitting => this is Submitting;

  WorkoutStates? get phase => map(
        initial: (_) => null,
        loading: (_) => null,
        none: (_) => WorkoutStates.none,
        reminder: (_) => WorkoutStates.reminder,
        intro: (_) => WorkoutStates.intro,
        countdown: (_) => WorkoutStates.countdown,
        workout: (_) => WorkoutStates.workout,
        rest: (_) => WorkoutStates.rest,
        done: (_) => WorkoutStates.done,
        submitting: (_) => WorkoutStates.done,
        failed: (_) => null,
      );

  CameraWorkoutSession? get session => maybeMap(
        none: (value) => value.session,
        reminder: (value) => value.session,
        intro: (value) => value.session,
        countdown: (value) => value.session,
        workout: (value) => value.session,
        rest: (value) => value.session,
        done: (value) => value.session,
        submitting: (value) => value.session,
        orElse: () => null,
      );

  String? get failureMessage => maybeMap(
        failed: (value) => value.message,
        orElse: () => null,
      );

  bool get showsImagePhase => maybeMap(
        reminder: (_) => true,
        intro: (_) => true,
        countdown: (_) => true,
        rest: (_) => true,
        done: (_) => true,
        orElse: () => false,
      );

  bool get showsWorkoutPhase =>
      maybeMap(workout: (_) => true, orElse: () => false);

  bool get showsIntroPhase => maybeMap(intro: (_) => true, orElse: () => false);

  bool get showsReminderPhase =>
      maybeMap(reminder: (_) => true, orElse: () => false);
}

extension CameraWorkoutSessionX on CameraWorkoutSession {
  String get workoutDisplayText {
    final parts = <String>[
      if (additionalMessage.isNotEmpty) additionalMessage,
      if (explanationMessage.isNotEmpty) explanationMessage,
    ];
    return parts.join('\n\n');
  }
}

CameraWorkoutState cameraWorkoutStateForPhase(
  WorkoutStates phase,
  CameraWorkoutSession session,
) {
  switch (phase) {
    case WorkoutStates.none:
      return CameraWorkoutState.none(session);
    case WorkoutStates.reminder:
      return CameraWorkoutState.reminder(session);
    case WorkoutStates.intro:
      return CameraWorkoutState.intro(session);
    case WorkoutStates.countdown:
      return CameraWorkoutState.countdown(session);
    case WorkoutStates.workout:
      return CameraWorkoutState.workout(session);
    case WorkoutStates.rest:
      return CameraWorkoutState.rest(session);
    case WorkoutStates.done:
      return CameraWorkoutState.done(session);
  }
}
