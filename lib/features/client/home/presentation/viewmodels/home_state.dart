import 'package:the_warehouse_gym/core/errors/failures.dart';
import 'package:the_warehouse_gym/features/shared/account/domain/entities/full_user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = Initial;
  const factory HomeState.loading() = Loading;
  const factory HomeState.refreshing(FullUser user) = Refreshing;
  const factory HomeState.loaded(FullUser user) = Loaded;
  const factory HomeState.failed(Failure failure) = Failed;
}

extension HomeStateX on HomeState {
  bool get isLoading => this is Loading || this is Refreshing;

  FullUser? get user => maybeMap(
        loaded: (value) => value.user,
        refreshing: (value) => value.user,
        orElse: () => null,
      );

  Failure? get failure => maybeMap(
        failed: (value) => value.failure,
        orElse: () => null,
      );
}
