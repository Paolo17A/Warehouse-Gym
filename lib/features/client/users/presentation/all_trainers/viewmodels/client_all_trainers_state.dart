import 'package:freezed_annotation/freezed_annotation.dart';

part 'client_all_trainers_state.freezed.dart';

@freezed
class ClientAllTrainersState with _$ClientAllTrainersState {
  const factory ClientAllTrainersState.loading() = _Loading;
  const factory ClientAllTrainersState.failure(String message) = _Failure;
  const factory ClientAllTrainersState.success(
    List<Map<String, dynamic>> trainers,
  ) = _Success;
}
