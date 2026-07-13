import 'package:the_warehouse_gym/core/di/injection.dart';
import 'package:the_warehouse_gym/features/admin/users/domain/usecases/users_usecase.dart';
import 'package:the_warehouse_gym/features/admin/users/presentation/add_trainer/viewmodels/add_trainer_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

export 'add_trainer_state.dart';

class AddTrainerViewModel extends StateNotifier<AddTrainerState> {
  final UsersUseCase _users;

  AddTrainerViewModel({required UsersUseCase users})
      : _users = users,
        super(const AddTrainerState.initial());

  Future addTrainer({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String idNumber,
  }) async {
    state = const AddTrainerState.loading();
    final result = await _users.addTrainer(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      idNumber: idNumber,
    );
    return result.fold(
      (failure) {
        state = AddTrainerState.failure(failure.message);
      },
      (_) {
        state = const AddTrainerState.success();
      },
    );
  }

  void reset() {
    state = const AddTrainerState.success();
  }
}

final addTrainerViewModelProvider =
    StateNotifierProvider<AddTrainerViewModel, AddTrainerState>((_) {
  return AddTrainerViewModel(users: sl<UsersUseCase>());
});
