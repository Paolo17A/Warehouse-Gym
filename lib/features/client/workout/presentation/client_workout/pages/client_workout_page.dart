import 'package:the_warehouse_gym/core/constants/app_colors.dart';
import 'package:the_warehouse_gym/core/errors/failures.dart';
import 'package:the_warehouse_gym/core/providers/session_providers.dart';
import 'package:the_warehouse_gym/core/router/app_router.dart';
import 'package:the_warehouse_gym/core/widgets/fitnessco_ui.dart';
import 'package:the_warehouse_gym/core/widgets/no_internet_widget.dart';
import 'package:the_warehouse_gym/features/client/workout/domain/entities/workout_prescription.dart';
import 'package:the_warehouse_gym/features/client/workout/presentation/viewmodels/workout_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class ClientWorkoutPage extends HookConsumerWidget {
  const ClientWorkoutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(sessionUserProvider)?.uid ?? '';
    final workoutState = ref.watch(workoutViewModelProvider);
    final viewModel = ref.read(workoutViewModelProvider.notifier);

    useEffect(() {
      if (uid.isEmpty) return null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.loadPrescriptions(uid);
      });
      return null;
    }, [uid]);

    if (workoutState.failure is NetworkFailure) {
      return FitnesscoScreenShell(
        appBar: largeGradientAppBar('My Workout Plan'),
        body: NoInternetWidget(
          onRetry: () => viewModel.loadPrescriptions(uid),
        ),
      );
    }

    return FitnesscoScreenShell(
      appBar: largeGradientAppBar(
        'My Workout Plan',
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Create plan',
            onPressed: () => context.push(AppRouter.createWorkoutPlan),
          ),
        ],
      ),
      body: SwitchedLoadingContainer(
        isLoading: workoutState.isLoading,
        child: ViewTrainerBackground(
          child: SafeArea(
            child: workoutState.prescriptions.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          fitnesscoText(
                            'No workout plans yet',
                            textStyle: blackBoldStyle(size: 28),
                          ),
                          const Gap(12),
                          fitnesscoText(
                            'Create your own plan or wait for your trainer to prescribe one.',
                            textAlign: TextAlign.center,
                          ),
                          const Gap(24),
                          AuthGradientButton(
                            label: 'CREATE PLAN',
                            width: 220,
                            onTap: () =>
                                context.push(AppRouter.createWorkoutPlan),
                          ),
                        ],
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () => viewModel.refresh(uid),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: workoutState.prescriptions.length,
                      itemBuilder: (context, index) {
                        final prescription = workoutState.prescriptions[index];
                        return _PrescriptionCard(
                          prescription: prescription,
                          onDelete: prescription.isSelfCreated
                              ? () => viewModel.removePrescription(
                                    clientId: uid,
                                    prescriptionId: prescription.id,
                                    requesterId: uid,
                                  )
                              : null,
                        );
                      },
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _PrescriptionCard extends StatelessWidget {
  final WorkoutPrescription prescription;
  final VoidCallback? onDelete;

  const _PrescriptionCard({
    required this.prescription,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('dd MMM yyyy').format(prescription.workoutDate);
    final sourceLabel =
        prescription.isSelfCreated ? 'Your plan' : 'From trainer';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _overflowText(
                        prescription.description.isEmpty
                            ? formattedDate
                            : prescription.description,
                        textStyle: blackBoldStyle(size: 18),
                        maxLines: 2,
                      ),
                      const Gap(4),
                      _overflowText(
                        sourceLabel,
                        maxLines: 1,
                        textStyle: const TextStyle(
                          color: AppColors.purpleSnail,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: onDelete,
                    tooltip: 'Delete plan',
                  ),
              ],
            ),
          ),
          ...prescription.exercises.entries.expand((muscleEntry) {
            return muscleEntry.value.map((exercise) {
              return Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 100),
                  color: AppColors.love,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 75,
                          width: 75,
                          child: ColoredBox(
                            color: Colors.white,
                            child: Image.asset(
                              'assets/images/gifs/${exercise.exerciseName}.gif',
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.fitness_center,
                                color: AppColors.purpleSnail,
                              ),
                            ),
                          ),
                        ),
                        const Gap(8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _overflowText(
                                exercise.exerciseName,
                                textStyle: blackBoldStyle(),
                                maxLines: 2,
                              ),
                              _overflowText(
                                'Reps: ${exercise.reps}',
                                maxLines: 1,
                                textStyle: const TextStyle(
                                  color: AppColors.purpleSnail,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              _overflowText(
                                'Sets: ${exercise.sets}',
                                maxLines: 1,
                                textStyle: const TextStyle(
                                  color: AppColors.purpleSnail,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
          }),
        ],
      ),
    );
  }
}

Widget _overflowText(
  String label, {
  TextStyle? textStyle,
  int maxLines = 2,
}) {
  return Text(
    label,
    textAlign: TextAlign.start,
    maxLines: maxLines,
    overflow: TextOverflow.ellipsis,
    style: textStyle ?? blackBoldStyle(),
  );
}
