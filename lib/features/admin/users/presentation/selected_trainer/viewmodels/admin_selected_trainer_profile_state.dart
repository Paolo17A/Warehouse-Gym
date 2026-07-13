import 'package:the_warehouse_gym/features/shared/account/domain/entities/full_user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_selected_trainer_profile_state.freezed.dart';

@freezed
class AdminSelectedTrainerProfileState with _$AdminSelectedTrainerProfileState {
  const factory AdminSelectedTrainerProfileState.loading() = Loading;
  const factory AdminSelectedTrainerProfileState.failure(String message) =
      Failure;
  const factory AdminSelectedTrainerProfileState.success(FullUser? user) =
      Success;
}
