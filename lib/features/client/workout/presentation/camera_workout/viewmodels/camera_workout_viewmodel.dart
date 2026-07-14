import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:the_warehouse_gym/core/di/injection.dart';
import 'package:the_warehouse_gym/core/providers/session_providers.dart';
import 'package:the_warehouse_gym/core/utils/toast_utils.dart';
import 'package:the_warehouse_gym/features/client/workout/domain/entities/workout_session.dart';
import 'package:the_warehouse_gym/features/client/workout/domain/usecases/workout_usecase.dart';
import 'package:the_warehouse_gym/features/client/workout/presentation/camera_workout/utils/exercise_name_util.dart';
import 'package:the_warehouse_gym/features/client/workout/presentation/camera_workout/utils/muscle_audio_util.dart';
import 'package:the_warehouse_gym/features/client/workout/presentation/camera_workout/viewmodels/camera_workout_state.dart';
import 'package:the_warehouse_gym/features/client/workout/presentation/camera_workout/viewmodels/workout_phase.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

export 'camera_workout_state.dart';
export 'workout_phase.dart';

class CameraWorkoutViewModel extends StateNotifier<CameraWorkoutState> {
  CameraWorkoutViewModel({
    required WorkoutUseCase workoutUseCase,
    required Ref ref,
  })  : _workoutUseCase = workoutUseCase,
        _ref = ref,
        super(const CameraWorkoutState.initial());

  final WorkoutUseCase _workoutUseCase;
  final Ref _ref;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _timer;
  bool _disposed = false;
  bool _resourcesReleased = false;

  void releaseResources() {
    if (_resourcesReleased) return;
    _resourcesReleased = true;
    _disposed = true;
    _timer?.cancel();
    unawaited(_audioPlayer.stop());
    _audioPlayer.dispose();
  }

  void loadSession({
    required Map<String, dynamic> exercises,
    required String description,
  }) {
    if (_disposed) return;

    _timer?.cancel();
    state = const CameraWorkoutState.initial();

    try {
      final prescribedWorkouts = Map<String, dynamic>.from(exercises);
      final muscleGroups =
          prescribedWorkouts.keys.map((key) => key.toString()).toList();
      if (muscleGroups.isEmpty) {
        showInfoToast("No exercises in today's plan.");
        state = const CameraWorkoutState.failed('No exercises in today\'s plan.');
        return;
      }

      final normalizedWorkouts = <String, dynamic>{};
      for (final entry in prescribedWorkouts.entries) {
        normalizedWorkouts[entry.key.toString()] = entry.value;
      }

      var session = CameraWorkoutSession(
        prescribedWorkouts: normalizedWorkouts,
        workoutDescription: description,
        muscleGroups: muscleGroups,
      );
      session = _loadCurrentWorkoutMeta(session);

      if (session.workouts.isEmpty) {
        state = const CameraWorkoutState.failed(
          'No exercises found for this muscle group.',
        );
        return;
      }

      setWorkoutPhase(WorkoutStates.reminder, session: session);
    } catch (error) {
      if (!_disposed) {
        state = CameraWorkoutState.failed('Error loading workout: $error');
      }
    }
  }

  CameraWorkoutSession _requireSession() {
    final session = state.session;
    if (session == null) {
      throw StateError('Camera workout session is not available.');
    }
    return session;
  }

  CameraWorkoutSession _loadCurrentWorkoutMeta(CameraWorkoutSession session) {
    final muscle = session.muscleGroups[session.currentMuscleGroupIndex];
    final muscleMap =
        session.prescribedWorkouts[muscle] as Map<String, dynamic>? ?? {};
    final workouts = muscleMap.keys.map((k) => k.toString()).toList();
    final meta = muscleMap[workouts[session.currentWorkoutIndex]] as Map? ?? {};
    return session.copyWith(
      workouts: workouts,
      repsQuota: (meta['reps'] as num?)?.toInt() ?? 0,
      setQuota: (meta['sets'] as num?)?.toInt() ?? 0,
      repsDone: List<int>.filled((meta['sets'] as num?)?.toInt() ?? 0, 0),
    );
  }

  String currentExerciseName(CameraWorkoutSession session) =>
      normalizeExerciseName(session.workouts[session.currentWorkoutIndex]);

  void setWorkoutPhase(
    WorkoutStates phase, {
    CameraWorkoutSession? session,
  }) {
    final base = session ?? _requireSession();
    final updated = _sessionForPhase(phase, base);
    state = cameraWorkoutStateForPhase(phase, updated);
    if (phase == WorkoutStates.rest) {
      _initializeTimer(10);
    } else if (phase == WorkoutStates.done) {
      unawaited(completeWorkoutSession());
    }
  }

