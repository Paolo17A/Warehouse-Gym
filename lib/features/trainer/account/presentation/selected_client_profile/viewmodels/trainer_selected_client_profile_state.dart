import 'package:the_warehouse_gym/core/errors/failures.dart';
import 'package:the_warehouse_gym/features/shared/account/domain/entities/full_user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'trainer_selected_client_profile_state.freezed.dart';

@freezed
class TrainerSelectedClientProfileState with _$TrainerSelectedClientProfileState {
  const factory TrainerSelectedClientProfileState.initial() = Initial;
  const factory TrainerSelectedClientProfileState.loading() = Loading;
  const factory TrainerSelectedClientProfileState.failed(Failure failure) =
      Failed;
  const factory TrainerSelectedClientProfileState.loaded(FullUser? user) =
      Loaded;
}

extension TrainerSelectedClientProfileStateX on TrainerSelectedClientProfileState {
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
