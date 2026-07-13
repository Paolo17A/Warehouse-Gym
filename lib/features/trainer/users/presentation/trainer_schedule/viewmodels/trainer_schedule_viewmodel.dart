import 'package:the_warehouse_gym/core/di/injection.dart';
import 'package:the_warehouse_gym/features/admin/users/domain/usecases/users_usecase.dart';
import 'package:the_warehouse_gym/features/trainer/users/presentation/trainer_schedule/viewmodels/trainer_schedule_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

export 'trainer_schedule_state.dart';

class TrainerScheduleViewModel extends StateNotifier<TrainerScheduleState> {
  final UsersUseCase _users;

  TrainerScheduleViewModel({required UsersUseCase users})
      : _users = users,
        super(const TrainerScheduleState.loading());

  Future<void> loadSchedule(String trainerUid) async {
    if (trainerUid.isEmpty) return;

    final hasData = state.maybeWhen(success: (_) => true, orElse: () => false);
    if (!hasData) {
      state = const TrainerScheduleState.loading();
    }
    final result = await _users.getTrainerSchedule(trainerUid);
    result.fold(
      (failure) => state = TrainerScheduleState.failure(failure.message),
      (schedule) => state = TrainerScheduleState.success(schedule),
    );
  }

  Future<void> refresh(String trainerUid) => loadSchedule(trainerUid);
}

final trainerScheduleViewModelProvider =
    StateNotifierProvider<TrainerScheduleViewModel, TrainerScheduleState>((_) {
  return TrainerScheduleViewModel(users: sl<UsersUseCase>());
});
