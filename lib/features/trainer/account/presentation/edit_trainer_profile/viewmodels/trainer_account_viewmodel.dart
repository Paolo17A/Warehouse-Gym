import 'package:the_warehouse_gym/core/di/injection.dart';
import 'package:the_warehouse_gym/core/utils/toast_utils.dart';
import 'package:the_warehouse_gym/features/shared/account/domain/entities/full_user.dart';
import 'package:the_warehouse_gym/features/trainer/account/domain/usecases/trainer_account_usecase.dart';
import 'package:the_warehouse_gym/features/trainer/account/presentation/edit_trainer_profile/viewmodels/trainer_account_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

export 'trainer_account_state.dart';

class TrainerAccountViewModel extends StateNotifier<TrainerAccountState> {
  final TrainerAccountUseCase _account;
  String? _activeProfileUid;

  TrainerAccountViewModel({required TrainerAccountUseCase account})
      : _account = account,
        super(const TrainerAccountState.initial());

  Future<void> loadProfile(String uid) async {
    final sameProfile = _activeProfileUid == uid;
    _activeProfileUid = uid;
    _setLoadingState(sameProfile);
    final result = await _account.getProfile(uid);
    if (_activeProfileUid != uid) return;
    result.fold(
      (failure) {
        showFailureToast(failure);
        state = TrainerAccountState.failed(failure);
      },
      (user) => state = TrainerAccountState.loaded(user),
    );
  }

  Future<bool> updateProfile(String uid, Map<String, dynamic> data) async {
    final user = _currentUser();
    if (user == null) return false;

    state = TrainerAccountState.submitting(user);
    final result = await _account.updateProfile(uid, data);
    return result.fold(
      (failure) {
        showFailureToast(failure);
        state = TrainerAccountState.loaded(user);
        return false;
      },
      (_) {
        showSuccessToast('Profile updated successfully.');
        state = TrainerAccountState.loaded(user);
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

    state = TrainerAccountState.submitting(user);
    final uploadResult = await _account.uploadProfileImage(uid, filePath);
    return uploadResult.fold(
      (failure) {
        showFailureToast(failure);
        state = TrainerAccountState.loaded(user);
        return false;
      },
      (url) async {
        return updateProfile(uid, {'profileImageURL': url});
      },
    );
  }

  Future<void> refresh(String uid) => loadProfile(uid);

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
        state = TrainerAccountState.refreshing(user);
        return;
      }
    }
    state = const TrainerAccountState.loading();
  }
}

final trainerAccountViewModelProvider =
    StateNotifierProvider<TrainerAccountViewModel, TrainerAccountState>((_) {
  return TrainerAccountViewModel(account: sl<TrainerAccountUseCase>());
});
