import 'package:the_warehouse_gym/features/shared/account/domain/entities/full_user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_selected_client_profile_state.freezed.dart';

@freezed
class AdminSelectedClientProfileState with _$AdminSelectedClientProfileState {
  const factory AdminSelectedClientProfileState.initial() = Initial;
  const factory AdminSelectedClientProfileState.loading() = Loading;
  const factory AdminSelectedClientProfileState.failure(String message) =
      Failure;
  const factory AdminSelectedClientProfileState.success(FullUser? user) =
      Success;
}
