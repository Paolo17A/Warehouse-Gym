import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_all_trainers_state.freezed.dart';

@freezed
class AdminAllTrainersState with _$AdminAllTrainersState {
  const factory AdminAllTrainersState.loading() = Loading;
  const factory AdminAllTrainersState.failure(String message) = Failure;
  const factory AdminAllTrainersState.success(
    List<Map<String, dynamic>> trainers,
  ) = Success;
}
