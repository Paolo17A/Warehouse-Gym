import 'package:the_warehouse_gym/core/router/app_router.dart';
import 'package:gap/gap.dart';
import 'package:the_warehouse_gym/core/constants/app_colors.dart';
import 'package:the_warehouse_gym/core/errors/failures.dart';
import 'package:the_warehouse_gym/core/providers/session_providers.dart';
import 'package:the_warehouse_gym/core/widgets/fitnessco_ui.dart';
import 'package:the_warehouse_gym/core/widgets/loading_widget.dart';
import 'package:the_warehouse_gym/core/widgets/no_internet_widget.dart';
import 'package:the_warehouse_gym/features/trainer/home/presentation/viewmodels/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TrainerHomePage extends HookConsumerWidget {
  const TrainerHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(sessionUserProvider)?.uid ?? '';
    final homeState = ref.watch(homeViewModelProvider);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(homeViewModelProvider.notifier).loadDashboard(uid);
      });
      return null;
    }, [uid]);

    if (homeState is Loading && homeState.user == null) {
      return const Scaffold(body: LoadingWidget());
    }

    if (homeState.failure is NetworkFailure) {
      return Scaffold(
        body: NoInternetWidget(
          onRetry: () => ref.read(homeViewModelProvider.notifier).refresh(uid),
        ),
      );
    }

    final fullUser = homeState.user;
    final trainerProfile = fullUser?.trainerProfile;
    final trainerRel = fullUser?.trainerRelationship;
    final clientCount = trainerRel?.currentClients.length ?? 0;
    final certifications = trainerProfile?.certifications ?? [];
    final interests = trainerProfile?.interests ?? [];
    final specialties = trainerProfile?.specialty ?? [];
    final firstName =
        fullUser?.clientProfile?.firstName ?? fullUser?.email ?? '';
    final lastName = fullUser?.clientProfile?.lastName ?? '';

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: homeAppBar(
          context,
          ref: ref,
          onRefresh: () =>
              ref.read(homeViewModelProvider.notifier).refresh(uid),
          title: Column(
            children: [
              fitnesscoText(
                '$firstName $lastName',
                textStyle: blackBoldStyle(),
              ),
              fitnesscoText(
                '$clientCount Client${clientCount != 1 ? 's' : ''}',
                textStyle: blackBoldStyle(size: 15),
              ),
            ],
          ),
        ),
        body: SwitchedLoadingContainer(
          isLoading: homeState.isLoading,
          child: HomeBackground(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: buildProfileImage(
                      profileImageURL: fullUser?.profileImageURL ?? '',
                      radius: 50,
                    ),
                  ),
                  const Gap(40),
                  Column(
                    children: [
                      SizedBox(
                        height: 20,
                        width: 200,
                        child: fitnesscoText(
                          fullUser?.email ?? '',
                          textStyle: blackBoldStyle(size: 15),
                        ),
                      ),
                      const Gap(4),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: fitnesscoText(
                          trainerProfile?.contactNumber ?? '',
                          textStyle: blackBoldStyle(size: 15),
                        ),
                      ),
                      fitnesscoText(
                        (trainerProfile?.address.isNotEmpty == true)
                            ? trainerProfile!.address
                            : 'NO ADDRESS',
                        textStyle: whiteBoldStyle(size: 15),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          homeRowContainer(
                            iconPath: 'assets/images/icons/view_my_clients.png',
                            label: 'View My Clients',
                            onPress: () =>
                                context.push(AppRouter.trainerClients),
                          ),
                          homeRowContainer(
                            iconPath:
                                'assets/images/icons/view_my_schedule.png',
                            label: 'View My Schedule',
                            onPress: () =>
                                context.push(AppRouter.trainerSchedule),
                          ),
                          homeRowContainer(
                            iconPath:
                                'assets/images/icons/profile_description.png',
                            label: 'Profile Description',
                            onPress: () =>
                                context.push(AppRouter.editTrainerProfile),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      TabBar(
                        tabs: [
                          Tab(
                            child: fitnesscoText(
                              'CERTIFICATIONS',
                              textStyle: blackBoldStyle(size: 12),
                            ),
                          ),
                          Tab(
                            child: fitnesscoText(
                              'INTERESTS',
                              textStyle: blackBoldStyle(size: 15),
                            ),
                          ),
                          Tab(
                            child: fitnesscoText(
                              'TRAINING SPECIALTY',
                              textStyle: blackBoldStyle(size: 14),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 200,
                        child: TabBarView(
                          children: [
                            _tagGridTab(
                              items: certifications,
                              tileBuilder: _yellowPinkTile,
                            ),
                            _tagGridTab(
                              items: interests,
                              tileBuilder: _greenBlueTile,
                            ),
                            _tagGridTab(
                              items: specialties,
                              tileBuilder: _yellowPinkTile,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tagGridTab({
    required List<String> items,
    required Widget Function(String label) tileBuilder,
  }) {
    return Stack(
      children: [
        if (items.isEmpty)
          Center(
            child: fitnesscoText(
              'No items yet',
              textStyle: greyBoldStyle(size: 14),
            ),
          )
        else
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: GridView.builder(
                padding: const EdgeInsets.only(top: 36),
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 8,
                  childAspectRatio: 4.2,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) => tileBuilder(items[index]),
              ),
            ),
          ),
      ],
    );
  }

  Widget _yellowPinkTile(String label) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: const LinearGradient(
          colors: [AppColors.bananaMilk, AppColors.jigglypuff],
        ),
      ),
      child: fitnesscoText(
        label,
        textStyle: blackBoldStyle(size: 11),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _greenBlueTile(String label) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: const LinearGradient(
          colors: [AppColors.mintZest, AppColors.trueSky],
        ),
      ),
      child: fitnesscoText(
        label,
        textStyle: blackBoldStyle(size: 11),
        textAlign: TextAlign.center,
      ),
    );
  }
}
