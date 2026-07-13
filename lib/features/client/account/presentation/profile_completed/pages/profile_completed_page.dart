import 'package:the_warehouse_gym/core/router/app_router.dart';
import 'package:the_warehouse_gym/core/widgets/fitnessco_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileCompletedPage extends HookConsumerWidget {
  const ProfileCompletedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: RegisterAuthBackground(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: roundedContainer(
                  height: MediaQuery.of(context).size.height * 0.75,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage(
                              'assets/images/icons/success_icon.png',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: fitnesscoText(
                            'THANK YOU FOR COMPLETING YOUR PROFILE. YOU CAN NOW VISIT YOUR DASHBOARD',
                            textStyle: blackBoldStyle(size: 30),
                          ),
                        ),
                        AuthGradientButton(
                          label: 'CONTINUE',
                          onTap: () => context.go(AppRouter.clientHome),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
