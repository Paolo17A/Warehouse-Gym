import 'package:the_warehouse_gym/core/di/injection.dart';
import 'package:the_warehouse_gym/features/admin/account/domain/repositories/admin_account_repository.dart';
import 'package:the_warehouse_gym/features/client/account/domain/repositories/client_account_repository.dart';
import 'package:the_warehouse_gym/features/shared/account/data/repositories/account_repository_impl.dart';
import 'package:the_warehouse_gym/features/shared/account/data/services/profile_service.dart';
import 'package:the_warehouse_gym/features/shared/account/domain/repositories/account_repository.dart';
import 'package:the_warehouse_gym/features/trainer/account/domain/repositories/trainer_account_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final profileServiceProvider = Provider<ProfileService>(
  (_) => sl<ProfileService>(),
);

final accountRepositoryImplProvider = Provider<AccountRepositoryImpl>(
  (_) => sl<AccountRepositoryImpl>(),
);

final accountRepositoryProvider = Provider<AccountRepository>(
  (_) => sl<AccountRepository>(),
);

final clientAccountRepositoryProvider = Provider<ClientAccountRepository>(
  (_) => sl<ClientAccountRepository>(),
);

final adminAccountRepositoryProvider = Provider<AdminAccountRepository>(
  (_) => sl<AdminAccountRepository>(),
);

final trainerAccountRepositoryProvider = Provider<TrainerAccountRepository>(
  (_) => sl<TrainerAccountRepository>(),
);
