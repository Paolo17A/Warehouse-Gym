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

final sessionUserProvider = Provider<AppUser?>(
  (ref) => ref.watch(authStateChangesProvider).valueOrNull,
);

final isAuthenticatedProvider = Provider<bool>(
  (ref) => ref.watch(sessionUserProvider) != null,
);

final sessionBootstrappingProvider = Provider<bool>(
  (ref) => ref.watch(sessionServiceProvider).isBootstrapping,
);
