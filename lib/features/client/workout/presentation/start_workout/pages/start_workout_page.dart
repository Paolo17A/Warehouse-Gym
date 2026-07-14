import 'package:carousel_slider/carousel_slider.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_warehouse_gym/core/constants/app_colors.dart';
import 'package:the_warehouse_gym/core/utils/toast_utils.dart';
import 'package:the_warehouse_gym/core/widgets/fitnessco_ui.dart';
import 'package:the_warehouse_gym/features/client/workout/presentation/camera_workout/utils/workout_navigation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class StartWorkoutPage extends HookConsumerWidget {
  final Map<String, dynamic> exercises;
  final String description;

  const StartWorkoutPage({
    super.key,
    required this.exercises,
    this.description = '',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workouts = <String>[];
    for (final muscle in exercises.keys) {
      final muscleMap = exercises[muscle] as Map<dynamic, dynamic>? ?? {};
      for (final entry in muscleMap.entries) {
        workouts.add(entry.key.toString());
      }
    }

    final sessionExtra = {
      'exercises': exercises,
      'description': description,
    };

    Future<void> onSkipWarmUp() async {
      if (workouts.isEmpty) {
        showInfoToast('No exercises in today\'s plan.');
        return;
      }
      final confirmed = await confirmSkipWarmUp(context);
      if (confirmed && context.mounted) {
        navigateToCameraWorkout(context, sessionExtra);
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: StartWorkoutBackground(
        child: Column(
          children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(40),
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.bananaMilk,
                      AppColors.jigglypuff,
                    ],
                  ),
                ),
                child: Center(
                  child: fitnesscoText(
                    DateFormat('dd MMM yyyy').format(DateTime.now()),
                    textStyle: blackBoldStyle(size: 36),
                  ),
                ),
              ),
            ),
            if (workouts.isNotEmpty)
              roundedContainer(
                height: 200,
                color: const Color.fromARGB(255, 209, 209, 209),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: CarouselSlider.builder(
                    itemCount: workouts.length,
                    itemBuilder: (context, index, _) {
                      return roundedContainer(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width * 0.42,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 40,
                                width: double.infinity,
                                child: Text(
                                  workouts[index],
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.nunitoSans(
                                    textStyle: blackBoldStyle(size: 13),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Expanded(
                                child: Image.asset(
                                  'assets/images/gifs/${workouts[index]}.gif',
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.fitness_center),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      height: 180,
                      viewportFraction: 0.55,
                      enableInfiniteScroll: false,
                    ),
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(24),
                child: fitnesscoText(
                  'No exercises in today\'s plan.',
                  textStyle: greyBoldStyle(size: 16),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: workouts.isEmpty
                    ? null
                    : () => navigateToWarmUp(context, sessionExtra),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.plasmaTrail,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: fitnesscoText(
                    'Start Workout',
                    textStyle: whiteBoldStyle(),
                  ),
                ),
              ),
            ),
            if (workouts.isNotEmpty)
              TextButton(
                onPressed: onSkipWarmUp,
                child: Text(
                  'Skip warm-up',
                  style: GoogleFonts.nunitoSans(
                    textStyle: whiteBoldStyle(size: 16).copyWith(
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                    ),
                  ),
                ),
              ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
