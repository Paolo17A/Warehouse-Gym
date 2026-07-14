import 'package:the_warehouse_gym/core/di/injection.dart';
import 'package:the_warehouse_gym/core/router/app_router.dart';
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:the_warehouse_gym/core/constants/app_colors.dart';
import 'package:the_warehouse_gym/core/constants/sex_options.dart';
import 'package:the_warehouse_gym/core/providers/session_providers.dart';
import 'package:the_warehouse_gym/core/utils/toast_utils.dart';
import 'package:the_warehouse_gym/core/widgets/fitnessco_ui.dart';
import 'package:the_warehouse_gym/features/client/account/presentation/viewmodels/client_account_viewmodel.dart';
import 'package:the_warehouse_gym/features/client/bmi/domain/entities/bmi_entry.dart';
import 'package:the_warehouse_gym/features/client/bmi/domain/usecases/bmi_usecase.dart';
import 'package:the_warehouse_gym/features/client/bmi/domain/utils/bmi_calculator.dart';

class CompleteProfilePage extends HookConsumerWidget {
  const CompleteProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(clientAccountViewModelProvider);
    final viewModel = ref.read(clientAccountViewModelProvider.notifier);
    final currentUser = ref.watch(sessionUserProvider);
    final uid = currentUser?.uid ?? '';

    // Text controllers
    final firstNameCtrl = useTextEditingController();
    final lastNameCtrl = useTextEditingController();
    final ageCtrl = useTextEditingController();
    final heightCtrl = useTextEditingController();
    final weightCtrl = useTextEditingController();
    final workoutFreqCtrl = useTextEditingController();
    final sleepHoursCtrl = useTextEditingController();
    final illnessesCtrl = useTextEditingController();
    final allergiesCtrl = useTextEditingController();
    final injuriesCtrl = useTextEditingController();
    final medicationsCtrl = useTextEditingController();
    final steroidsCtrl = useTextEditingController();
    final foodDietCtrl = useTextEditingController();
    final bodyConcernsCtrl = useTextEditingController();
    final muscleGoalCtrl = useTextEditingController();
    final dedicationSpanCtrl = useTextEditingController();
    final specialPlansCtrl = useTextEditingController();

    // Dropdown / selection states
    final sex = useState<String?>(SexOptions.defaultValue);
    final workoutExperience = useState<String?>('Beginner');
    final workoutAvailability = useState<String?>('Morning');
    final recentlyDoctored = useState<bool>(false);

    useEffect(() {
      if (uid.isNotEmpty) {
        viewModel.loadProfile(uid);
      }
      return null;
    }, [uid]);

    Future<void> onSubmit() async {
      if (uid.isEmpty) {
        showInfoToast('Session expired. Please sign in again.');
        return;
      }

      final requiredFields = {
        'First Name': firstNameCtrl.text.trim(),
        'Last Name': lastNameCtrl.text.trim(),
        'Age': ageCtrl.text.trim(),
        'Height': heightCtrl.text.trim(),
        'Weight': weightCtrl.text.trim(),
        'Workout Days/Week': workoutFreqCtrl.text.trim(),
        'Sleep Hours/Day': sleepHoursCtrl.text.trim(),
      };
      for (final entry in requiredFields.entries) {
        if (entry.value.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${entry.key} is required')),
          );
          return;
        }
      }

      final data = {
        'firstName': firstNameCtrl.text.trim(),
        'lastName': lastNameCtrl.text.trim(),
        'accountInitialized': true,
        'profileDetails': {
          'firstName': firstNameCtrl.text.trim(),
          'lastName': lastNameCtrl.text.trim(),
          'age': ageCtrl.text.trim(),
          'sex': SexOptions.normalize(sex.value ?? SexOptions.defaultValue),
          'height': double.tryParse(heightCtrl.text.trim()) ?? 0.0,
          'weight': double.tryParse(weightCtrl.text.trim()) ?? 0.0,
          'workoutExperience': workoutExperience.value ?? 'Beginner',
          'workoutAvailability': workoutAvailability.value ?? 'Morning',
          'workoutFrequency': workoutFreqCtrl.text.trim(),
          'sleepHours': sleepHoursCtrl.text.trim(),
          'illnesses': illnessesCtrl.text.trim(),
          'allergies': allergiesCtrl.text.trim(),
          'injuries': injuriesCtrl.text.trim(),
          'medications': medicationsCtrl.text.trim(),
          'steroids': steroidsCtrl.text.trim(),
          'foodDiet': foodDietCtrl.text.trim(),
          'bodyConcerns': bodyConcernsCtrl.text.trim(),
          'muscleGoal': muscleGoalCtrl.text.trim(),
          'dedicationSpan': dedicationSpanCtrl.text.trim(),
          'specialPlans': specialPlansCtrl.text.trim(),
          'recentlyDoctored': recentlyDoctored.value ? 'true' : 'false',
        },
      };

      final success = await viewModel.updateProfile(uid, data);
      if (!success || !context.mounted) return;

      ref.read(sessionServiceProvider).markAccountInitialized();

      final height = double.tryParse(heightCtrl.text.trim()) ?? 0.0;
      final weight = double.tryParse(weightCtrl.text.trim()) ?? 0.0;
      if (height > 0 && weight > 0) {
        final bmi = BmiCalculator.fromMetric(
          heightCm: height,
          weightKg: weight,
        );
        await sl<BmiUseCase>().addBmiEntry(
          uid,
          BmiEntry(dateTime: DateTime.now(), bmiValue: bmi),
          heightCm: height,
          weightKg: weight,
        );
      }

