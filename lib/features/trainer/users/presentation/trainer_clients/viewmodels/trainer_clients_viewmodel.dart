import 'package:the_warehouse_gym/core/di/injection.dart';
import 'package:the_warehouse_gym/features/trainer/users/domain/usecases/trainer_users_usecase.dart';
import 'package:the_warehouse_gym/features/trainer/users/presentation/trainer_clients/viewmodels/trainer_clients_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

export 'trainer_clients_state.dart';

class TrainerClientsViewModel extends StateNotifier<TrainerClientsState> {
  final TrainerUsersUseCase _users;

  TrainerClientsViewModel({required TrainerUsersUseCase users})
      : _users = users,
        super(const TrainerClientsState.loading());

  Future<void> loadClients(String trainerUid) async {
    if (trainerUid.isEmpty) return;

    final hasData = state.maybeWhen(success: (_) => true, orElse: () => false);
    if (!hasData) {
      state = const TrainerClientsState.loading();
    }
    final result = await _users.getTrainerClients(trainerUid);
    result.fold(
      (failure) => state = TrainerClientsState.failure(failure.message),
      (clients) => state = TrainerClientsState.success(_splitClients(clients)),
    );
  }

  Future<void> confirmClient(String trainerUid, String clientUid) async {
    final data = _currentData();
    if (data == null) return;

    final pendingIndex =
        data.pendingRequests.indexWhere((c) => c['uid'] == clientUid);
    if (pendingIndex == -1) return;

    final client = Map<String, dynamic>.from(data.pendingRequests[pendingIndex]);
    client['clientStatus'] = 'CONFIRMED';
    client['isPending'] = false;

    final pending = [...data.pendingRequests]..removeAt(pendingIndex);
    state = TrainerClientsState.success(
      data.copyWith(
        pendingRequests: pending,
        currentClients: [...data.currentClients, client],
      ),
    );

    final result = await _users.confirmClient(trainerUid, clientUid);
    result.fold(
      (failure) {
        state = TrainerClientsState.failure(failure.message);
        loadClients(trainerUid);
      },
      (_) {},
    );
  }

  Future<void> rejectClient(String trainerUid, String clientUid) async {
    final data = _currentData();
    if (data == null) return;

    final pending = data.pendingRequests
        .where((c) => c['uid'] != clientUid)
        .toList();
    state = TrainerClientsState.success(
      data.copyWith(pendingRequests: pending),
    );

    final result = await _users.rejectClient(trainerUid, clientUid);
    result.fold(
      (failure) {
        state = TrainerClientsState.failure(failure.message);
        loadClients(trainerUid);
      },
      (_) {},
    );
  }

  Future<void> removeClient(String trainerUid, String clientUid) async {
    final data = _currentData();
    if (data == null) return;

    final current = data.currentClients
        .where((c) => c['uid'] != clientUid)
        .toList();
    state = TrainerClientsState.success(
      data.copyWith(currentClients: current),
    );

    final result = await _users.removeClient(trainerUid, clientUid);
    result.fold(
      (failure) {
        state = TrainerClientsState.failure(failure.message);
        loadClients(trainerUid);
      },
      (_) {},
    );
  }

  Future<void> refresh(String trainerUid) => loadClients(trainerUid);

  TrainerClientsData? _currentData() =>
      state.maybeWhen(success: (data) => data, orElse: () => null);

  TrainerClientsData _splitClients(List<Map<String, dynamic>> clients) {
    final pending = <Map<String, dynamic>>[];
    final current = <Map<String, dynamic>>[];

    for (final client in clients) {
      if (client['clientStatus'] == 'PENDING') {
        pending.add(client);
      } else {
        current.add(client);
      }
    }

    return TrainerClientsData(
      currentClients: current,
      pendingRequests: pending,
    );
  }
}

final trainerClientsViewModelProvider =
    StateNotifierProvider<TrainerClientsViewModel, TrainerClientsState>((_) {
  return TrainerClientsViewModel(users: sl<TrainerUsersUseCase>());
});
