import 'package:the_warehouse_gym/core/di/injection.dart';
import 'package:the_warehouse_gym/core/session/session_service.dart';
import 'package:the_warehouse_gym/features/shared/auth/domain/entities/app_user.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final sessionServiceProvider = Provider<SessionService>(
  (ref) => sl<SessionService>(),
);

final authStateChangesProvider = StreamProvider<AppUser?>(
  (ref) => ref.watch(sessionServiceProvider).authStateChanges,
);

final sessionUserProvider = Provider<AppUser?>((ref) {
  final streamed = ref.watch(authStateChangesProvider).valueOrNull;
  // Broadcast streams do not replay; fall back to the in-memory session.
  return streamed ?? ref.watch(sessionServiceProvider).currentUser;
});

final isAuthenticatedProvider = Provider<bool>(
  (ref) => ref.watch(sessionUserProvider) != null,
);

final sessionBootstrappingProvider = Provider<bool>(
  (ref) => ref.watch(sessionServiceProvider).isBootstrapping,
);

/// Bumped when returning to client home so dashboard data reloads.
final clientHomeRefreshTickProvider = StateProvider<int>((ref) => 0);

void bumpClientHomeRefresh(WidgetRef ref) {
  ref.read(clientHomeRefreshTickProvider.notifier).state++;
}
