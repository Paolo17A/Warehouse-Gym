import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../features/shared/auth/presentation/welcome/welcome_page.dart';
import '../../features/shared/auth/presentation/login/sign_in_page.dart';
import '../../features/shared/auth/presentation/register/sign_up_page.dart';
import '../../features/shared/auth/presentation/forgot_password/forgot_password_page.dart';
import '../../features/client/account/presentation/complete_profile/pages/complete_profile_page.dart';
import '../../features/client/account/presentation/profile_completed/pages/profile_completed_page.dart';
import '../../features/client/account/presentation/edit_client_profile/pages/edit_client_profile_page.dart';
import '../../features/trainer/account/presentation/edit_trainer_profile/pages/edit_trainer_profile_page.dart';
import '../../features/client/account/presentation/selected_trainer_profile/pages/client_selected_trainer_profile_page.dart';
import '../../features/admin/users/presentation/selected_trainer/pages/admin_selected_trainer_profile_page.dart';
import '../../features/trainer/account/presentation/selected_client_profile/pages/selected_client_profile_page.dart';
import '../../features/admin/users/presentation/selected_client/pages/admin_selected_client_profile_page.dart';

import '../../features/client/home/presentation/pages/client_home_page.dart';
import '../../features/trainer/home/presentation/pages/trainer_home_page.dart';
import '../../features/admin/home/pages/admin_home_page.dart';

import '../../features/client/workout/presentation/client_workout/pages/client_workout_page.dart';
import '../../features/client/workout/presentation/create_workout_plan/pages/create_workout_plan_page.dart';
import '../../features/client/workout/presentation/workout_history/pages/workout_history_page.dart';
import '../../features/trainer/workout/prescribe_workout_page.dart';
import '../../features/client/workout/presentation/start_workout/pages/start_workout_page.dart';
import '../../features/client/workout/presentation/warm_up/pages/warm_up_page.dart';
import '../../features/client/workout/presentation/camera_workout/utils/workout_plan_mapper.dart';
import '../../features/client/workout/presentation/camera_workout/pages/camera_workout_page.dart';

import '../../features/client/bmi/presentation/bmi_history/pages/bmi_history_page.dart';
import '../../features/client/bmi/presentation/add_bmi/pages/add_bmi_page.dart';

import '../../features/client/messaging/presentation/chat/pages/chat_page.dart';

import '../../features/admin/users/presentation/all_clients/pages/all_clients_page.dart';
import '../../features/client/users/presentation/all_trainers/pages/client_all_trainers_page.dart';
import '../../features/admin/users/presentation/all_trainers/pages/admin_all_trainers_page.dart';
import '../../features/admin/users/presentation/add_trainer/pages/add_trainer_page.dart';
import '../../features/trainer/users/presentation/trainer_clients/pages/trainer_clients_page.dart';
import '../../features/trainer/users/presentation/trainer_schedule/pages/trainer_schedule_page.dart';

import '../providers/session_providers.dart';
import '../../features/shared/auth/presentation/login/auth_redirect_resolver.dart';

/// Central definition of all app route paths.
class AppRouter {
  AppRouter._();

  // ── Auth ─────────────────────────────────────────────────────────────
  static const welcome = '/';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/login/forgot-password';

  static const publicRoutes = [welcome, login, register, forgotPassword];

  // ── Account ──────────────────────────────────────────────────────────
  static const completeProfile = '/complete-profile';
  static const profileCompleted = '/profile-completed';
  static const editClientProfile = '/edit-client-profile';
  static const editTrainerProfile = '/edit-trainer-profile';
  static const adminSelectedClientRoute = '/admin/selected-client/:uid';
  static const clientSelectedTrainerRoute = '/client/selected-trainer/:uid';
  static const adminSelectedTrainerRoute = '/admin/selected-trainer/:uid';
  static const trainerSelectedClientRoute = '/trainer/selected-client/:uid';

  static String adminSelectedClient(String uid) =>
      '/admin/selected-client/$uid';

  static String clientSelectedTrainer(String uid) =>
      '/client/selected-trainer/$uid';

  static String adminSelectedTrainer(String uid) =>
      '/admin/selected-trainer/$uid';

  static String trainerSelectedClient(String uid) =>
      '/trainer/selected-client/$uid';

