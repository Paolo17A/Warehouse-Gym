import 'package:the_warehouse_gym/core/router/app_router.dart';
import 'package:gap/gap.dart';
import 'package:the_warehouse_gym/core/constants/app_colors.dart';
import 'package:the_warehouse_gym/core/errors/failures.dart';
import 'package:the_warehouse_gym/core/widgets/fitnessco_ui.dart';
import 'package:the_warehouse_gym/core/widgets/loading_widget.dart';
import 'package:the_warehouse_gym/core/widgets/no_internet_widget.dart';
import 'package:the_warehouse_gym/features/admin/home/viewmodels/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:the_warehouse_gym/core/providers/session_providers.dart';

class AdminHomePage extends HookConsumerWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(sessionUserProvider)?.uid ?? '';
    final state = ref.watch(homeViewModelProvider);
    final viewModel = ref.read(homeViewModelProvider.notifier);

    useEffect(() {
      if (uid.isEmpty) return null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.loadDashboard(uid);
      });
      return null;
    }, [uid]);

    if (state is Loading && state.user == null) {
      return const Scaffold(body: LoadingWidget());
    }

    if (state.failure is NetworkFailure) {
      return Scaffold(
        body: NoInternetWidget(onRetry: () => viewModel.refresh(uid)),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: homeAppBar(context, ref: ref),
      body: RegisterAuthBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            fitnesscoText(
                              'FITNESSCO',
                              textAlign: TextAlign.left,
                              textStyle: const TextStyle(
                                color: AppColors.purpleSnail,
                                fontSize: 25,
                              ),
                            ),
                            fitnesscoText(
                              'Admin Panel',
                              textAlign: TextAlign.left,
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Gap(15),
                    adminHomeScreenButton(
                      context,
                      label: 'View All Trainers',
                      onTap: () => context.push(AppRouter.adminAllTrainers),
                      imagePath: 'assets/images/icons/view_all_trainers.png',
                      imageScale: 1.15,
                      color: AppColors.purpleSnail,
                    ),
                    const Gap(15),
                    adminHomeScreenButton(
                      context,
                      label: 'View All Clients',
                      onTap: () => context.push(AppRouter.adminAllClients),
                      imagePath: 'assets/images/icons/view_all_clients.png',
                      imageScale: 1.5,
                      color: const Color.fromARGB(255, 94, 200, 204),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
