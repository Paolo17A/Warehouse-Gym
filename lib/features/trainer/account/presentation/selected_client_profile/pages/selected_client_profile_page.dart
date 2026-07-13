import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:the_warehouse_gym/core/constants/app_colors.dart';
import 'package:the_warehouse_gym/core/errors/failures.dart';
import 'package:the_warehouse_gym/core/providers/session_providers.dart';
import 'package:the_warehouse_gym/core/router/app_router.dart';
import 'package:the_warehouse_gym/core/widgets/fitnessco_ui.dart';
import 'package:the_warehouse_gym/core/widgets/loading_widget.dart';
import 'package:the_warehouse_gym/core/widgets/no_internet_widget.dart';
import 'package:the_warehouse_gym/features/trainer/account/presentation/selected_client_profile/viewmodels/trainer_selected_client_profile_viewmodel.dart';
import 'package:the_warehouse_gym/features/shared/users/presentation/widgets/client_profile_body.dart';

class SelectedClientProfilePage extends HookConsumerWidget {
  final String clientUid;

  const SelectedClientProfilePage({super.key, required this.clientUid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trainerUid = ref.watch(sessionUserProvider)?.uid ?? '';
    final viewModel =
        ref.read(trainerSelectedClientProfileViewModelProvider.notifier);
    final state = ref.watch(trainerSelectedClientProfileViewModelProvider);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.loadProfile(clientUid);
      });
      return null;
    }, [clientUid]);

    if (state.isLoading) return const Scaffold(body: LoadingWidget());

    if (state.failure is NetworkFailure) {
      return Scaffold(
        body: NoInternetWidget(onRetry: () => viewModel.refresh(clientUid)),
      );
    }

    final user = state.user;
    final relationship = user?.trainerRelationship;
    final canPrescribe = relationship?.currentTrainer == trainerUid;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: largeGradientAppBar('Client Profile'),
      body: ViewTrainerBackground(
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => viewModel.refresh(clientUid),
            color: AppColors.purpleSnail,
            child: user == null
                ? ListView(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Center(
                          child: fitnesscoText(
                            'No profile found.',
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
                      ClientProfileBody(user: user),
                      if (canPrescribe) ...[
                        Center(
                          child: AuthGradientButton(
                            label: 'PRESCRIBE WORKOUT',
                            width: 280,
                            onTap: () => context.push(
                              AppRouter.prescribeWorkout(clientUid),
                            ),
                          ),
                        ),
                        const Gap(16),
                        Center(
                          child: AuthGradientButton(
                            label: 'SEND MESSAGE',
                            width: 280,
                            onTap: () => context.push(
                              AppRouter.chat(
                                clientUid,
                                name: user.fullName,
                                isClient: false,
                              ),
                            ),
                          ),
                        ),
                        const Gap(24),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
