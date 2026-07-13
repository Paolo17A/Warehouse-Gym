import 'package:the_warehouse_gym/core/utils/toast_utils.dart';
import 'package:the_warehouse_gym/core/widgets/fitnessco_ui.dart';
import 'package:the_warehouse_gym/features/admin/users/presentation/add_trainer/viewmodels/add_trainer_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddTrainerPage extends HookConsumerWidget {
  const AddTrainerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addTrainerViewModelProvider);
    final viewModel = ref.read(addTrainerViewModelProvider.notifier);

    final firstNameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final idNumberController = useTextEditingController();

    ref.listen(addTrainerViewModelProvider, (_, next) {
      if (next is Failure) {
        showErrorToast(next.message);
        viewModel.reset();
      } else if (next is Success) {
        showSuccessToast('Trainer added successfully');
        Navigator.of(context).pop();
      }
    });

    Future<void> submit() async {
      final firstName = firstNameController.text.trim();
      final lastName = lastNameController.text.trim();
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final idNumber = idNumberController.text.trim();

      if (firstName.isEmpty ||
          lastName.isEmpty ||
          email.isEmpty ||
          password.isEmpty ||
          idNumber.isEmpty) {
        showInfoToast('Please fill up all provided fields');
        return;
      }
      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
        showInfoToast('Enter a valid email address');
        return;
      }
      if (password.length < 6) {
        showInfoToast('Password must be at least 6 characters');
        return;
      }

      await viewModel.addTrainer(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        idNumber: idNumber,
      );
    }

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: AuthLoadingStack(
            isLoading: state is Loading,
            children: [
              RegisterAuthBackground(
                child: Stack(
                  children: [
                    Center(
                      child: AuthRoundedCard(
                        heightFactor: 0.85,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Gap(40),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: fitnesscoFormTextField(
                                  'Enter ID Number',
                                  TextInputType.number,
                                  idNumberController,
                                  icon: Icons.person_outline,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: fitnesscoFormTextField(
                                  'Enter First Name',
                                  TextInputType.name,
                                  firstNameController,
                                  icon: Icons.person_outline,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: fitnesscoFormTextField(
                                  'Enter Last Name',
                                  TextInputType.name,
                                  lastNameController,
                                  icon: Icons.person_outline,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: fitnesscoFormTextField(
                                  'Enter Email Address',
                                  TextInputType.emailAddress,
                                  emailController,
                                  icon: Icons.email,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: fitnesscoFormTextField(
                                  'Password',
                                  TextInputType.visiblePassword,
                                  passwordController,
                                  icon: Icons.lock_outline,
                                ),
                              ),
                              const Gap(40),
                              AuthGradientButton(
                                label: 'ADD NEW TRAINER',
                                onTap: state is Loading ? () {} : submit,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.topCenter,
                      child: SignUpLogoHeader(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
