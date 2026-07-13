import 'package:the_warehouse_gym/core/providers/session_providers.dart';
import 'package:the_warehouse_gym/core/utils/toast_utils.dart';
import 'package:the_warehouse_gym/core/widgets/fitnessco_ui.dart';
import 'package:the_warehouse_gym/features/client/workout/presentation/viewmodels/workout_viewmodel.dart';
import 'package:the_warehouse_gym/features/client/workout/presentation/widgets/workout_plan_form.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CreateWorkoutPlanPage extends ConsumerWidget {
  const CreateWorkoutPlanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientUid = ref.watch(sessionUserProvider)?.uid ?? '';
    final viewModel = ref.read(workoutViewModelProvider.notifier);
    final workoutState = ref.watch(workoutViewModelProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: FitnesscoScreenShell(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Center(
            child: fitnesscoText(
              'CREATE PLAN',
              textStyle: whiteBoldStyle(size: 26),
            ),
          ),
        ),
        body: AuthLoadingStack(
          isLoading: workoutState.isSubmitting,
          children: [
            WorkoutPlanBackground(
              child: WorkoutPlanForm(
                submitLabel: 'SAVE PLAN',
                subtitle: 'Build your own workout plan below.',
                onSubmit: (prescription) async {
                  final success = await viewModel.createOwnWorkoutPlan(
                    clientUid,
                    prescription,
                  );
                  if (success && context.mounted) {
                    showSuccessToast('Workout plan created!');
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
