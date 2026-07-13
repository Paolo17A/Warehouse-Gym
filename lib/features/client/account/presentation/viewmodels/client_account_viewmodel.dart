import 'package:the_warehouse_gym/core/di/injection.dart';
import 'package:the_warehouse_gym/core/utils/toast_utils.dart';
import 'package:the_warehouse_gym/features/client/account/domain/usecases/client_account_usecase.dart';
import 'package:the_warehouse_gym/features/client/account/presentation/viewmodels/client_account_state.dart';
import 'package:the_warehouse_gym/features/shared/account/domain/entities/full_user.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

export 'client_account_state.dart';

class ClientAccountViewModel extends StateNotifier<ClientAccountState> {
  final ClientAccountUseCase _account;
  String? _activeProfileUid;

  ClientAccountViewModel({required ClientAccountUseCase account})
      : _account = account,
        super(const ClientAccountState.initial());

  Future<void> loadProfile(String uid) async {
    final sameProfile = _activeProfileUid == uid;
    _activeProfileUid = uid;
    _setLoadingState(sameProfile);
    final result = await _account.getProfile(uid);
    if (_activeProfileUid != uid) return;
    result.fold(
      (failure) {
        showFailureToast(failure);
        state = ClientAccountState.failed(failure);
      },
      (user) => state = ClientAccountState.loaded(user),
    );
  }

  Future<bool> updateProfile(String uid, Map<String, dynamic> data) async {
    final user = _currentUser();
    if (user == null) return false;

    state = ClientAccountState.submitting(user);
    final result = await _account.updateProfile(uid, data);
    return result.fold(
      (failure) {
        showFailureToast(failure);
        state = ClientAccountState.loaded(user);
        return false;
      },
      (_) {
        showSuccessToast('Profile updated successfully.');
        state = ClientAccountState.loaded(user);
        return true;
      },
    );
  }

  Future<bool> uploadAndUpdateProfileImage(
    String uid,
    String filePath,
  ) async {
    final user = _currentUser();
    if (user == null) return false;

    state = ClientAccountState.submitting(user);
    final uploadResult = await _account.uploadProfileImage(uid, filePath);
    return uploadResult.fold(
      (failure) {
        showFailureToast(failure);
        state = ClientAccountState.loaded(user);
        return false;
      },
      (url) async {
        return updateProfile(uid, {'profileImageURL': url});
      },
    );
  }

  Future<bool> requestTrainer(String clientUid, String trainerUid) async {
    final user = _currentUser();
    if (user == null) return false;

    state = ClientAccountState.submitting(user);
    final result = await _account.requestTrainer(clientUid, trainerUid);
    return result.fold(
      (failure) {
        showFailureToast(failure);
        state = ClientAccountState.loaded(user);
        return false;
      },
      (_) {
        showSuccessToast('Trainer request sent.');
        state = ClientAccountState.loaded(user);
        return true;
      },
    );
  }

  Future<bool> cancelTrainerRequest(
    String clientUid,
    String trainerUid,
  ) async {
    final user = _currentUser();
    if (user == null) return false;

    state = ClientAccountState.submitting(user);
    final result =
        await _account.cancelTrainerRequest(clientUid, trainerUid);
    return result.fold(
      (failure) {
        showFailureToast(failure);
        state = ClientAccountState.loaded(user);
        return false;
      },
      (_) {
        showSuccessToast('Trainer request cancelled.');
        state = ClientAccountState.loaded(user);
        return true;
      },
    );
  }

  Future<void> refresh(String uid) => loadProfile(uid);

  Future<bool> hasPendingTrainerRequest(
    String clientUid,
    String trainerUid,
  ) async {
    final result = await _account.hasPendingTrainerRequest(
      clientUid,
      trainerUid,
    );
    return result.fold((_) => false, (value) => value);
  }

  FullUser? _currentUser() => state.maybeMap(
        loaded: (value) => value.user,
        submitting: (value) => value.user,
        refreshing: (value) => value.user,
        orElse: () => null,
      );

  void _setLoadingState(bool sameProfile) {
    if (sameProfile) {
      final user = _currentUser();
      if (user != null) {
        state = ClientAccountState.refreshing(user);
        return;
      }
    }
    state = const ClientAccountState.loading();
  }
}

final clientAccountViewModelProvider =
    StateNotifierProvider<ClientAccountViewModel, ClientAccountState>((_) {
  return ClientAccountViewModel(account: sl<ClientAccountUseCase>());
});