  CameraWorkoutSession _sessionForPhase(
    WorkoutStates phase,
    CameraWorkoutSession session,
  ) {
    switch (phase) {
      case WorkoutStates.none:
        return session;
      case WorkoutStates.reminder:
        return session.copyWith(
          spokenMessage:
              'Before we start, position yourself 3-5 feet away from your phone',
          additionalMessage: '',
          explanationMessage: '',
          imageAssetPath: 'assets/images/warmups/stay_away.png',
        );
      case WorkoutStates.intro:
        final workout = session.workouts[session.currentWorkoutIndex];
        return session.copyWith(
          spokenMessage: workout,
          additionalMessage: getWorkoutIntro(workout),
          explanationMessage: getWorkoutExplanation(workout),
          imageAssetPath: 'assets/images/gifs/$workout.gif',
        );
      case WorkoutStates.countdown:
        return session.copyWith(
          spokenMessage: 'Are you ready?',
          additionalMessage: '',
          explanationMessage: '',
          imageAssetPath: 'assets/images/warmups/countdown_3.png',
          secondsRemaining: 3,
          timerInitialized: false,
        );
      case WorkoutStates.rest:
        return session.copyWith(
          spokenMessage:
              'Rest for 10 seconds. Then prepare for the next exercise',
          additionalMessage: '',
          explanationMessage: '',
          imageAssetPath:
              'assets/images/gifs/${session.workouts[session.currentWorkoutIndex]}.gif',
          secondsRemaining: 10,
          timerInitialized: false,
        );
      case WorkoutStates.workout:
        return session.copyWith(
          spokenMessage: '',
          additionalMessage: '',
          explanationMessage: '',
          imageAssetPath:
              'assets/images/gifs/${session.workouts[session.currentWorkoutIndex]}.gif',
          mayAddRep: true,
        );
      case WorkoutStates.done:
        return session.copyWith(
          spokenMessage: 'You completed Today\'s workout. Congratulations',
          additionalMessage: '',
          explanationMessage: '',
          imageAssetPath: 'assets/images/warmups/DONE.png',
        );
    }
  }

  void continueFromReminder() {
    if (state.phase != WorkoutStates.reminder) return;
    setWorkoutPhase(WorkoutStates.intro);
  }

  void startPoseWorkout() {
    if (state.phase != WorkoutStates.intro) return;
    setWorkoutPhase(WorkoutStates.workout);
  }

  void goToNextState() {
    final phase = state.phase;
    if (phase == null) return;

    switch (phase) {
      case WorkoutStates.rest:
        setWorkoutPhase(WorkoutStates.intro);
        break;
      case WorkoutStates.none:
      case WorkoutStates.reminder:
      case WorkoutStates.intro:
      case WorkoutStates.countdown:
      case WorkoutStates.workout:
      case WorkoutStates.done:
        break;
    }
  }

