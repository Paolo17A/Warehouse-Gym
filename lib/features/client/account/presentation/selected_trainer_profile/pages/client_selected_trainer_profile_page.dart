import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:the_warehouse_gym/core/constants/app_colors.dart';
import 'package:the_warehouse_gym/core/router/app_router.dart';
import 'package:the_warehouse_gym/core/providers/session_providers.dart';
import 'package:the_warehouse_gym/core/errors/failures.dart';
import 'package:the_warehouse_gym/core/widgets/fitnessco_ui.dart';
import 'package:the_warehouse_gym/core/widgets/loading_widget.dart';
import 'package:the_warehouse_gym/core/widgets/no_internet_widget.dart';
import 'package:the_warehouse_gym/features/client/account/presentation/selected_trainer_profile/viewmodels/client_selected_trainer_profile_viewmodel.dart';
import 'package:the_warehouse_gym/features/client/account/presentation/viewmodels/client_account_viewmodel.dart';
import 'package:the_warehouse_gym/features/shared/users/presentation/widgets/trainer_profile_body.dart';

class ClientSelectedTrainerProfilePage extends HookConsumerWidget {
  final String trainerUid;

  const ClientSelectedTrainerProfilePage({super.key, required this.trainerUid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel =
        ref.read(clientSelectedTrainerProfileViewModelProvider.notifier);
    final state = ref.watch(clientSelectedTrainerProfileViewModelProvider);
    final currentUser = ref.watch(sessionUserProvider);
    final clientUid = currentUser?.uid ?? '';

    final clientAccountViewModel =
        ref.read(clientAccountViewModelProvider.notifier);
    final clientAccountState = ref.watch(clientAccountViewModelProvider);

    final hasPendingRequest = useState<bool?>(null);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.loadProfile(trainerUid);
        if (clientUid.isNotEmpty) {
          clientAccountViewModel.loadProfile(clientUid);
        }
      });
      return null;
    }, [trainerUid, clientUid]);

    useEffect(() {
      if (clientUid.isEmpty) return null;
      Future(() async {
        final pending = await clientAccountViewModel.hasPendingTrainerRequest(
          clientUid,
          trainerUid,
        );
        hasPendingRequest.value = pending;
      });
      return null;
    }, [clientUid, trainerUid, clientAccountState.user]);

    if (state.isLoading) return const Scaffold(body: LoadingWidget());

    if (state.failure is NetworkFailure) {
      return Scaffold(
        body: NoInternetWidget(
          onRetry: () => viewModel.refresh(trainerUid),
        ),
      );
    }

    final user = state.user;
    final relationship = clientAccountState.user?.trainerRelationship;
    final currentTrainerId = relationship?.currentTrainer.trim() ?? '';
    final isConfirmedTrainer = currentTrainerId == trainerUid &&
        (relationship?.isConfirmed ?? false);
    final alreadyRequested = hasPendingRequest.value ?? false;

    Future<void> onRequestTrainer() async {
      if (alreadyRequested) {
        await clientAccountViewModel.cancelTrainerRequest(
          clientUid,
          trainerUid,
        );
      } else {
        await clientAccountViewModel.requestTrainer(clientUid, trainerUid);
      }
      if (context.mounted) {
        await clientAccountViewModel.refresh(clientUid);
        final pending = await clientAccountViewModel.hasPendingTrainerRequest(
          clientUid,
          trainerUid,
        );
        hasPendingRequest.value = pending;
      }
    }

    void openChat() {
      final name = user?.fullName ?? 'Trainer';
      context.push(
        AppRouter.chat(
          trainerUid,
          name: name,
          isClient: true,
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: largeGradientAppBar('All Trainers'),
      body: ViewTrainerBackground(
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await Future.wait([
                viewModel.refresh(trainerUid),
                if (clientUid.isNotEmpty)
                  clientAccountViewModel.refresh(clientUid),
              ]);
              if (clientUid.isNotEmpty) {
                hasPendingRequest.value =
                    await clientAccountViewModel.hasPendingTrainerRequest(
                  clientUid,
                  trainerUid,
                );
              }
            },
            color: AppColors.purpleSnail,
            child: user == null
                ? ListView(
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
                    children: [
                      TrainerProfileBody(user: user),
                      if (isConfirmedTrainer) ...[
                        Center(
                          child: fitnesscoText(
                            'This is your trainer',
                            textStyle: blackBoldStyle(size: 16),
                          ),
                        ),
                        const Gap(16),
                        Center(
                          child: AuthGradientButton(
                            label: 'Message This Trainer',
                            width: 280,
                            onTap: openChat,
                          ),
                        ),
                      ] else
                        Center(
                          child: AuthGradientButton(
                            label: alreadyRequested
                                ? 'Cancel Request'
                                : 'Request This Trainer',
                            width: 280,
                            onTap: clientAccountState.isSubmitting
                                ? () {}
                                : onRequestTrainer,
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
