import 'package:the_warehouse_gym/core/router/app_router.dart';
import 'package:gap/gap.dart';
import 'package:the_warehouse_gym/core/utils/toast_utils.dart';
import 'package:the_warehouse_gym/core/widgets/fitnessco_ui.dart';
import 'package:the_warehouse_gym/features/shared/auth/presentation/forgot_password/forgot_password_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ForgotPasswordPage extends HookConsumerWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final state = ref.watch(forgotPasswordViewModelProvider);

    ref.listen<ForgotPasswordState>(forgotPasswordViewModelProvider,
        (previous, next) {
      if (next is Failed && previous is! Failed) {
        showFailureToast(next.failure);
      }
      if (next is Success) {
        showSuccessToast('Password reset email sent.');
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(AppRouter.login);
        }
      }
    });

    void resetPassword() {
      final email = emailController.text.trim();
      if (email.isEmpty || !email.contains('@')) {
        showInfoToast('Please enter a valid email address');
        return;
      }
      ref.read(forgotPasswordViewModelProvider.notifier).forgotPassword(email);
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(AppRouter.login);
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
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
                          padding: const EdgeInsets.only(top: 45),
                          child: AuthRoundedCard(
                            heightFactor: 0.8,
                            child: Column(
                              children: [
                                const SizedBox(height: 52),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Column(
                                    children: [
                                      fitnesscoText(
                                        'RESET PASSWORD',
                                        textStyle: blackBoldStyle(),
                                      ),
                                      const Gap(30),
                                      fitnesscoFormTextField(
                                        'ENTER EMAIL',
                                        TextInputType.emailAddress,
                                        emailController,
                                        icon: Icons.email,
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                AuthGradientButton(
                                  label: 'RESET PASSWORD',
                                  onTap: resetPassword,
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
      ),
    );
  }
}
