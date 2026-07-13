import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:the_warehouse_gym/core/constants/app_colors.dart';
import 'package:the_warehouse_gym/core/utils/toast_utils.dart';
import 'package:the_warehouse_gym/core/widgets/fitnessco_ui.dart';
import 'package:the_warehouse_gym/features/client/workout/domain/entities/exercise_prescription.dart';
import 'package:the_warehouse_gym/features/client/workout/domain/entities/workout_prescription.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class WorkoutPlanForm extends HookWidget {
  final String submitLabel;
  final String subtitle;
  final Future<void> Function(WorkoutPrescription prescription) onSubmit;
  final WorkoutPrescription? initialPrescription;

  const WorkoutPlanForm({
    super.key,
    required this.submitLabel,
    required this.subtitle,
    required this.onSubmit,
    this.initialPrescription,
  });

  @override
  Widget build(BuildContext context) {
    final descriptionController = useTextEditingController(
      text: initialPrescription?.description ?? '',
    );
    final selectedDate = useState<DateTime>(
      initialPrescription?.workoutDate ?? DateTime.now(),
    );
    final musclesMap = useState<Map<String, List<String>>>({});
    final muscles = useState<List<String>>([]);
    final selectedMuscle = useState<String?>(null);
    final selectedExercise = useState<String?>(null);
    final setsController = useTextEditingController(text: '3');
    final repsController = useTextEditingController(text: '10');
    final exerciseEntries = useState<List<Map<String, dynamic>>>([]);
    final initialized = useState(initialPrescription == null);

    useEffect(() {
      Future(() async {
        final jsonStr =
            await rootBundle.loadString('lib/core/seeds/muscles.json');
        final decoded = json.decode(jsonStr) as Map<String, dynamic>;
        final map = decoded.map(
          (key, value) => MapEntry(key, List<String>.from(value as List)),
        );
        musclesMap.value = map;
        muscles.value = map.keys.toList();

        final initial = initialPrescription;
        if (initial != null) {
          exerciseEntries.value = initial.exercises.entries
              .expand(
                (muscleEntry) => muscleEntry.value.map(
                  (exercise) => {
                    'muscle': muscleEntry.key,
                    'exerciseName': exercise.exerciseName,
                    'sets': exercise.sets,
                    'reps': exercise.reps,
                  },
                ),
              )
              .toList();
        }
        initialized.value = true;
      });
      return null;
    }, const []);

    Future<void> pickDate() async {
      final picked = await showDatePicker(
        context: context,
        initialDate: selectedDate.value,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      );
      if (picked != null) selectedDate.value = picked;
    }

    void addExercise() {
      final muscle = selectedMuscle.value;
      final exercise = selectedExercise.value;
      final sets = int.tryParse(setsController.text) ?? 0;
      final reps = int.tryParse(repsController.text) ?? 0;

      if (muscle == null || exercise == null || sets <= 0 || reps <= 0) {
        showInfoToast('Please complete all exercise fields.');
        return;
      }

      exerciseEntries.value = [
        ...exerciseEntries.value,
        {
          'muscle': muscle,
          'exerciseName': exercise,
          'sets': sets,
          'reps': reps,
        },
      ];
      selectedMuscle.value = null;
      selectedExercise.value = null;
      setsController.text = '3';
      repsController.text = '10';
    }

    Future<void> submit() async {
      if (descriptionController.text.trim().isEmpty) {
        showInfoToast('Please enter a description.');
        return;
      }
      if (exerciseEntries.value.isEmpty) {
        showInfoToast('Please add at least one exercise.');
        return;
      }

      final groupedExercises = <String, List<ExercisePrescription>>{};
      for (final entry in exerciseEntries.value) {
        final muscle = entry['muscle'] as String;
        groupedExercises.putIfAbsent(muscle, () => []).add(
              ExercisePrescription(
                exerciseName: entry['exerciseName'] as String,
                muscle: muscle,
                sets: entry['sets'] as int,
                reps: entry['reps'] as int,
              ),
            );
      }

      final prescription = WorkoutPrescription(
        id: initialPrescription?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        trainerId: initialPrescription?.trainerId,
        description: descriptionController.text.trim(),
        workoutDate: selectedDate.value,
        exercises: groupedExercises,
      );

      await onSubmit(prescription);
    }

    if (!initialized.value) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 12),
            child: Column(
              children: [
                Row(
                  children: [
                    fitnesscoText(
                      DateFormat('dd MMM yyyy').format(selectedDate.value),
                      textStyle: blackBoldStyle(),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: pickDate,
                      child: fitnesscoText('Change Date'),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: fitnesscoFormTextField(
                    'WORKOUT DESCRIPTION',
                    TextInputType.text,
                    descriptionController,
                  ),
                ),
                fitnesscoText(subtitle),
              ],
            ),
          ),
          DropdownSearch<String>(
            items: (filter, _) => muscles.value
                .where(
                  (m) => m.toLowerCase().contains(filter.toLowerCase()),
                )
                .toList(),
            selectedItem: selectedMuscle.value,
            decoratorProps: const DropDownDecoratorProps(
              decoration: InputDecoration(
                labelText: 'Muscle Group',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
            popupProps: const PopupProps.menu(showSearchBox: true),
            onSelected: (val) {
              selectedMuscle.value = val;
              selectedExercise.value = null;
            },
          ),
          const Gap(12),
          DropdownSearch<String>(
            key: ValueKey(selectedMuscle.value),
            items: (filter, _) =>
                (musclesMap.value[selectedMuscle.value] ?? [])
                    .where(
                      (e) => e.toLowerCase().contains(filter.toLowerCase()),
                    )
                    .toList(),
            selectedItem: selectedExercise.value,
            decoratorProps: const DropDownDecoratorProps(
              decoration: InputDecoration(
                labelText: 'Exercise',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
            popupProps: const PopupProps.menu(showSearchBox: true),
            onSelected: (val) => selectedExercise.value = val,
            enabled: selectedMuscle.value != null,
          ),
          const Gap(12),
          Row(
            children: [
              Expanded(
                child: fitnesscoFormTextField(
                  'Sets',
                  TextInputType.number,
                  setsController,
                ),
              ),
              const Gap(12),
              Expanded(
                child: fitnesscoFormTextField(
                  'Reps',
                  TextInputType.number,
                  repsController,
                ),
              ),
            ],
          ),
          const Gap(12),
          OutlinedButton.icon(
            onPressed: addExercise,
            icon: const Icon(Icons.add),
            label: fitnesscoText('Add Exercise'),
          ),
          if (exerciseEntries.value.isNotEmpty) ...[
            const Gap(16),
            ...exerciseEntries.value.asMap().entries.map((entry) {
              final e = entry.value;
              return Padding(
                padding: const EdgeInsets.all(5),
                child: Container(
                  height: 80,
                  color: AppColors.love,
                  child: ListTile(
                    title: fitnesscoText(e['exerciseName'] as String),
                    subtitle: fitnesscoText(
                      '${e['muscle']} — ${e['sets']} sets × ${e['reps']} reps',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        final updated = List<Map<String, dynamic>>.from(
                          exerciseEntries.value,
                        );
                        updated.removeAt(entry.key);
                        exerciseEntries.value = updated;
                      },
                    ),
                  ),
                ),
              );
            }),
          ],
          const Gap(12),
          AuthGradientButton(
            label: submitLabel,
            width: 200,
            onTap: submit,
          ),
        ],
      ),
    );
  }
}