      if (context.mounted) {
        context.go(AppRouter.profileCompleted);
      }
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: FitnesscoScreenShell(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Center(
            child: fitnesscoText(
              'Complete Your Profile',
              textStyle: whiteBoldStyle(size: 25),
            ),
          ),
        ),
        body: AuthLoadingStack(
          isLoading: state.isSubmitting,
          children: [
            RegisterAuthBackground(
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      fitnesscoText(
                        'PLEASE COMPLETE YOUR PROFILE',
                        textStyle: blackBoldStyle(size: 21),
                      ),
                      const Gap(8),
                      fitnesscoText(
                        'Tell us about yourself',
                        textStyle: whiteBoldStyle(size: 16),
                      ),
                      const Gap(20),
                      roundedContainer(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _sectionHeader('Personal Information'),
                              const Gap(12),
                              Row(
                                children: [
                                  Expanded(
                                    child: fitnesscoFormTextField(
                                      'First Name',
                                      TextInputType.text,
                                      firstNameCtrl,
                                    ),
                                  ),
                                  const Gap(12),
                                  Expanded(
                                    child: fitnesscoFormTextField(
                                      'Last Name',
                                      TextInputType.text,
                                      lastNameCtrl,
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(12),
                              Row(
                                children: [
                                  Expanded(
                                    child: fitnesscoFormTextField(
                                      'Age',
                                      TextInputType.number,
                                      ageCtrl,
                                    ),
                                  ),
                                  const Gap(12),
                                  Expanded(
                                    child: _buildDropdown<String>(
                                      label: 'Sex',
                                      value: sex.value,
                                      items: SexOptions.options,
                                      onChanged: (v) => sex.value = v,
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(12),
                              Row(
                                children: [
                                  Expanded(
                                    child: fitnesscoFormTextField(
                                      'Height (cm)',
                                      TextInputType.number,
                                      heightCtrl,
                                    ),
                                  ),
                                  const Gap(12),
                                  Expanded(
                                    child: fitnesscoFormTextField(
                                      'Weight (kg)',
                                      TextInputType.number,
                                      weightCtrl,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(16),
                      roundedContainer(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _sectionHeader('Workout Information'),
                              const Gap(12),
                              _buildDropdown<String>(
                                label: 'Workout Experience',
                                value: workoutExperience.value,
                                items: const [
                                  'Beginner',
                                  'Intermediate',
                                  'Advanced',
                                ],
                                onChanged: (v) => workoutExperience.value = v,
                              ),
                              const Gap(12),
                              _buildDropdown<String>(
                                label: 'Workout Availability',
                                value: workoutAvailability.value,
                                items: const [
                                  'Morning',
                                  'Afternoon',
                                  'Evening',
                                  'Flexible',
                                ],
                                onChanged: (v) => workoutAvailability.value = v,
                              ),
                              const Gap(12),
                              Row(
                                children: [
                                  Expanded(
                                    child: fitnesscoFormTextField(
                                      'Workout Days/Week',
                                      TextInputType.number,
                                      workoutFreqCtrl,
                                    ),
                                  ),
                                  const Gap(12),
                                  Expanded(
                                    child: fitnesscoFormTextField(
                                      'Sleep Hours/Day',
                                      TextInputType.number,
                                      sleepHoursCtrl,
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(12),
                              fitnesscoFormTextField(
                                'Muscle Goal',
                                TextInputType.text,
                                muscleGoalCtrl,
                              ),
                              const Gap(12),
                              fitnesscoFormTextField(
                                'Body Concerns',
                                TextInputType.text,
                                bodyConcernsCtrl,
                              ),
                              const Gap(12),
                              fitnesscoFormTextField(
                                'Dedication Span',
                                TextInputType.text,
                                dedicationSpanCtrl,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(16),
                      roundedContainer(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _sectionHeader('Health Information'),
                              const Gap(12),
                              fitnesscoFormTextField(
                                'Illnesses (if any)',
                                TextInputType.text,
                                illnessesCtrl,
                              ),
                              const Gap(12),
                              fitnesscoFormTextField(
                                'Allergies (if any)',
                                TextInputType.text,
                                allergiesCtrl,
                              ),
                              const Gap(12),
                              fitnesscoFormTextField(
                                'Injuries (if any)',
                                TextInputType.text,
                                injuriesCtrl,
                              ),
                              const Gap(12),
                              fitnesscoFormTextField(
                                'Medications (if any)',
                                TextInputType.text,
                                medicationsCtrl,
                              ),
                              const Gap(12),
                              fitnesscoFormTextField(
                                'Steroids (if any)',
                                TextInputType.text,
                                steroidsCtrl,
                              ),
                              const Gap(12),
                              fitnesscoFormTextField(
                                'Food Diet',
                                TextInputType.text,
                                foodDietCtrl,
                              ),
                              const Gap(12),
                              fitnesscoFormTextField(
                                'Special Plans',
                                TextInputType.text,
                                specialPlansCtrl,
                              ),
                              const Gap(12),
                              SwitchListTile(
                                title: fitnesscoText(
                                  'Recently seen a doctor?',
                                  textStyle: blackBoldStyle(size: 14),
                                ),
                                value: recentlyDoctored.value,
                                onChanged: (v) => recentlyDoctored.value = v,
                                activeThumbColor: AppColors.purpleSnail,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(32),
                      AuthGradientButton(
                        label: 'Complete Profile',
                        width: 250,
                        onTap: state.isSubmitting ? () {} : onSubmit,
                      ),
                      const Gap(24),
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

  Widget _sectionHeader(String title) {
    return fitnesscoText(
      title,
      textStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.purpleSnail,
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required void Function(T?) onChanged,
  }) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.purpleSnail),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(width: 1, color: AppColors.nearMoon),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      ),
      items: items
          .map((e) => DropdownMenuItem<T>(value: e, child: Text('$e')))
          .toList(),
      onChanged: onChanged,
    );
  }
}
