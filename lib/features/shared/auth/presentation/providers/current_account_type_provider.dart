import 'package:the_warehouse_gym/core/providers/session_providers.dart';
import 'package:the_warehouse_gym/features/shared/auth/presentation/providers/auth_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final currentAccountTypeProvider = FutureProvider<String>((ref) async {
  final user = ref.watch(sessionUserProvider);
  if (user == null) return '';

  final result = await ref.watch(authRepositoryProvider).getCurrentUserData();
  return result.fold(
    (_) => user.accountType,
    (data) => data['accountType'] as String? ?? user.accountType,
  );
});
