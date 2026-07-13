import 'package:the_warehouse_gym/core/di/injection.dart';
import 'package:the_warehouse_gym/core/utils/toast_utils.dart';
import 'package:the_warehouse_gym/features/shared/account/domain/entities/full_user.dart';
import 'package:the_warehouse_gym/features/shared/account/domain/usecases/account_usecase.dart';
import 'package:the_warehouse_gym/features/client/home/presentation/viewmodels/home_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

export 'home_state.dart';

class HomeViewModel extends StateNotifier<HomeState> {
  final AccountUseCase _account;
  String? _activeUid;

  HomeViewModel({required AccountUseCase account})
      : _account = account,
        super(const HomeState.initial());

  Future<void> loadDashboard(String uid) async {
    final sameProfile = _activeUid == uid;
    _activeUid = uid;
    _setLoadingState(sameProfile);
    final result = await _account.getProfile(uid);
    if (_activeUid != uid) return;
    result.fold(
      (failure) {
        showFailureToast(failure);
        state = HomeState.failed(failure);
      },
      (user) => state = HomeState.loaded(user),
    );
  }

  Future<void> refresh(String uid) => loadDashboard(uid);

  void _setLoadingState(bool sameProfile) {
    if (sameProfile) {
      final user = _currentUser();
      if (user != null) {
        state = HomeState.refreshing(user);
        return;
      }
    }
    state = const HomeState.loading();
  }

  FullUser? _currentUser() => state.maybeMap(
        loaded: (value) => value.user,
        refreshing: (value) => value.user,
        orElse: () => null,
      );
}

final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, HomeState>((_) {
  return HomeViewModel(account: sl<AccountUseCase>());
});