  // ── Home ─────────────────────────────────────────────────────────────
  static const clientHome = '/client-home';
  static const trainerHome = '/trainer-home';
  static const adminHome = '/admin-home';

  // ── Workout ──────────────────────────────────────────────────────────
  static const clientWorkout = '/client-workout';
  static const createWorkoutPlan = '/create-workout-plan';
  static const workoutHistory = '/workout-history';
  static const prescribeWorkoutRoute = '/prescribe-workout/:clientUid';
  static const startWorkout = '/start-workout';
  static const warmUp = '/warm-up';
  static const cameraWorkout = '/camera-workout';

  static String prescribeWorkout(
    String clientUid, {
    String? prescriptionId,
    bool returnToSchedule = false,
  }) {
    return Uri(
      path: '/prescribe-workout/$clientUid',
      queryParameters: {
        if (prescriptionId != null) 'prescriptionId': prescriptionId,
        if (returnToSchedule) 'returnToSchedule': 'true',
      },
    ).toString();
  }

  // ── BMI ──────────────────────────────────────────────────────────────
  static const bmiHistory = '/bmi-history';
  static const addBmi = '/add-bmi';

  // ── Messaging ────────────────────────────────────────────────────────
  static const chatRoute = '/chat/:otherUid';

  static String chat(
    String otherUid, {
    String? name,
    required bool isClient,
  }) {
    return Uri(
      path: '/chat/$otherUid',
      queryParameters: {
        if (name != null) 'name': name,
        'isClient': isClient.toString(),
      },
    ).toString();
  }

  // ── Users ────────────────────────────────────────────────────────────
  static const adminAllClients = '/admin/all-clients';
  static const clientAllTrainers = '/client/all-trainers';
  static const adminAllTrainers = '/admin/all-trainers';
  static const addTrainer = '/add-trainer';
  static const trainerClients = '/trainer-clients';
  static const trainerSchedule = '/trainer-schedule';
}

/// ChangeNotifier that triggers GoRouter rebuilds on auth state change
class _AuthChangeNotifier extends ChangeNotifier {
  late final StreamSubscription<dynamic> _sub;

