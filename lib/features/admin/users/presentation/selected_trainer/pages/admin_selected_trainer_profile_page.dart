import 'package:the_warehouse_gym/core/widgets/loading_widget.dart';
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:the_warehouse_gym/core/constants/app_colors.dart';
import 'package:the_warehouse_gym/core/router/app_router.dart';
import 'package:the_warehouse_gym/core/utils/toast_utils.dart';
import 'package:the_warehouse_gym/core/widgets/fitnessco_ui.dart';
import 'package:the_warehouse_gym/features/admin/users/presentation/selected_trainer/viewmodels/admin_selected_trainer_profile_viewmodel.dart';
import 'package:the_warehouse_gym/features/shared/account/domain/entities/full_user.dart';
import 'package:the_warehouse_gym/features/shared/users/presentation/widgets/trainer_profile_body.dart';

class AdminSelectedTrainerProfilePage extends HookConsumerWidget {
  final String trainerUid;

  const AdminSelectedTrainerProfilePage({super.key, required this.trainerUid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel =
        ref.read(adminSelectedTrainerProfileViewModelProvider.notifier);
    final state = ref.watch(adminSelectedTrainerProfileViewModelProvider);
    final isLoading = state is Loading;
    final fullUser = useState<FullUser?>(null);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.loadProfile(trainerUid);
      });
      return null;
    }, [trainerUid]);

    ref.listen(
      adminSelectedTrainerProfileViewModelProvider,
      (_, next) {
        if (next is Success) {
          fullUser.value = next.user;
        }
        if (next is Failure) {
          showErrorToast(next.message);
        }
      },
    );

    Future<void> onDeleteTrainer(FullUser user) async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Delete Trainer'),
          content: Text(
            'Are you sure you want to remove ${user.fullName}? '
            'This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        ),
      );

      if (confirmed != true || !context.mounted) return;

      final success = await viewModel.deleteTrainer(trainerUid);
      if (!context.mounted || !success) return;

      showSuccessToast('Trainer removed successfully');
      context.go(AppRouter.adminAllTrainers);
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: largeGradientAppBar('Selected Trainer'),
      body: ViewTrainerBackground(
        child: isLoading
            ? const LoadingWidget()
            : SafeArea(
                child: RefreshIndicator(
                  onRefresh: () => viewModel.refresh(trainerUid),
                  color: AppColors.purpleSnail,
                  child: fullUser.value == null
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: Center(
                                child: fitnesscoText(
                                  'No trainer profile found.',
                                  textStyle: greyBoldStyle(size: 16),
                                ),
                              ),
                            ),
                          ],
                        )
                      : ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            TrainerProfileBody(
                              user: fullUser.value!,
                              containerBorderColor: AppColors.jigglypuff,
                            ),
                            Center(
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  minimumSize: const Size(280, 48),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: () =>
                                    onDeleteTrainer(fullUser.value!),
                                child: const Text('DELETE TRAINER'),
                              ),
                            ),
                            const Gap(24),
                          ],
                        ),
                ),
              ),
      ),
    );
  }
}
