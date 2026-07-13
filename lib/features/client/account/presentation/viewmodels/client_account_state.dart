import 'package:the_warehouse_gym/core/errors/failures.dart';
import 'package:the_warehouse_gym/features/shared/account/domain/entities/full_user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'client_account_state.freezed.dart';

@freezed
class ClientAccountState with _$ClientAccountState {
  const factory ClientAccountState.initial() = Initial;
  const factory ClientAccountState.loading() = Loading;
  const factory ClientAccountState.refreshing(FullUser user) = Refreshing;
  const factory ClientAccountState.loaded(FullUser user) = Loaded;
  const factory ClientAccountState.submitting(FullUser user) = Submitting;
  const factory ClientAccountState.failed(Failure failure) = Failed;
}

extension ClientAccountStateX on ClientAccountState {
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
