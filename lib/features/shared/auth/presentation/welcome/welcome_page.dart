import 'package:the_warehouse_gym/core/router/app_router.dart';
import 'package:gap/gap.dart';
import 'package:the_warehouse_gym/core/widgets/fitnessco_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WelcomePage extends HookConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/backgrounds/loading.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/fitnessco_logo.png'),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: fitnesscoText(
                          'WELCOME',
                          textStyle: blackBoldStyle(size: 24),
                        ),
                      ),
                      AuthGradientButton(
                        label: 'Create Your Account',
                        width: 250,
                        height: 70,
                        onTap: () => context.go(AppRouter.register),
                      ),
                      const Gap(50),
                      fitnesscoText(
                        'Already have an account?',
                        textStyle: blackBoldStyle(size: 18),
                      ),
                      TextButton(
                        onPressed: () => context.go(AppRouter.login),
                        child: const Text('Sign in Here'),
                      ),
                      const Gap(15),
                    ],
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
