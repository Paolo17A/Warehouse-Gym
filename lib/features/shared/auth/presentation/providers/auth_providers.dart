import 'package:the_warehouse_gym/core/di/injection.dart';
import 'package:the_warehouse_gym/features/shared/auth/data/services/auth_service.dart';
import 'package:the_warehouse_gym/features/shared/auth/domain/repositories/auth_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authServiceProvider = Provider<AuthService>(
  (_) => sl<AuthService>(),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (_) => sl<AuthRepository>(),
);
