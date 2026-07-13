import 'package:the_warehouse_gym/core/di/injection.dart';
import 'package:the_warehouse_gym/features/client/account/presentation/selected_trainer_profile/viewmodels/client_selected_trainer_profile_state.dart';
import 'package:the_warehouse_gym/features/shared/account/domain/usecases/account_usecase.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

export 'client_selected_trainer_profile_state.dart';

class ClientSelectedTrainerProfileViewModel
    extends StateNotifier<ClientSelectedTrainerProfileState> {
  final AccountUseCase _account;
  String? _activeUid;

  ClientSelectedTrainerProfileViewModel({required AccountUseCase account})
      : _account = account,
        super(const ClientSelectedTrainerProfileState.initial());

  Future<void> loadProfile(String trainerUid) async {
    _setLoadingIfNeeded(trainerUid);
    final result = await _account.getProfile(trainerUid);
    if (_activeUid != trainerUid) return;
    result.fold(
      (failure) =>
          state = ClientSelectedTrainerProfileState.failed(failure),
      (user) => state = ClientSelectedTrainerProfileState.loaded(user),
    );
  }

  Future<void> refresh(String trainerUid) => loadProfile(trainerUid);

  void _setLoadingIfNeeded(String uid) {
    if (_activeUid != uid) {
      _activeUid = uid;
      state = const ClientSelectedTrainerProfileState.loading();
      return;
    }
    final hasData = state.maybeWhen(loaded: (_) => true, orElse: () => false);
    if (!hasData) {
      state = const ClientSelectedTrainerProfileState.loading();
    }
  }
}

final clientSelectedTrainerProfileViewModelProvider = StateNotifierProvider<
    ClientSelectedTrainerProfileViewModel,
    ClientSelectedTrainerProfileState>((_) {
  return ClientSelectedTrainerProfileViewModel(account: sl<AccountUseCase>());
});
