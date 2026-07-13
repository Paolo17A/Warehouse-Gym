import 'package:the_warehouse_gym/core/di/injection.dart';
import 'package:the_warehouse_gym/features/admin/users/domain/usecases/users_usecase.dart';
import 'package:the_warehouse_gym/features/client/users/presentation/all_trainers/viewmodels/client_all_trainers_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

export 'client_all_trainers_state.dart';

class ClientAllTrainersViewModel extends StateNotifier<ClientAllTrainersState> {
  final UsersUseCase _users;

  ClientAllTrainersViewModel({required UsersUseCase users})
      : _users = users,
        super(const ClientAllTrainersState.loading());

  Future<void> loadTrainers() async {
    final hasData = state.maybeWhen(success: (_) => true, orElse: () => false);
    if (!hasData) {
      state = const ClientAllTrainersState.loading();
    }
    final result = await _users.getAllTrainers();
    result.fold(
      (failure) => state = ClientAllTrainersState.failure(failure.message),
      (trainers) => state = ClientAllTrainersState.success(trainers),
    );
  }

  Future<void> refresh() => loadTrainers();
}

final clientAllTrainersViewModelProvider =
    StateNotifierProvider<ClientAllTrainersViewModel, ClientAllTrainersState>(
        (_) {
  return ClientAllTrainersViewModel(users: sl<UsersUseCase>());
});
