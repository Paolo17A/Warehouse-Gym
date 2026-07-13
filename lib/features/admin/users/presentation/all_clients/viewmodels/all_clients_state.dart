import 'package:freezed_annotation/freezed_annotation.dart';

part 'all_clients_state.freezed.dart';

@freezed
class AllClientsState with _$AllClientsState {
  const factory AllClientsState.loading() = Loading;
  const factory AllClientsState.failure(String message) = Failure;
  const factory AllClientsState.success(
    List<Map<String, dynamic>> clients,
  ) = Success;
}
