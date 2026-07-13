import 'package:the_warehouse_gym/core/errors/failures.dart';
import 'package:the_warehouse_gym/features/shared/account/domain/entities/full_user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'trainer_account_state.freezed.dart';

@freezed
class TrainerAccountState with _$TrainerAccountState {
  const factory TrainerAccountState.initial() = Initial;
  const factory TrainerAccountState.loading() = Loading;
  const factory TrainerAccountState.refreshing(FullUser user) = Refreshing;
  const factory TrainerAccountState.loaded(FullUser user) = Loaded;
  const factory TrainerAccountState.submitting(FullUser user) = Submitting;
  const factory TrainerAccountState.failed(Failure failure) = Failed;
}

extension TrainerAccountStateX on TrainerAccountState {
  bool get isLoading => this is Loading;

  bool get isSubmitting => this is Submitting;

  FullUser? get user => maybeMap(
        loaded: (value) => value.user,
        submitting: (value) => value.user,
        refreshing: (value) => value.user,
        orElse: () => null,
      );

  Failure? get failure => maybeMap(
        failed: (value) => value.failure,
        orElse: () => null,
      );
}
