import 'package:the_warehouse_gym/core/errors/failures.dart';
import 'package:the_warehouse_gym/features/shared/account/domain/entities/full_user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'client_selected_trainer_profile_state.freezed.dart';

@freezed
class ClientSelectedTrainerProfileState with _$ClientSelectedTrainerProfileState {
  const factory ClientSelectedTrainerProfileState.initial() = Initial;
  const factory ClientSelectedTrainerProfileState.loading() = Loading;
  const factory ClientSelectedTrainerProfileState.failed(Failure failure) =
      Failed;
  const factory ClientSelectedTrainerProfileState.loaded(FullUser? user) =
      Loaded;
}

extension ClientSelectedTrainerProfileStateX on ClientSelectedTrainerProfileState {
  bool get isLoading => this is Loading;

  FullUser? get user => maybeMap(
        loaded: (value) => value.user,
        orElse: () => null,
      );

  Failure? get failure => maybeMap(
        failed: (value) => value.failure,
        orElse: () => null,
      );
}
