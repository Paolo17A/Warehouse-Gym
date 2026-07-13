import 'package:the_warehouse_gym/core/di/injection.dart';
import 'package:the_warehouse_gym/core/utils/toast_utils.dart';
import 'package:the_warehouse_gym/features/client/workout/domain/entities/workout_prescription.dart';
import 'package:the_warehouse_gym/features/client/workout/domain/entities/workout_session.dart';
import 'package:the_warehouse_gym/features/client/workout/domain/usecases/workout_usecase.dart';
import 'package:the_warehouse_gym/features/client/workout/presentation/camera_workout/utils/workout_plan_mapper.dart';
import 'package:the_warehouse_gym/features/client/workout/presentation/viewmodels/workout_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

export 'workout_state.dart';

class WorkoutViewModel extends StateNotifier<WorkoutState> {
  final WorkoutUseCase _workout;

  WorkoutViewModel({required WorkoutUseCase workout})
      : _workout = workout,
        super(const WorkoutState.initial());

  Future<void> loadPrescriptions(String uid) async {
    _setLoadingState();
    final result = await _workout.getPrescribedWorkouts(uid);
    result.fold(
      (failure) {
        state = WorkoutState.failed(failure);
        showFailureToast(failure);
      },
      (prescriptions) => state = WorkoutState.loaded(
        WorkoutData(
          prescriptions: prescriptions,
          history: _currentData()?.history ?? const [],
        ),
      ),
    );
  }

  Future<void> loadHistory(String uid) async {
    _setLoadingState();
    final result = await _workout.getWorkoutHistory(uid);
    result.fold(
      (failure) {
        state = WorkoutState.failed(failure);
        showFailureToast(failure);
      },
      (history) => state = WorkoutState.loaded(
        WorkoutData(
          prescriptions: _currentData()?.prescriptions ?? const [],
          history: history,
        ),
      ),
    );
  }

  Future<bool> createOwnWorkoutPlan(
    String clientUid,
    WorkoutPrescription w,
  ) async {
    final data = _currentData() ?? const WorkoutData();
    state = WorkoutState.submitting(data);
    final result = await _workout.createOwnWorkoutPlan(clientUid, w);
    return result.fold(
      (failure) {
        state = WorkoutState.loaded(data);
        showFailureToast(failure);
        return false;
      },
      (_) {
        state = WorkoutState.loaded(data);
        return true;
      },
    );
  }

  Future<bool> prescribe(
    String trainerUid,
    String clientUid,
    WorkoutPrescription w,
  ) async {
    final data = _currentData() ?? const WorkoutData();
    state = WorkoutState.submitting(data);
    final result = await _workout.prescribeWorkout(trainerUid, clientUid, w);
    return result.fold(
      (failure) {
        state = WorkoutState.loaded(data);
        showFailureToast(failure);
        return false;
      },
      (_) {
        state = WorkoutState.loaded(data);
        return true;
      },
    );
  }

  Future<WorkoutPrescription?> loadPrescriptionById(String prescriptionId) async {
    final result = await _workout.getPrescriptionById(prescriptionId);
    return result.fold((failure) {
      showFailureToast(failure);
      return null;
    }, (prescription) => prescription);
  }

  Future<bool> complete(String uid, WorkoutSession s) async {
    final data = _currentData() ?? const WorkoutData();
    state = WorkoutState.submitting(data);
    final result = await _workout.completeWorkout(uid, s);
    return result.fold(
      (failure) {
        state = WorkoutState.loaded(data);
        showFailureToast(failure);
        return false;
      },
      (_) {
        state = WorkoutState.loaded(data);
        return true;
      },
    );
  }

  Future<void> removePrescription({
    required String clientId,
    required String prescriptionId,
    String? requesterId,
    bool isTrainerRequest = false,
  }) async {
    final data = _currentData() ?? const WorkoutData();
    state = WorkoutState.submitting(data);
    final result = await _workout.removePrescription(
      clientId: clientId,
      prescriptionId: prescriptionId,
      requesterId: requesterId,
      isTrainerRequest: isTrainerRequest,
    );
    result.fold(
      (failure) {
        state = WorkoutState.loaded(data);
        showFailureToast(failure);
      },
      (_) {
        state = WorkoutState.loaded(data);
        showSuccessToast('Workout removed.');
        loadPrescriptions(clientId);
      },
    );
  }

  Future<void> refresh(String uid) => loadPrescriptions(uid);

  Future<WorkoutPrescription?> getTodaysPrescription(String uid) async {
    final result = await _workout.getPrescribedWorkouts(uid);
    return result.fold(
      (_) => null,
      (list) => WorkoutPlanMapper.findTodaysPrescription(list),
    );
  }

  Future<bool> hasCompletedWorkoutToday(String uid) async {
    final result = await _workout.getWorkoutHistory(uid);
    return result.fold(
      (_) => false,
      (history) {
        final now = DateTime.now();
        return history.any(
          (s) => WorkoutPlanMapper.isSameCalendarDay(s.dateTime, now),
        );
      },
    );
  }

  Future<void> loadWorkoutSessionData(String uid) async {
    _setLoadingState();
    final prescriptionsResult = await _workout.getPrescribedWorkouts(uid);
    final historyResult = await _workout.getWorkoutHistory(uid);
    prescriptionsResult.fold(
      (failure) {
        state = WorkoutState.failed(failure);
        showFailureToast(failure);
      },
      (prescriptions) {
        historyResult.fold(
          (failure) {
            state = WorkoutState.failed(failure);
            showFailureToast(failure);
          },
          (history) {
            state = WorkoutState.loaded(
              WorkoutData(prescriptions: prescriptions, history: history),
            );
          },
        );
      },
    );
  }

  WorkoutData? _currentData() => state.maybeMap(
        loaded: (value) => value.data,
        submitting: (value) => value.data,
        refreshing: (value) => value.data,
        orElse: () => null,
      );

  void _setLoadingState() {
    final data = _currentData();
    if (data != null) {
      state = WorkoutState.refreshing(data);
      return;
    }
    state = const WorkoutState.loading();
  }
}

final workoutViewModelProvider =
    StateNotifierProvider<WorkoutViewModel, WorkoutState>(
  (_) => WorkoutViewModel(workout: sl<WorkoutUseCase>()),
);
