import 'package:the_warehouse_gym/core/router/app_router.dart';
import 'package:the_warehouse_gym/core/utils/toast_utils.dart';
import 'package:the_warehouse_gym/core/widgets/fitnessco_ui.dart';
import 'package:the_warehouse_gym/features/shared/auth/presentation/register/sign_up_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignUpPage extends HookConsumerWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstNameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();

    final state = ref.watch(signUpViewModelProvider);

    ref.listen<SignUpState>(signUpViewModelProvider, (previous, next) {
      if (next is Failed && previous is! Failed) {
        showFailureToast(next.failure);
      }
      if (next is Success) {
        showSuccessToast('Account created successfully!');
        context.go(AppRouter.completeProfile);
      }
    });

    void submit() {
      final firstName = firstNameController.text.trim();
      final lastName = lastNameController.text.trim();
      final email = emailController.text.trim();
      final password = passwordController.text;
      final confirmPassword = confirmPasswordController.text;

      if (firstName.isEmpty ||
          lastName.isEmpty ||
          email.isEmpty ||
          password.isEmpty ||
          confirmPassword.isEmpty) {
        showInfoToast('Please fill up all provided fields');
        return;
      }
      if (password != confirmPassword) {
        showInfoToast('Passwords do not match');
        return;
      }
      if (password.length < 8) {
        showInfoToast('Password must be at least 8 characters long');
        return;
      }

      ref.read(signUpViewModelProvider.notifier).signUp(
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
          );
    }

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: AuthLoadingStack(
            isLoading: state.isSubmitting,
            children: [
              RegisterAuthBackground(
                child: Center(
                  child: Stack(
                    alignment: Alignment.topCenter,
                    clipBehavior: Clip.none,
                    children: [
                      Padding(
                        // Leave room so the stacked logo overlaps the card top.
                        padding: const EdgeInsets.only(top: 45),
                        child: AuthRoundedCard(
                          heightFactor: 0.8,
                          child: Column(
                            children: [
                              // Clear the overlapping logo before the first field.
                              const SizedBox(height: 52),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: FitnesscoTextField(
                                  text: 'Enter First Name',
                                  controller: firstNameController,
                                  textInputType: TextInputType.name,
                                  displayPrefixIcon:
                                      const Icon(Icons.person_outline),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: FitnesscoTextField(
                                  text: 'Enter Last Name',
                                  controller: lastNameController,
                                  textInputType: TextInputType.name,
                                  displayPrefixIcon:
                                      const Icon(Icons.person_outline),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: FitnesscoTextField(
                                  text: 'Enter Email Address',
                                  controller: emailController,
                                  textInputType: TextInputType.emailAddress,
                                  displayPrefixIcon: const Icon(Icons.email),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: FitnesscoTextField(
                                  text: 'Password',
                                  controller: passwordController,
                                  textInputType:
                                      TextInputType.visiblePassword,
                                  displayPrefixIcon:
                                      const Icon(Icons.lock_outline),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: FitnesscoTextField(
                                  text: 'Confirm Password',
                                  controller: confirmPasswordController,
                                  textInputType:
                                      TextInputType.visiblePassword,
                                  displayPrefixIcon:
                                      const Icon(Icons.lock_outline),
                                ),
                              ),
                              const Spacer(),
                              AuthGradientButton(
                                label: 'REGISTER',
                                onTap: submit,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SignUpLogoHeader(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
