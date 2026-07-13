import 'package:the_warehouse_gym/core/errors/failures.dart';
import 'package:the_warehouse_gym/features/client/workout/domain/entities/workout_prescription.dart';
import 'package:the_warehouse_gym/features/client/workout/domain/entities/workout_session.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_state.freezed.dart';

@freezed
class WorkoutData with _$WorkoutData {
  const factory WorkoutData({
    @Default([]) List<WorkoutPrescription> prescriptions,
    @Default([]) List<WorkoutSession> history,
  }) = _WorkoutData;
}

@freezed
class WorkoutState with _$WorkoutState {
  const factory WorkoutState.initial() = Initial;
  const factory WorkoutState.loading() = Loading;
  const factory WorkoutState.refreshing(WorkoutData data) = Refreshing;
  const factory WorkoutState.loaded(WorkoutData data) = Loaded;
  const factory WorkoutState.submitting(WorkoutData data) = Submitting;
  const factory WorkoutState.failed(Failure failure) = Failed;
}

extension WorkoutStateX on WorkoutState {
  bool get isLoading => this is Loading || this is Refreshing;

  bool get isSubmitting => this is Submitting;

  Failure? get failure => maybeMap(
        failed: (value) => value.failure,
        orElse: () => null,
      );

  List<WorkoutPrescription> get prescriptions =>
      _data?.prescriptions ?? const [];

  List<WorkoutSession> get history => _data?.history ?? const [];

  WorkoutData? get _data => maybeMap(
        loaded: (value) => value.data,
        submitting: (value) => value.data,
        refreshing: (value) => value.data,
        orElse: () => null,
      );
}
