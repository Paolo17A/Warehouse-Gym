import 'package:camera/camera.dart';
import 'package:the_warehouse_gym/core/constants/app_colors.dart';
import 'package:the_warehouse_gym/core/providers/camera_providers.dart';
import 'package:the_warehouse_gym/core/router/app_router.dart';
import 'package:the_warehouse_gym/core/utils/toast_utils.dart';
import 'package:the_warehouse_gym/core/widgets/fitnessco_ui.dart';
import 'package:the_warehouse_gym/features/client/workout/presentation/camera_workout/viewmodels/camera_workout_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CameraWorkoutPage extends HookConsumerWidget {
  const CameraWorkoutPage({
    super.key,
    required this.exercises,
    this.description = '',
  });

  final Map<String, dynamic> exercises;
  final String description;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutState = ref.watch(cameraWorkoutProvider);
    final cameraState = ref.watch(cameraWorkoutCameraProvider);
    final workoutVm = ref.read(cameraWorkoutProvider.notifier);
    final cameraVm = ref.read(cameraWorkoutCameraProvider.notifier);
    final session = workoutState.session;

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        ref.read(cameraWorkoutProvider.notifier).loadSession(
              exercises: exercises,
              description: description,
            );
        ref.read(cameraWorkoutCameraProvider.notifier).initialize();
      });
      return null;
    }, [exercises, description]);

    useEffect(() {
      return () => releaseCameraWorkoutResources(ref);
    }, const []);

    ref.listen(cameraWorkoutProvider, (previous, next) {
      final failure = next.failureMessage;
      if (failure != null && failure.isNotEmpty) {
        if (failure.contains('No exercises') ||
            failure.contains('No history will be recorded')) {
          showInfoToast(failure);
          if (context.mounted) {
            releaseCameraWorkoutResources(ref);
            context.go(AppRouter.clientHome);
          }
        }
      }

      final nextSession = next.session;
      if (nextSession?.navigateHome == true && context.mounted) {
        releaseCameraWorkoutResources(ref);
        context.go(AppRouter.clientHome);
      }
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        releaseCameraWorkoutResources(ref);
        if (context.mounted) context.go(AppRouter.clientHome);
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('Pose Estimation'),
          actions: [
            IconButton(
              onPressed: cameraVm.switchCamera,
              icon: const Icon(Icons.cameraswitch),
            ),
          ],
        ),
        body: cameraState.permissionDenied
            ? _cameraErrorView(
                context,
                message: 'Camera permission is required for pose detection.',
                showRetry: true,
                onRetry: cameraVm.retryPermission,
                onGoHome: () {
                  releaseCameraWorkoutResources(ref);
                  context.go(AppRouter.clientHome);
                },
              )
            : cameraState.unavailable
                ? _cameraErrorView(
                    context,
                    message: 'No camera found on this device.',
                    onGoHome: () {
                      releaseCameraWorkoutResources(ref);
                      context.go(AppRouter.clientHome);
                    },
                  )
                : AuthLoadingStack(
            isLoading: workoutState.isLoading,
            children: [
              SimulationBackground(
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (workoutState.showsImagePhase && session != null)
                          _imageDisplayContainer(
                            session: session,
                            phase: workoutState.phase,
                            workoutVm: workoutVm,
                          )
                        else if (workoutState.showsWorkoutPhase &&
                            session != null)
                          _workoutContainer(
                            context: context,
                            session: session,
                            cameraState: cameraState,
                            cameraVm: cameraVm,
                            workoutVm: workoutVm,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
      ),
    );
  }

  Widget _cameraErrorView(
    BuildContext context, {
    required String message,
    bool showRetry = false,
    VoidCallback? onRetry,
    required VoidCallback onGoHome,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            fitnesscoText(message, textStyle: blackBoldStyle()),
            const SizedBox(height: 16),
            if (showRetry)
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            TextButton(
              onPressed: onGoHome,
              child: const Text('Go home'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageDisplayContainer({
    required CameraWorkoutSession session,
    required WorkoutStates? phase,
    required CameraWorkoutViewModel workoutVm,
  }) {
    final isIntro = phase == WorkoutStates.intro;
    final isReminder = phase == WorkoutStates.reminder;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: fitnesscoText(
            session.spokenMessage,
            textStyle: blackBoldStyle(size: isIntro ? 22 : 18),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          height: isIntro ? 280 : 500,
          width: isIntro ? double.infinity : 400,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(session.imageAssetPath),
              fit: BoxFit.contain,
            ),
          ),
        ),
        if (isIntro && session.workoutDisplayText.isNotEmpty) ...[
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 140,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      session.workoutDisplayText,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.4,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: workoutVm.startPoseWorkout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.purpleSnail,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: fitnesscoText(
                  'Start',
                  textStyle: whiteBoldStyle(size: 18),
                ),
              ),
            ),
          ),
        ],
        if (isReminder) ...[
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: workoutVm.continueFromReminder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.purpleSnail,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: fitnesscoText(
                  'Continue',
                  textStyle: whiteBoldStyle(size: 18),
                ),
              ),
            ),
          ),
        ],
        if (phase == WorkoutStates.rest) ...[
          const SizedBox(height: 12),
          fitnesscoText(
            session.spokenMessage,
            textStyle: blackBoldStyle(),
            textAlign: TextAlign.center,
          ),
          fitnesscoText(
            session.secondsRemaining > 0
                ? session.secondsRemaining.toString()
                : '',
            textStyle: blackBoldStyle(size: 75),
          ),
        ],
      ],
    );
  }

  Widget _workoutContainer({
    required BuildContext context,
    required CameraWorkoutSession session,
    required CameraWorkoutCameraState cameraState,
    required CameraWorkoutCameraNotifier cameraVm,
    required CameraWorkoutViewModel workoutVm,
  }) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 100,
          color: Colors.black.withValues(alpha: 0.75),
          child: Center(
            child: Text(
              cameraState.workoutInstruction,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        _liveFeedBody(context, cameraState, cameraVm),
        Padding(
          padding: const EdgeInsets.all(6),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.25,
            decoration: const BoxDecoration(color: AppColors.jigglypuff),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _onSkipWorkout(
                          context,
                          session: session,
                          workoutVm: workoutVm,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.purpleSnail,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: fitnesscoText(
                          'Skip Workout',
                          textStyle: whiteBoldStyle(size: 15),
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: workoutVm.addRepManually,
                        backgroundColor:
                            const Color.fromARGB(255, 55, 138, 185),
                        child: fitnesscoText('+', textStyle: whiteBoldStyle()),
                      ),
                      ElevatedButton(
                        onPressed: session.muscleGroups.length == 1
                            ? null
                            : () => _onSkipMuscle(
                                  context,
                                  workoutVm: workoutVm,
                                ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 73, 110, 175),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: fitnesscoText(
                          'Skip Muscle',
                          textStyle: whiteBoldStyle(size: 15),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        fitnesscoText(
                          '${session.currentRep} / ${session.repsQuota}',
                          textStyle: greyBoldStyle(size: 40),
                        ),
                        fitnesscoText(
                          'REPS',
                          textStyle: greyBoldStyle(size: 25),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        fitnesscoText(
                          '${session.currentSet} / ${session.setQuota}',
                          textStyle: greyBoldStyle(size: 40),
                        ),
                        fitnesscoText(
                          'SETS',
                          textStyle: greyBoldStyle(size: 25),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _liveFeedBody(
    BuildContext context,
    CameraWorkoutCameraState cameraState,
    CameraWorkoutCameraNotifier cameraVm,
  ) {
    if (appCameras.isEmpty) return Container();
    final controller = cameraVm.controller;
    if (controller == null || !cameraState.isInitialized) {
      return Container();
    }
    if (!controller.value.isInitialized) return Container();

    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height * 0.6,
      width: double.infinity,
      child: cameraState.changingLens
          ? const Center(child: Text('Changing camera lens'))
          : Padding(
              padding: const EdgeInsets.all(6),
              child: CameraPreview(
                controller,
                child: cameraState.customPaint,
              ),
            ),
    );
  }

  void _onSkipWorkout(
    BuildContext context, {
    required CameraWorkoutSession session,
    required CameraWorkoutViewModel workoutVm,
  }) {
    if (session.workouts.length == 1) {
      showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Confirm Skip Workout'),
          content: const Text(
            'Are you sure you want to skip this workout? This is the only workout prescribed for this muscle',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await workoutVm.skipWorkoutAfterConfirm();
              },
              child: const Text('Skip'),
            ),
          ],
        ),
      );
      return;
    }

    workoutVm.skipWorkout();
  }

  void _onSkipMuscle(
    BuildContext context, {
    required CameraWorkoutViewModel workoutVm,
  }) {
    if (!workoutVm.muscleHasRecordedProgress()) {
      showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Confirm Skip Workout'),
          content: const Text(
            'Are you sure you want to skip this muscle? You have not trained this muscle yet',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await workoutVm.skipMuscle();
              },
              child: const Text('Skip'),
            ),
          ],
        ),
      );
      return;
    }

    workoutVm.skipMuscle();
  }
}
