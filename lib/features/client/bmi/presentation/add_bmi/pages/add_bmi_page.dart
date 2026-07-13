import 'package:the_warehouse_gym/core/constants/app_colors.dart';
import 'package:gap/gap.dart';
import 'package:the_warehouse_gym/core/providers/session_providers.dart';
import 'package:the_warehouse_gym/core/utils/toast_utils.dart';
import 'package:the_warehouse_gym/core/widgets/fitnessco_ui.dart';
import 'package:the_warehouse_gym/features/client/account/presentation/viewmodels/client_account_viewmodel.dart';
import 'package:the_warehouse_gym/features/client/bmi/domain/utils/bmi_calculator.dart';
import 'package:the_warehouse_gym/features/client/bmi/presentation/viewmodels/bmi_viewmodel.dart';
import 'package:the_warehouse_gym/features/client/home/presentation/viewmodels/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddBmiPage extends HookConsumerWidget {
  const AddBmiPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(sessionUserProvider)?.uid ?? '';
    final viewModel = ref.read(bmiViewModelProvider.notifier);
    final accountState = ref.watch(clientAccountViewModelProvider);
    final bmiState = ref.watch(bmiViewModelProvider);

    final weightController = useTextEditingController();
    final heightController = useTextEditingController();
    final calculatedBmi = useState<double?>(null);
    final initialized = useState(false);

    useEffect(() {
      if (uid.isEmpty) return null;
      Future(() async {
        final accountVm = ref.read(clientAccountViewModelProvider.notifier);
        if (accountState.user == null) {
          await accountVm.loadProfile(uid);
        }
        final profile = ref.read(clientAccountViewModelProvider).user?.clientProfile;
        if (profile != null) {
          if (heightController.text.isEmpty && profile.height > 0) {
            heightController.text = profile.height.toString();
          }
          if (weightController.text.isEmpty && profile.weight > 0) {
            weightController.text = profile.weight.toString();
          }
        }
        initialized.value = true;
      });
      return null;
    }, [uid]);

    void calculateBmi() {
      final weight = double.tryParse(weightController.text);
      final height = double.tryParse(heightController.text);

      if (weight == null || height == null || height <= 0 || weight <= 0) {
        calculatedBmi.value = null;
        return;
      }

      calculatedBmi.value = BmiCalculator.fromMetric(
        heightCm: height,
        weightKg: weight,
      );
    }

    Future<void> submit() async {
      final bmi = calculatedBmi.value;
      final weight = double.tryParse(weightController.text);
      final height = double.tryParse(heightController.text);
      if (bmi == null || weight == null || height == null) {
        showInfoToast('Please enter valid weight and height first.');
        return;
      }

      final success = await viewModel.addEntry(
        uid,
        bmi,
        heightCm: height,
        weightKg: weight,
      );
      if (!success || !context.mounted) return;

      await ref.read(clientAccountViewModelProvider.notifier).refresh(uid);
      await ref.read(homeViewModelProvider.notifier).refresh(uid);
      if (!context.mounted) return;
      showSuccessToast('BMI recorded successfully!');
      context.pop();
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: FitnesscoScreenShell(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Center(
            child: fitnesscoText(
              'Update BMI',
              textStyle: whiteBoldStyle(size: 30),
            ),
          ),
        ),
        body: AuthLoadingStack(
          isLoading: bmiState.isSubmitting || !initialized.value,
          children: [
            RegisterAuthBackground(
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      fitnesscoText(
                        'Enter your measurements',
                        textStyle: blackBoldStyle(size: 16),
                      ),
                      const Gap(20),
                      fitnesscoFormTextField(
                        'Weight (kg)',
                        const TextInputType.numberWithOptions(decimal: true),
                        weightController,
                      ),
                      const Gap(16),
                      fitnesscoFormTextField(
                        'Height (cm)',
                        const TextInputType.numberWithOptions(decimal: true),
                        heightController,
                      ),
                      const Gap(16),
                      ElevatedButton(
                        onPressed: calculateBmi,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.nearMoon,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: fitnesscoText(
                          'COMPUTE',
                          textStyle: whiteBoldStyle(size: 14),
                        ),
                      ),
                      const Gap(32),
                      if (calculatedBmi.value != null) ...[
                        Center(
                          child: fitnesscoText(
                            calculatedBmi.value!.toStringAsFixed(2),
                            textStyle: blackBoldStyle(size: 50),
                          ),
                        ),
                        const Gap(8),
                        Center(
                          child: fitnesscoText(
                            'BMI = weight (kg) / height² (m²)',
                            textStyle: greyBoldStyle(size: 12),
                          ),
                        ),
                        const Gap(24),
                        AuthGradientButton(
                          label: 'Save BMI Entry',
                          width: 250,
                          onTap: submit,
                        ),
                      ],
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
}
