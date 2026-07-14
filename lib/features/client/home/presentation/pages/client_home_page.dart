import 'package:the_warehouse_gym/core/router/app_router.dart';
import 'package:gap/gap.dart';
import 'package:the_warehouse_gym/core/constants/app_colors.dart';
import 'package:the_warehouse_gym/core/errors/failures.dart';
import 'package:the_warehouse_gym/core/providers/session_providers.dart';
import 'package:the_warehouse_gym/core/widgets/fitnessco_ui.dart';
import 'package:the_warehouse_gym/core/widgets/loading_widget.dart';
import 'package:the_warehouse_gym/core/widgets/no_internet_widget.dart';
import 'package:the_warehouse_gym/features/client/bmi/domain/utils/bmi_calculator.dart';
import 'package:the_warehouse_gym/features/client/home/presentation/viewmodels/home_viewmodel.dart';
import 'package:the_warehouse_gym/features/client/workout/presentation/camera_workout/utils/workout_plan_mapper.dart';
import 'package:the_warehouse_gym/features/client/workout/presentation/viewmodels/workout_viewmodel.dart'
    hide Loading;
import 'package:the_warehouse_gym/core/utils/toast_utils.dart';
import 'package:the_warehouse_gym/features/shared/account/domain/entities/full_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

String _resolveCurrentBmiDisplay(FullUser? user) {
  if (user == null) return '0.0';

  if (user.bmiHistory.isNotEmpty) {
    final last = user.bmiHistory.last;
    if (last is Map) {
      final value = last['bmiValue'];
      if (value is num) return value.toString();
      if (value is String && value.isNotEmpty) return value;
    }
  }

  final profile = user.clientProfile;
  if (profile != null && profile.height > 0 && profile.weight > 0) {
    return BmiCalculator.fromMetric(
      heightCm: profile.height,
      weightKg: profile.weight,
    ).toString();
  }

  return '0.0';
}

class ClientHomePage extends HookConsumerWidget {
  const ClientHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(sessionUserProvider)?.uid ?? '';
    final homeState = ref.watch(homeViewModelProvider);
    final workoutState = ref.watch(workoutViewModelProvider);
    final homeRefreshTick = ref.watch(clientHomeRefreshTickProvider);

    Future<void> refreshHome() async {
      if (uid.isEmpty) return;
      await Future.wait([
        ref.read(homeViewModelProvider.notifier).refresh(uid),
        ref.read(workoutViewModelProvider.notifier).loadWorkoutSessionData(uid),
      ]);
    }