  _AuthChangeNotifier(Stream<dynamic> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final session = ref.watch(sessionServiceProvider);
  final notifier = _AuthChangeNotifier(session.authStateChanges);

  ref.onDispose(notifier.dispose);

  return GoRouter(
    initialLocation: AppRouter.welcome,
    refreshListenable: notifier,
    redirect: (context, state) {
      if (session.isBootstrapping) return null;

      final isLoggedIn = session.isAuthenticated;
      final location = state.matchedLocation;
      final isPublic = AppRouter.publicRoutes.contains(location);

      if (!isLoggedIn && !isPublic) return AppRouter.welcome;

      // Persist session across restarts: skip welcome/login when already authed.
      if (isLoggedIn && isPublic) {
        final user = session.currentUser;
        if (user != null) return resolveAuthRedirect(user);
      }
      return null;
    },
    routes: [
      // ── Auth ─────────────────────────────────────────────────────────
      GoRoute(
        path: AppRouter.welcome,
        builder: (_, __) => const WelcomePage(),
      ),
      GoRoute(
        path: AppRouter.login,
        builder: (_, __) => const SignInPage(),
        routes: [
          GoRoute(
            path: 'forgot-password',
            builder: (_, __) => const ForgotPasswordPage(),
          ),
        ],
      ),
      GoRoute(
        path: AppRouter.register,
        builder: (_, __) => const SignUpPage(),
      ),
      // ── Account ──────────────────────────────────────────────────────
      GoRoute(
        path: AppRouter.completeProfile,
        builder: (_, __) => const CompleteProfilePage(),
      ),
      GoRoute(
        path: AppRouter.profileCompleted,
        builder: (_, __) => const ProfileCompletedPage(),
      ),
      GoRoute(
        path: AppRouter.editClientProfile,
        builder: (_, __) => const EditClientProfilePage(),
      ),
      GoRoute(
        path: AppRouter.editTrainerProfile,
        builder: (_, __) => const EditTrainerProfilePage(),
      ),
      GoRoute(
        path: AppRouter.adminSelectedClientRoute,
        builder: (_, state) => AdminSelectedClientProfilePage(
          clientUid: state.pathParameters['uid']!,
        ),
      ),
      GoRoute(
        path: AppRouter.clientSelectedTrainerRoute,
        builder: (_, state) => ClientSelectedTrainerProfilePage(
          trainerUid: state.pathParameters['uid']!,
        ),
      ),
      GoRoute(
        path: AppRouter.adminSelectedTrainerRoute,
        builder: (_, state) => AdminSelectedTrainerProfilePage(
          trainerUid: state.pathParameters['uid']!,
        ),
      ),
      GoRoute(
        path: AppRouter.trainerSelectedClientRoute,
        builder: (_, state) => SelectedClientProfilePage(
          clientUid: state.pathParameters['uid']!,
        ),
      ),

      // ── Home ─────────────────────────────────────────────────────────
      GoRoute(
        path: AppRouter.clientHome,
        builder: (_, __) => const ClientHomePage(),
      ),
      GoRoute(
        path: AppRouter.trainerHome,
        builder: (_, __) => const TrainerHomePage(),
      ),
      GoRoute(
        path: AppRouter.adminHome,
        builder: (_, __) => const AdminHomePage(),
      ),

      // ── Workout ──────────────────────────────────────────────────────
      GoRoute(
        path: AppRouter.clientWorkout,
        builder: (_, __) => const ClientWorkoutPage(),
      ),
      GoRoute(
        path: AppRouter.createWorkoutPlan,
        builder: (_, __) => const CreateWorkoutPlanPage(),
      ),
      GoRoute(
        path: AppRouter.workoutHistory,
        builder: (_, __) => const WorkoutHistoryPage(),
      ),
      GoRoute(
        path: AppRouter.prescribeWorkoutRoute,
        builder: (_, state) => PrescribeWorkoutPage(
          clientUid: state.pathParameters['clientUid']!,
          prescriptionId: state.uri.queryParameters['prescriptionId'],
          returnToSchedule:
              state.uri.queryParameters['returnToSchedule'] == 'true',
        ),
      ),
      GoRoute(
        path: AppRouter.startWorkout,
        builder: (_, state) {
          final extra = parseSessionExtra(
            state.extra as Map<String, dynamic>?,
          );
          return StartWorkoutPage(
            exercises: exercisesFromExtra(extra),
            description: descriptionFromExtra(extra),
          );
        },
      ),
      GoRoute(
        path: AppRouter.warmUp,
        builder: (_, state) {
          final extra = parseSessionExtra(
            state.extra as Map<String, dynamic>?,
          );
          return WarmUpPage(sessionExtra: extra);
        },
      ),
      GoRoute(
        path: AppRouter.cameraWorkout,
        builder: (_, state) {
          final extra = parseSessionExtra(
            state.extra as Map<String, dynamic>?,
          );
          return CameraWorkoutPage(
            exercises: exercisesFromExtra(extra),
            description: descriptionFromExtra(extra),
          );
        },
      ),

      // ── BMI ──────────────────────────────────────────────────────────
      GoRoute(
        path: AppRouter.bmiHistory,
        builder: (_, __) => const BmiHistoryPage(),
      ),
      GoRoute(
        path: AppRouter.addBmi,
        builder: (_, __) => const AddBmiPage(),
      ),

      // ── Messaging ────────────────────────────────────────────────────
      GoRoute(
        path: AppRouter.chatRoute,
        builder: (_, state) => ChatPage(
          otherUid: state.pathParameters['otherUid']!,
          otherName: state.uri.queryParameters['name'] ?? 'Chat',
          isClientView: state.uri.queryParameters['isClient'] == 'true',
        ),
      ),

      // ── Users ────────────────────────────────────────────────────────
      GoRoute(
        path: AppRouter.adminAllClients,
        builder: (_, __) => const AllClientsPage(),
      ),
      GoRoute(
        path: AppRouter.clientAllTrainers,
        builder: (_, __) => const ClientAllTrainersPage(),
      ),
      GoRoute(
        path: AppRouter.adminAllTrainers,
        builder: (_, __) => const AdminAllTrainersPage(),
      ),
      GoRoute(
        path: AppRouter.addTrainer,
        builder: (_, __) => const AddTrainerPage(),
      ),
      GoRoute(
        path: AppRouter.trainerClients,
        builder: (_, __) => const TrainerClientsPage(),
      ),
      GoRoute(
        path: AppRouter.trainerSchedule,
        builder: (_, __) => const TrainerSchedulePage(),
      ),
    ],
  );
});
