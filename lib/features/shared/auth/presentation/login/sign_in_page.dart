import 'package:the_warehouse_gym/core/router/app_router.dart';
import 'package:gap/gap.dart';
import 'package:the_warehouse_gym/core/utils/toast_utils.dart';
import 'package:the_warehouse_gym/core/widgets/fitnessco_ui.dart';
import 'package:the_warehouse_gym/features/shared/auth/presentation/login/sign_in_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignInPage extends HookConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final state = ref.watch(signInViewModelProvider);

    ref.listen<SignInState>(signInViewModelProvider, (previous, next) {
      if (next is Failed && previous is! Failed) {
        showFailureToast(next.failure);
      }
      if (next is Authenticated &&
          previous is! Authenticated) {
        context.go(next.redirectPath);
        ref.read(signInViewModelProvider.notifier).clearRedirect();
      }
    });

    void signIn() {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        showInfoToast('Please fill up all provided fields');
        return;
      }

      ref.read(signInViewModelProvider.notifier).signIn(
            emailController.text.trim(),
            passwordController.text,
          );
    }

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: AuthLoadingStack(
          isLoading: state.isSubmitting,
          children: [
            SafeArea(
              child: LoadingAuthBackground(
                child: Column(
                  children: [
                    const SignInLogoHeader(),
                    AuthRoundedCard(
                      child: Column(
                        children: [
                          FitnesscoTextField(
                            text: 'Enter   Email Address',
                            controller: emailController,
                            textInputType: TextInputType.emailAddress,
                            displayPrefixIcon: const Icon(Icons.email_outlined),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: FitnesscoTextField(
                              text: 'Enter Password',
                              controller: passwordController,
                              textInputType: TextInputType.visiblePassword,
                              displayPrefixIcon: const Icon(Icons.lock_outline),
                            ),
                          ),
                          const Gap(10),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: AuthGradientButton(
                              label: 'LOG-IN',
                              onTap: signIn,
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                context.go(AppRouter.forgotPassword),
                            child: Text(
                              'Forgot your password? ',
                              style: authBoldTextStyle(),
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.go(AppRouter.register),
                            child: Text(
                              "Don't have an account? ",
                              style: authBoldTextStyle(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