    useEffect(() {
      if (uid.isEmpty) return null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        refreshHome();
      });
      return null;
    }, [uid, homeRefreshTick]);

    final tabController = useTabController(initialLength: 2);
    useListenable(tabController);
    if (homeState is Loading && homeState.user == null) {
      return const Scaffold(body: LoadingWidget());
    }

    if (homeState.failure is NetworkFailure) {
      return Scaffold(
        body: NoInternetWidget(
          onRetry: refreshHome,
        ),
      );
    }

    final fullUser = homeState.user;
    final profile = fullUser?.clientProfile;
    final trainerRel = fullUser?.trainerRelationship;
    final currentTrainerId = trainerRel?.currentTrainer.trim() ?? '';
    final hasConfirmedTrainer =
        (trainerRel?.isConfirmed == true) && currentTrainerId.isNotEmpty;
    final firstName = profile?.firstName ?? '';
    final lastName = profile?.lastName ?? '';
    final bmiValue = _resolveCurrentBmiDisplay(fullUser);

    final todaysPrescription = workoutState.maybeMap(
      loaded: (s) =>
          WorkoutPlanMapper.findTodaysPrescription(s.data.prescriptions),
      refreshing: (s) =>
          WorkoutPlanMapper.findTodaysPrescription(s.data.prescriptions),
      submitting: (s) =>
          WorkoutPlanMapper.findTodaysPrescription(s.data.prescriptions),
      orElse: () => null,
    );
    final hasTodaysPlan = todaysPrescription != null;
    final hasAnyWorkoutPlans = workoutState.maybeMap(
      loaded: (s) => s.data.prescriptions.isNotEmpty,
      refreshing: (s) => s.data.prescriptions.isNotEmpty,
      submitting: (s) => s.data.prescriptions.isNotEmpty,
      orElse: () => false,
    );
    final completedToday = workoutState.maybeMap(
      loaded: (s) => s.data.history.any(
        (h) => WorkoutPlanMapper.isSameCalendarDay(
          h.dateTime,
          DateTime.now(),
        ),
      ),
      refreshing: (s) => s.data.history.any(
        (h) => WorkoutPlanMapper.isSameCalendarDay(
          h.dateTime,
          DateTime.now(),
        ),
      ),
      submitting: (s) => s.data.history.any(
        (h) => WorkoutPlanMapper.isSameCalendarDay(
          h.dateTime,
          DateTime.now(),
        ),
      ),
      orElse: () => false,
    );

    Future<void> startWorkoutSession() async {
      final prescription = todaysPrescription;
      if (prescription == null) {
        showInfoToast('You have no assigned workout today.');
        return;
      }
      final extra =
          WorkoutPlanMapper.sessionExtraFromPrescription(prescription);
      await context.push(AppRouter.startWorkout, extra: extra);
      if (!context.mounted) return;
      await refreshHome();
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: homeAppBar(
        context,
        ref: ref,
        title: fitnesscoText(
          '$firstName $lastName',
          textStyle: blackBoldStyle(),
        ),
      ),
      body: SwitchedLoadingContainer(
        isLoading: homeState is Loading,
        child: HomeBackground(
          child: SafeArea(
            child: RefreshIndicator(
              color: AppColors.purpleSnail,
              onRefresh: refreshHome,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: buildProfileImage(
                        profileImageURL: fullUser?.profileImageURL ?? '',
                        radius: 50,
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 20,
                          width: 200,
                          child: fitnesscoText(
                            'AGE:  ${profile?.age ?? 0}',
                            textStyle: blackBoldStyle(size: 15),
                          ),
                        ),
                        const Gap(4),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: GestureDetector(
                            onTap: () => context.push(AppRouter.bmiHistory),
                            child: fitnesscoText(
                              'CURRENT BMI: $bmiValue',
                              textStyle: blackBoldStyle(size: 15),
                            ),
                          ),
                        ),
                        if (hasConfirmedTrainer)
                          SizedBox(
                            height: 28,
                            child: ElevatedButton(
                              onPressed: () {
                                context.push(
                                  AppRouter.chat(
                                    currentTrainerId,
                                    name: 'My Trainer',
                                    isClient: true,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.nearMoon,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 0,
                                ),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: fitnesscoText(
                                'Message my Trainer',
                                textStyle: whiteBoldStyle(size: 12),
                              ),
                            ),
                          )
                        else
                          fitnesscoText(
                            'No Current Trainer',
                            textStyle: whiteBoldStyle(size: 13),
                          ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            homeRowContainer(
                              iconPath: 'assets/images/icons/view_trainers.png',
                              imageScale: 60,
                              label: 'View All Trainers',
                              onPress: () =>
                                  context.push(AppRouter.clientAllTrainers),
                            ),
                            homeRowContainer(
                              iconPath:
                                  'assets/images/icons/view_workouts_plan.png',
                              imageScale: 60,
                              label: 'View My Workout Plan',
                              onPress: () =>
                                  context.push(AppRouter.clientWorkout),
                            ),
                            homeRowContainer(
                              iconPath:
                                  'assets/images/icons/personal_history.png',
                              imageScale: 60,
                              label: 'Personal History',
                              onPress: () =>
                                  context.push(AppRouter.workoutHistory),
                            ),
                            homeRowContainer(
                              iconPath:
                                  'assets/images/icons/edit_profile_description.png',
                              imageScale: 60,
                              label: 'Update BMI',
                              onPress: () =>
                                  context.push(AppRouter.bmiHistory),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TabBar(
                            controller: tabController,
                            tabs: [
                              Tab(
                                child: fitnesscoText(
                                  'MY TRAINING SESSION',
                                  textStyle: blackBoldStyle(size: 12),
                                ),
                              ),
                              Tab(
                                child: fitnesscoText(
                                  'PROFILE DESCRIPTION',
                                  textStyle: blackBoldStyle(size: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (tabController.index == 0)
                          Column(
                            children: [
                              SizedBox(
                                height: 150,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: Image.asset(
                                        hasConfirmedTrainer
                                            ? 'assets/images/icons/has_trainer.png'
                                            : 'assets/images/icons/no_trainer.png',
                                        height: 150,
                                      ),
                                    ),
                                    if (!hasAnyWorkoutPlans)
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: fitnesscoText(
                                          'YOU HAVE NO WORKOUT PLANS. REQUEST FROM A TRAINER OR MAKE YOUR OWN FIRST',
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: ElevatedButton(
                                  onPressed: hasTodaysPlan
                                      ? startWorkoutSession
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    backgroundColor: AppColors.nearMoon,
                                  ),
                                  child: fitnesscoText(
                                    'START WORKOUT SESSION',
                                    textStyle: whiteBoldStyle(size: 15),
                                  ),
                                ),
                              ),
                              if (completedToday)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: fitnesscoText(
                                    'You already worked out today — you can do another session.',
                                    textStyle: greyBoldStyle(size: 12),
                                  ),
                                ),
                              if (!hasTodaysPlan)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                    bottom: 16,
                                  ),
                                  child: fitnesscoText(
                                    'No workout plan scheduled for today.',
                                    textStyle: greyBoldStyle(size: 12),
                                  ),
                                ),
                            ],
                          )
                        else
                          Column(
                            children: [
                              SizedBox(
                                height: 150,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: Image.asset(
                                        'assets/images/icons/edit_profile_description.png',
                                        height: 150,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          fitnesscoText(
                                            '$firstName $lastName',
                                            textStyle: blackBoldStyle(),
                                          ),
                                          fitnesscoText(
                                            'Height: ${profile?.height ?? 0} cm',
                                            textStyle: blackBoldStyle(size: 15),
                                          ),
                                          fitnesscoText(
                                            'Weight: ${profile?.weight ?? 0} kg',
                                            textStyle: blackBoldStyle(size: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await context.push(
                                      AppRouter.editClientProfile,
                                    );
                                    if (!context.mounted || uid.isEmpty) {
                                      return;
                                    }
                                    await Future.wait([
                                      ref
                                          .read(homeViewModelProvider.notifier)
                                          .refresh(uid),
                                      ref
                                          .read(
                                            workoutViewModelProvider.notifier,
                                          )
                                          .loadWorkoutSessionData(uid),
                                    ]);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    backgroundColor: AppColors.purpleSnail,
                                  ),
                                  child: fitnesscoText(
                                    'UPDATE YOUR PROFILE NOW',
                                    textStyle: whiteBoldStyle(size: 15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
