import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_trainer_state.freezed.dart';

@freezed
class AddTrainerState with _$AddTrainerState {
  const factory AddTrainerState.initial() = Initial;
  const factory AddTrainerState.loading() = Loading;
  const factory AddTrainerState.failure(String message) = Failure;
  const factory AddTrainerState.success() = Success;
}
