import 'package:the_warehouse_gym/features/admin/account/domain/repositories/admin_account_repository.dart';
import 'package:the_warehouse_gym/features/admin/account/domain/usecases/admin_account_usecase.dart';
import 'package:the_warehouse_gym/features/admin/users/domain/repositories/users_repository.dart';
import 'package:the_warehouse_gym/features/admin/users/domain/usecases/users_usecase.dart';
import 'package:the_warehouse_gym/features/client/account/domain/repositories/client_account_repository.dart';
import 'package:the_warehouse_gym/features/client/account/domain/usecases/client_account_usecase.dart';
import 'package:the_warehouse_gym/features/client/bmi/domain/repositories/bmi_repository.dart';
import 'package:the_warehouse_gym/features/client/bmi/domain/usecases/bmi_usecase.dart';
import 'package:the_warehouse_gym/features/client/messaging/domain/repositories/messaging_repository.dart';
import 'package:the_warehouse_gym/features/client/messaging/domain/usecases/messaging_usecase.dart';
import 'package:the_warehouse_gym/features/client/workout/domain/repositories/workout_repository.dart';
import 'package:the_warehouse_gym/features/client/workout/domain/usecases/workout_usecase.dart';
import 'package:the_warehouse_gym/features/shared/account/domain/repositories/account_repository.dart';
import 'package:the_warehouse_gym/features/shared/account/domain/usecases/account_usecase.dart';
import 'package:the_warehouse_gym/features/shared/auth/domain/repositories/auth_repository.dart';
import 'package:the_warehouse_gym/features/shared/auth/domain/usecases/auth_usecase.dart';
import 'package:the_warehouse_gym/features/trainer/account/domain/repositories/trainer_account_repository.dart';
import 'package:the_warehouse_gym/features/trainer/account/domain/usecases/trainer_account_usecase.dart';
import 'package:the_warehouse_gym/features/trainer/users/domain/repositories/trainer_users_repository.dart';
import 'package:the_warehouse_gym/features/trainer/users/domain/usecases/trainer_users_usecase.dart';
import 'package:get_it/get_it.dart';

void registerUseCases(GetIt sl) {
  sl.registerLazySingleton<AuthUseCase>(
    () => AuthUseCase(sl<AuthRepository>()),
  );

  sl.registerLazySingleton<AccountUseCase>(
    () => AccountUseCase(sl<AccountRepository>()),
  );

  sl.registerLazySingleton<AdminAccountUseCase>(
    () => AdminAccountUseCase(sl<AdminAccountRepository>()),
  );

  sl.registerLazySingleton<TrainerAccountUseCase>(
    () => TrainerAccountUseCase(sl<TrainerAccountRepository>()),
  );

  sl.registerLazySingleton<ClientAccountUseCase>(
    () => ClientAccountUseCase(sl<ClientAccountRepository>()),
  );

  sl.registerLazySingleton<UsersUseCase>(
    () => UsersUseCase(sl<UsersRepository>()),
  );

  sl.registerLazySingleton<WorkoutUseCase>(
    () => WorkoutUseCase(sl<WorkoutRepository>()),
  );

  sl.registerLazySingleton<MessagingUseCase>(
    () => MessagingUseCase(sl<MessagingRepository>()),
  );

  sl.registerLazySingleton<BmiUseCase>(
    () => BmiUseCase(sl<BmiRepository>()),
  );

  sl.registerLazySingleton<TrainerUsersUseCase>(
    () => TrainerUsersUseCase(sl<TrainerUsersRepository>()),
  );
}
