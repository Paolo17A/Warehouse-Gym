import 'package:the_warehouse_gym/features/admin/account/domain/repositories/admin_account_repository.dart';
import 'package:the_warehouse_gym/features/admin/users/data/repositories/users_repository_impl.dart';
import 'package:the_warehouse_gym/features/admin/users/domain/repositories/users_repository.dart';
import 'package:the_warehouse_gym/features/client/account/domain/repositories/client_account_repository.dart';
import 'package:the_warehouse_gym/features/client/bmi/data/repositories/bmi_repository_impl.dart';
import 'package:the_warehouse_gym/features/client/bmi/domain/repositories/bmi_repository.dart';
import 'package:the_warehouse_gym/features/client/messaging/data/repositories/messaging_repository_impl.dart';
import 'package:the_warehouse_gym/features/client/messaging/domain/repositories/messaging_repository.dart';
import 'package:the_warehouse_gym/features/client/workout/data/repositories/workout_repository_impl.dart';
import 'package:the_warehouse_gym/features/client/workout/domain/repositories/workout_repository.dart';
import 'package:the_warehouse_gym/features/shared/account/data/repositories/account_repository_impl.dart';
import 'package:the_warehouse_gym/features/shared/account/domain/repositories/account_repository.dart';
import 'package:the_warehouse_gym/features/shared/auth/data/repositories/auth_repository_impl.dart';
import 'package:the_warehouse_gym/features/shared/auth/domain/repositories/auth_repository.dart';
import 'package:the_warehouse_gym/features/trainer/account/domain/repositories/trainer_account_repository.dart';
import 'package:the_warehouse_gym/features/trainer/users/data/repositories/trainer_users_repository_impl.dart';
import 'package:the_warehouse_gym/features/trainer/users/domain/repositories/trainer_users_repository.dart';
import 'package:get_it/get_it.dart';

void registerRepositories(GetIt sl) {
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      networkInfo: sl(),
      authService: sl(),
      sessionService: sl(),
    ),
  );

  sl.registerLazySingleton<AccountRepositoryImpl>(
    () => AccountRepositoryImpl(
      service: sl(),
      trainerRequests: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<AccountRepository>(() => sl<AccountRepositoryImpl>());
  sl.registerLazySingleton<ClientAccountRepository>(
    () => sl<AccountRepositoryImpl>(),
  );
  sl.registerLazySingleton<AdminAccountRepository>(
    () => sl<AccountRepositoryImpl>(),
  );
  sl.registerLazySingleton<TrainerAccountRepository>(
    () => sl<AccountRepositoryImpl>(),
  );

  sl.registerLazySingleton<UsersRepository>(
    () => UsersRepositoryImpl(
      service: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<WorkoutRepository>(
    () => WorkoutRepositoryImpl(
      sl(),
      sl(),
    ),
  );

  sl.registerLazySingleton<MessagingRepository>(
    () => MessagingRepositoryImpl(
      sl(),
      sl(),
    ),
  );

  sl.registerLazySingleton<BmiRepository>(
    () => BmiRepositoryImpl(
      sl(),
      sl(),
    ),
  );

  sl.registerLazySingleton<TrainerUsersRepository>(
    () => TrainerUsersRepositoryImpl(
      service: sl(),
      networkInfo: sl(),
    ),
  );
}
