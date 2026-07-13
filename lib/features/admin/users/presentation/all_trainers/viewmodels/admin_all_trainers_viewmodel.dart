import 'package:the_warehouse_gym/core/di/injection.dart';
import 'package:the_warehouse_gym/features/admin/users/domain/usecases/users_usecase.dart';
import 'package:the_warehouse_gym/features/admin/users/presentation/all_trainers/viewmodels/admin_all_trainers_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

export 'admin_all_trainers_state.dart';

class AdminAllTrainersViewModel extends StateNotifier<AdminAllTrainersState> {
  final UsersUseCase _users;

  AdminAllTrainersViewModel({required UsersUseCase users})
      : _users = users,
        super(const AdminAllTrainersState.loading());

  Future<void> loadTrainers() async {
    final hasData = state.maybeWhen(success: (_) => true, orElse: () => false);
    if (!hasData) {
      state = const AdminAllTrainersState.loading();
    }
    final result = await _users.getAllTrainers();
    result.fold(
      (failure) => state = AdminAllTrainersState.failure(failure.message),
      (trainers) => state = AdminAllTrainersState.success(trainers),
    );
  }

  Future<void> deleteTrainer(String trainerUid) async {
    state = const AdminAllTrainersState.loading();
    final result = await _users.deleteTrainer(trainerUid);
    result.fold(
      (failure) => state = AdminAllTrainersState.failure(failure.message),
      (_) => loadTrainers(),
    );
  }

  Future<void> refresh() => loadTrainers();
}

final adminAllTrainersViewModelProvider =
    StateNotifierProvider<AdminAllTrainersViewModel, AdminAllTrainersState>(
        (_) {
  return AdminAllTrainersViewModel(users: sl<UsersUseCase>());
});
