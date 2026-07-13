import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:toastification/toastification.dart';
import 'core/di/injection.dart';
import 'core/providers/camera_providers.dart';
import 'core/router/app_router.dart';
import 'core/session/session_service.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await dotenv.load(fileName: '.env');
  configureDependencies();
  await sl<SessionService>().tryAutoLogin();
  appCameras = await availableCameras();
  runApp(const ProviderScope(child: WarehouseGymApp()));
}

class WarehouseGymApp extends ConsumerWidget {
  const WarehouseGymApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return ToastificationWrapper(
      child: MaterialApp.router(
        title: 'The Warehouse Gym',
        theme: AppTheme.light,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
