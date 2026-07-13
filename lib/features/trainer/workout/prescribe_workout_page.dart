import 'package:the_warehouse_gym/core/constants/app_colors.dart';
import 'package:the_warehouse_gym/core/providers/session_providers.dart';
import 'package:the_warehouse_gym/core/router/app_router.dart';
import 'package:the_warehouse_gym/core/utils/toast_utils.dart';
import 'package:the_warehouse_gym/core/widgets/fitnessco_ui.dart';
import 'package:the_warehouse_gym/core/widgets/loading_widget.dart';
import 'package:the_warehouse_gym/features/client/workout/domain/entities/workout_prescription.dart';
import 'package:the_warehouse_gym/features/client/workout/presentation/viewmodels/workout_viewmodel.dart';
import 'package:the_warehouse_gym/features/client/workout/presentation/widgets/workout_plan_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PrescribeWorkoutPage extends HookConsumerWidget {
  final String clientUid;
  final String? prescriptionId;
  final bool returnToSchedule;

  const PrescribeWorkoutPage({
    super.key,
    required this.clientUid,
    this.prescriptionId,
    this.returnToSchedule = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trainerUid = ref.watch(sessionUserProvider)?.uid ?? '';
    final viewModel = ref.read(workoutViewModelProvider.notifier);
    final workoutState = ref.watch(workoutViewModelProvider);
    final existingPrescription = useState<WorkoutPrescription?>(null);
    final isLoadingPrescription = useState(prescriptionId != null);

    final isEditing = prescriptionId != null;

    useEffect(() {
      if (prescriptionId == null) return null;
      Future(() async {
        final prescription =
            await viewModel.loadPrescriptionById(prescriptionId!);
        if (!context.mounted) return;
        if (prescription == null) {
          context.pop();
          return;
        }
        existingPrescription.value = prescription;
        isLoadingPrescription.value = false;
      });
      return null;
    }, [prescriptionId]);

    Future<void> onSubmit(WorkoutPrescription prescription) async {
      final success = await viewModel.prescribe(
        trainerUid,
        clientUid,
        prescription,
      );
      if (!success || !context.mounted) return;

      showSuccessToast(
        isEditing ? 'Workout updated successfully!' : 'Workout prescribed successfully!',
      );
      if (returnToSchedule) {
        context.go(AppRouter.trainerSchedule);
      } else {
        context.pop();
      }
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: FitnesscoScreenShell(
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.purpleSnail,
          title: Center(
            child: fitnesscoText(
              isEditing ? 'VIEW WORKOUT' : 'ADD WORKOUT',
              textStyle: whiteBoldStyle(size: 26),
            ),
          ),
        ),
        body: AuthLoadingStack(
          isLoading: workoutState.isSubmitting,
          children: [
            if (isLoadingPrescription.value)
              const WorkoutPlanBackground(child: LoadingWidget())
            else
              WorkoutPlanBackground(
                child: WorkoutPlanForm(
                  submitLabel: isEditing ? 'SAVE WORKOUT' : 'ADD WORKOUT',
                  subtitle: isEditing
                      ? 'Review or update the prescribed workout below.'
                      : 'Select workouts to prescribe below.',
                  initialPrescription: existingPrescription.value,
                  onSubmit: onSubmit,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
