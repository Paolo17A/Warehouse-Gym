import 'package:the_warehouse_gym/core/di/injection.dart';
import 'package:the_warehouse_gym/features/admin/account/domain/usecases/admin_account_usecase.dart';
import 'package:the_warehouse_gym/features/admin/users/presentation/selected_client/viewmodels/admin_selected_client_profile_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

export 'admin_selected_client_profile_state.dart';

class AdminSelectedClientProfileViewModel
    extends StateNotifier<AdminSelectedClientProfileState> {
  final AdminAccountUseCase _account;
  String? _activeUid;

  AdminSelectedClientProfileViewModel({required AdminAccountUseCase account})
      : _account = account,
        super(const AdminSelectedClientProfileState.initial());

  Future<void> loadProfile(String clientUid) async {
    _setLoadingIfNeeded(clientUid);
    final result = await _account.getProfile(clientUid);
    if (_activeUid != clientUid) return;
    result.fold(
      (failure) =>
          state = AdminSelectedClientProfileState.failure(failure.message),
      (user) => state = AdminSelectedClientProfileState.success(user),
    );
  }

  Future<void> refresh(String clientUid) => loadProfile(clientUid);

  void _setLoadingIfNeeded(String uid) {
    if (_activeUid != uid) {
      _activeUid = uid;
      state = const AdminSelectedClientProfileState.loading();
      return;
    }
    final hasData = state.maybeWhen(success: (_) => true, orElse: () => false);
    if (!hasData) {
      state = const AdminSelectedClientProfileState.loading();
    }
  }
}

final adminSelectedClientProfileViewModelProvider = StateNotifierProvider<
    AdminSelectedClientProfileViewModel, AdminSelectedClientProfileState>((_) {
  return AdminSelectedClientProfileViewModel(
    account: sl<AdminAccountUseCase>(),
  );
});