  void _initializeTimer(int duration) {
    final session = state.session;
    if (session == null || session.timerInitialized || _disposed) return;

    _timer?.cancel();
    var updated = session.copyWith(
      secondsRemaining: duration,
      timerInitialized: true,
    );
    _emitSession(updated);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final current = state.session;
      if (current == null || _disposed) {
        timer.cancel();
        return;
      }

      if (current.secondsRemaining > 0) {
        var next = current.copyWith(secondsRemaining: current.secondsRemaining - 1);
        if (state.phase == WorkoutStates.countdown) {
          next = next.copyWith(
            imageAssetPath: switch (next.secondsRemaining) {
              3 => 'assets/images/warmups/countdown_3.png',
              2 => 'assets/images/warmups/countdown_2.png',
              1 => 'assets/images/warmups/countdown_1.png',
              _ => next.imageAssetPath,
            },
          );
        }
        _emitSession(next);
        return;
      }

      timer.cancel();
      _emitSession(current.copyWith(timerInitialized: false));
      goToNextState();
    });
  }

  void _emitSession(CameraWorkoutSession session) {
    final phase = state.phase;
    if (phase == null) return;
    state = cameraWorkoutStateForPhase(phase, session);
  }

  void setMayAddRep(bool value) {
    final session = state.session;
    if (session == null || session.mayAddRep == value) return;
    _emitSession(session.copyWith(mayAddRep: value));
  }

  void addRepFromPose() {
    if (state.phase != WorkoutStates.workout) return;
    _addRepToCurrentSet(fromPose: true);
  }

  void addRepManually() {
    if (state.phase != WorkoutStates.workout) return;
    _emitSession(_requireSession().copyWith(mayAddRep: true));
    _addRepToCurrentSet(fromPose: false);
  }

  void _addRepToCurrentSet({required bool fromPose}) {
    var session = _requireSession();
    if (state.phase != WorkoutStates.workout) return;

    unawaited(_audioPlayer.play(AssetSource('audio/ding.mp3')));

    if (fromPose) {
      session = session.copyWith(mayAddRep: false);
    }

    var currentRep = session.currentRep + 1;
    final repsDone = List<int>.from(session.repsDone);
    repsDone[session.currentSet] = currentRep;

    var accomplishedWorkouts =
        Map<String, dynamic>.from(session.accomplishedWorkouts);
    final muscle = session.muscleGroups[session.currentMuscleGroupIndex];
    final workout = session.workouts[session.currentWorkoutIndex];

    if (!accomplishedWorkouts.containsKey(muscle)) {
      accomplishedWorkouts[muscle] = {
        workout: {'repsQuota': session.repsQuota, 'repsDone': repsDone},
      };
    } else if (!(accomplishedWorkouts[muscle] as Map<dynamic, dynamic>)
        .containsKey(workout)) {
      (accomplishedWorkouts[muscle] as Map<String, dynamic>)[workout] = {
        'repsQuota': session.repsQuota,
        'repsDone': repsDone,
      };
    } else {
      (accomplishedWorkouts[muscle] as Map<String, dynamic>)[workout]
          ['repsDone'] = repsDone;
    }

    session = session.copyWith(
      currentRep: currentRep,
      repsDone: repsDone,
      accomplishedWorkouts: accomplishedWorkouts,
    );

    if (currentRep == session.repsQuota) {
      var currentSet = session.currentSet + 1;
      currentRep = 0;

      if (currentSet == session.setQuota) {
        currentSet = 0;
        var currentWorkoutIndex = session.currentWorkoutIndex + 1;
        var currentMuscleGroupIndex = session.currentMuscleGroupIndex;

        if (currentWorkoutIndex == session.workouts.length) {
          currentWorkoutIndex = 0;
          currentMuscleGroupIndex++;

          if (currentMuscleGroupIndex == session.muscleGroups.length) {
            _emitSession(session.copyWith(
              currentRep: currentRep,
              currentSet: currentSet,
              currentWorkoutIndex: currentWorkoutIndex,
              currentMuscleGroupIndex: currentMuscleGroupIndex,
            ));
            setWorkoutPhase(WorkoutStates.done);
            return;
          }

          session = session.copyWith(
            currentRep: currentRep,
            currentSet: currentSet,
            currentWorkoutIndex: currentWorkoutIndex,
            currentMuscleGroupIndex: currentMuscleGroupIndex,
            workouts: _workoutsForMuscle(session, currentMuscleGroupIndex),
          );
          _resetWorkoutVariables(session);
          return;
        }

        session = session.copyWith(
          currentRep: currentRep,
          currentSet: currentSet,
          currentWorkoutIndex: currentWorkoutIndex,
        );
        _resetWorkoutVariables(session);
        return;
      }

      session = session.copyWith(
        currentRep: currentRep,
        currentSet: currentSet,
      );
    }

    _emitSession(session);
  }

  List<String> _workoutsForMuscle(
    CameraWorkoutSession session,
    int muscleGroupIndex,
  ) {
    return (session.prescribedWorkouts[session.muscleGroups[muscleGroupIndex]]
            as Map<String, dynamic>)
        .keys
        .map((k) => k.toString())
        .toList();
  }

  void _resetWorkoutVariables(CameraWorkoutSession session) {
    final muscle = session.muscleGroups[session.currentMuscleGroupIndex];
    final workout = session.workouts[session.currentWorkoutIndex];
    final meta =
        (session.prescribedWorkouts[muscle] as Map<String, dynamic>)[workout]
            as Map<String, dynamic>;
    final updated = session.copyWith(
      repsQuota: (meta['reps'] as num?)?.toInt() ?? 0,
      setQuota: (meta['sets'] as num?)?.toInt() ?? 0,
      repsDone: List<int>.filled((meta['sets'] as num?)?.toInt() ?? 0, 0),
      currentRep: 0,
      currentSet: 0,
    );
    _goToRestScreen(updated);
  }

  void _goToRestScreen(CameraWorkoutSession session) {
    setWorkoutPhase(WorkoutStates.rest, session: session);
  }

  Future<void> skipWorkout() async {
    var session = _requireSession();

    var currentWorkoutIndex = session.currentWorkoutIndex + 1;
    var currentMuscleGroupIndex = session.currentMuscleGroupIndex;

    if (currentWorkoutIndex == session.workouts.length) {
      currentMuscleGroupIndex++;
      currentWorkoutIndex = 0;

      if (currentMuscleGroupIndex == session.muscleGroups.length) {
        setWorkoutPhase(WorkoutStates.done, session: session.copyWith(
          currentWorkoutIndex: currentWorkoutIndex,
          currentMuscleGroupIndex: currentMuscleGroupIndex,
          currentRep: 0,
          currentSet: 0,
        ));
        return;
      }

      session = session.copyWith(
        currentWorkoutIndex: currentWorkoutIndex,
        currentMuscleGroupIndex: currentMuscleGroupIndex,
        currentRep: 0,
        currentSet: 0,
        workouts: _workoutsForMuscle(session, currentMuscleGroupIndex),
      );
    } else {
      session = session.copyWith(
        currentWorkoutIndex: currentWorkoutIndex,
        currentRep: 0,
        currentSet: 0,
      );
    }

    _resetWorkoutVariables(session);
  }

  Future<void> skipMuscle() async {
    var session = _requireSession();
    var currentMuscleGroupIndex = session.currentMuscleGroupIndex + 1;

    session = session.copyWith(
      currentMuscleGroupIndex: currentMuscleGroupIndex,
      currentWorkoutIndex: 0,
      currentRep: 0,
      currentSet: 0,
    );

    if (currentMuscleGroupIndex == session.muscleGroups.length) {
      setWorkoutPhase(WorkoutStates.done, session: session);
      return;
    }

    session = session.copyWith(
      workouts: _workoutsForMuscle(session, currentMuscleGroupIndex),
    );
    _resetWorkoutVariables(session);
  }

  bool muscleHasRecordedProgress() {
    final session = state.session;
    if (session == null) return false;
    return session.accomplishedWorkouts
        .containsKey(session.muscleGroups[session.currentMuscleGroupIndex]);
  }

  Future<void> skipWorkoutAfterConfirm() async {
    var session = _requireSession();

    session = session.copyWith(
      currentMuscleGroupIndex: session.currentMuscleGroupIndex + 1,
      currentWorkoutIndex: 0,
      currentRep: 0,
      currentSet: 0,
    );

    if (session.currentMuscleGroupIndex == session.muscleGroups.length) {
      setWorkoutPhase(WorkoutStates.done, session: session);
      return;
    }

    session = session.copyWith(
      workouts: _workoutsForMuscle(session, session.currentMuscleGroupIndex),
    );
    _resetWorkoutVariables(session);
  }

  Future<void> completeWorkoutSession() async {
    var session = _requireSession();
    if (session.isAlreadyUpdating) return;

    final uid = _ref.read(sessionUserProvider)?.uid ?? '';
    session = session.copyWith(isAlreadyUpdating: true);
    state = CameraWorkoutState.submitting(session);

    try {
      if (session.accomplishedWorkouts.isEmpty) {
        state = const CameraWorkoutState.failed(
          'You skipped all your workouts. No history will be recorded.',
        );
        return;
      }

      final workoutSession = WorkoutSession(
        dateTime: DateTime.now(),
        exercises: Map<String, dynamic>.from(session.accomplishedWorkouts),
      );

      final result =
          await _workoutUseCase.completeWorkout(uid, workoutSession);

      result.fold(
        (failure) {
          showFailureToast(failure);
          // Still finish the session so the client can start another one.
          state = cameraWorkoutStateForPhase(
            WorkoutStates.done,
            session.copyWith(
              workoutSaved: false,
              navigateHome: true,
              isAlreadyUpdating: false,
            ),
          );
        },
        (_) {
          showSuccessToast('Workout completed! Congratulations!');
          state = cameraWorkoutStateForPhase(
            WorkoutStates.done,
            session.copyWith(workoutSaved: true, navigateHome: true),
          );
        },
      );
    } catch (error) {
      showErrorToast(
        error is Exception
            ? error.toString().replaceFirst('Exception: ', '')
            : 'Error saving workout history.',
      );
      state = cameraWorkoutStateForPhase(
        WorkoutStates.done,
        session.copyWith(
          workoutSaved: false,
          navigateHome: true,
          isAlreadyUpdating: false,
        ),
      );
    }
  }

  @override
  void dispose() {
    releaseResources();
    super.dispose();
  }
}

final cameraWorkoutProvider =
    StateNotifierProvider.autoDispose<CameraWorkoutViewModel, CameraWorkoutState>(
        (ref) {
  return CameraWorkoutViewModel(
    workoutUseCase: sl<WorkoutUseCase>(),
    ref: ref,
  );
});
