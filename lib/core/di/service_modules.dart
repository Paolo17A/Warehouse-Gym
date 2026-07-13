import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:the_warehouse_gym/core/config/app_config.dart';
import 'package:the_warehouse_gym/core/network/api_client.dart';
import 'package:the_warehouse_gym/core/network/auth_secure_storage.dart';
import 'package:the_warehouse_gym/core/network/network_info.dart';
import 'package:the_warehouse_gym/core/session/session_service.dart';
import 'package:the_warehouse_gym/features/admin/users/data/services/users_service.dart';
import 'package:the_warehouse_gym/features/client/bmi/data/services/bmi_service.dart';
import 'package:the_warehouse_gym/features/client/messaging/data/services/chat_socket_service.dart';
import 'package:the_warehouse_gym/features/client/messaging/data/services/messaging_service.dart';
import 'package:the_warehouse_gym/features/client/workout/data/services/workout_service.dart';
import 'package:the_warehouse_gym/features/shared/account/data/services/profile_service.dart';
import 'package:the_warehouse_gym/features/shared/account/data/services/trainer_request_service.dart';
import 'package:the_warehouse_gym/features/shared/auth/data/services/auth_service.dart';
import 'package:get_it/get_it.dart';

void registerServices(GetIt sl) {
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl<Connectivity>()),
  );

  sl.registerLazySingleton<AppConfig>(() => const AppConfig());

  sl.registerLazySingleton<AuthSecureStorage>(AuthSecureStorage.new);

  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(
      config: sl<AppConfig>(),
      storage: sl<AuthSecureStorage>(),
    ),
  );

  sl.registerLazySingleton<AuthService>(() => AuthService(sl<ApiClient>()));

  sl.registerLazySingleton<SessionService>(
    () => SessionService(
      storage: sl<AuthSecureStorage>(),
      authService: sl<AuthService>(),
    ),
  );

  sl.registerLazySingleton<ProfileService>(
    () => ProfileService(sl<ApiClient>(), sl<SessionService>()),
  );

  sl.registerLazySingleton<TrainerRequestService>(
    () => TrainerRequestService(sl<ApiClient>()),
  );

  sl.registerLazySingleton<WorkoutService>(
    () => WorkoutService(sl<ApiClient>(), sl<SessionService>()),
  );

  sl.registerLazySingleton<BmiService>(() => BmiService(sl<ApiClient>()));

  sl.registerLazySingleton<UsersService>(
    () => UsersService(
      sl<ApiClient>(),
      sl<WorkoutService>(),
      sl<TrainerRequestService>(),
      sl<SessionService>(),
    ),
  );

  sl.registerLazySingleton<MessagingService>(
    () => MessagingService(sl<ApiClient>()),
  );

  sl.registerLazySingleton<ChatSocketService>(
    () => ChatSocketService(sl<AppConfig>()),
  );
}
