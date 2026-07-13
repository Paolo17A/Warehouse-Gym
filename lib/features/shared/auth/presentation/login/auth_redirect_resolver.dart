import 'package:the_warehouse_gym/core/router/app_router.dart';
import 'package:the_warehouse_gym/features/shared/auth/domain/entities/app_user.dart';

String resolveAuthRedirect(AppUser user) {
  switch (user.accountType) {
    case 'TRAINER':
      return AppRouter.trainerHome;
    case 'ADMIN':
      return AppRouter.adminHome;
    default:
      return user.accountInitialized
          ? AppRouter.clientHome
          : AppRouter.completeProfile;
  }
}
