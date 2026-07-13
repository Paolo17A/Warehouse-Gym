import 'package:the_warehouse_gym/core/di/injection.dart';
import 'package:the_warehouse_gym/features/admin/users/domain/usecases/users_usecase.dart';
import 'package:the_warehouse_gym/features/admin/users/presentation/all_clients/viewmodels/all_clients_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

export 'all_clients_state.dart';

class AllClientsViewModel extends StateNotifier<AllClientsState> {
  final UsersUseCase _users;

  AllClientsViewModel({required UsersUseCase users})
      : _users = users,
        super(const AllClientsState.loading());

  Future<void> loadClients() async {
    final hasData = state.maybeWhen(success: (_) => true, orElse: () => false);
    if (!hasData) {
      state = const AllClientsState.loading();
    }
    final result = await _users.getAllClients();
    result.fold(
      (failure) => state = AllClientsState.failure(failure.message),
      (clients) => state = AllClientsState.success(clients),
    );
  }

  Future<void> refresh() => loadClients();
}

final allClientsViewModelProvider =
    StateNotifierProvider<AllClientsViewModel, AllClientsState>((_) {
  return AllClientsViewModel(users: sl<UsersUseCase>());
});
