import 'package:freezed_annotation/freezed_annotation.dart';

part 'trainer_schedule_state.freezed.dart';

@freezed
class TrainerScheduleState with _$TrainerScheduleState {
  const factory TrainerScheduleState.loading() = _Loading;
  const factory TrainerScheduleState.failure(String message) = _Failure;
  const factory TrainerScheduleState.success(
    List<Map<String, dynamic>> schedule,
  ) = _Success;
}
