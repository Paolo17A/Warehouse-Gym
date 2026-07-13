import 'package:the_warehouse_gym/core/di/injection.dart';
import 'package:the_warehouse_gym/features/admin/account/domain/usecases/admin_account_usecase.dart';
import 'package:the_warehouse_gym/features/admin/users/domain/usecases/users_usecase.dart';
import 'package:the_warehouse_gym/features/admin/users/presentation/selected_trainer/viewmodels/admin_selected_trainer_profile_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

export 'admin_selected_trainer_profile_state.dart';

class AdminSelectedTrainerProfileViewModel
    extends StateNotifier<AdminSelectedTrainerProfileState> {
  final AdminAccountUseCase _account;
  final UsersUseCase _users;

  AdminSelectedTrainerProfileViewModel({
    required AdminAccountUseCase account,
    required UsersUseCase users,
  })  : _account = account,
        _users = users,
        super(const AdminSelectedTrainerProfileState.loading());

  Future<void> loadProfile(String trainerUid) async {
    state = const AdminSelectedTrainerProfileState.loading();
    final result = await _account.getProfile(trainerUid);
    result.fold(
      (failure) =>
          state = AdminSelectedTrainerProfileState.failure(failure.message),
      (user) => state = AdminSelectedTrainerProfileState.success(user),
    );
  }

  Future<bool> deleteTrainer(String trainerUid) async {
    state = const AdminSelectedTrainerProfileState.loading();
    final result = await _users.deleteTrainer(trainerUid);
    return result.fold(
      (failure) {
        state = AdminSelectedTrainerProfileState.failure(failure.message);
        return false;
      },
      (_) => true,
    );
  }

  Future<void> refresh(String trainerUid) => loadProfile(trainerUid);
}

final adminSelectedTrainerProfileViewModelProvider = StateNotifierProvider((_) {
  return AdminSelectedTrainerProfileViewModel(
    account: sl<AdminAccountUseCase>(),
    users: sl<UsersUseCase>(),
  );
});
