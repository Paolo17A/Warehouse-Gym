import 'package:freezed_annotation/freezed_annotation.dart';

part 'trainer_clients_state.freezed.dart';

@freezed
class TrainerClientsData with _$TrainerClientsData {
  const factory TrainerClientsData({
    @Default([]) List<Map<String, dynamic>> currentClients,
    @Default([]) List<Map<String, dynamic>> pendingRequests,
  }) = _TrainerClientsData;
}

@freezed
class TrainerClientsState with _$TrainerClientsState {
  const factory TrainerClientsState.loading() = _Loading;
  const factory TrainerClientsState.failure(String message) = _Failure;
  const factory TrainerClientsState.success(TrainerClientsData data) = _Success;
}
