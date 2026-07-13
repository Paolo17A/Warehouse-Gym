import 'package:the_warehouse_gym/core/di/injection.dart';
import 'package:the_warehouse_gym/features/trainer/account/domain/usecases/trainer_account_usecase.dart';
import 'package:the_warehouse_gym/features/trainer/account/presentation/selected_client_profile/viewmodels/trainer_selected_client_profile_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

export 'trainer_selected_client_profile_state.dart';

class TrainerSelectedClientProfileViewModel
    extends StateNotifier<TrainerSelectedClientProfileState> {
  final TrainerAccountUseCase _account;
  String? _activeUid;

  TrainerSelectedClientProfileViewModel({required TrainerAccountUseCase account})
      : _account = account,
        super(const TrainerSelectedClientProfileState.initial());

  Future<void> loadProfile(String clientUid) async {
    _setLoadingIfNeeded(clientUid);
    final result = await _account.getProfile(clientUid);
    if (_activeUid != clientUid) return;
    result.fold(
      (failure) => state = TrainerSelectedClientProfileState.failed(failure),
      (user) => state = TrainerSelectedClientProfileState.loaded(user),
    );
  }

  Future<void> refresh(String clientUid) => loadProfile(clientUid);

  void _setLoadingIfNeeded(String uid) {
    if (_activeUid != uid) {
      _activeUid = uid;
      state = const TrainerSelectedClientProfileState.loading();
      return;
    }
    final hasData = state.maybeWhen(loaded: (_) => true, orElse: () => false);
    if (!hasData) {
      state = const TrainerSelectedClientProfileState.loading();
    }
  }
}

final trainerSelectedClientProfileViewModelProvider = StateNotifierProvider<
    TrainerSelectedClientProfileViewModel,
    TrainerSelectedClientProfileState>((_) {
  return TrainerSelectedClientProfileViewModel(
    account: sl<TrainerAccountUseCase>(),
  );
});
