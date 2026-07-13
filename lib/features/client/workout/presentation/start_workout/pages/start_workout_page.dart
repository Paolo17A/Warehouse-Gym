import 'package:carousel_slider/carousel_slider.dart';
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
      body: StartWorkoutBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                    ),
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
                  ],
                ),
                if (workouts.isNotEmpty)
                  roundedContainer(
                    height: 170,
                    color: const Color.fromARGB(255, 209, 209, 209),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: CarouselSlider.builder(
                        itemCount: workouts.length,
                        itemBuilder: (context, index, _) {
                          return roundedContainer(
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                fitnesscoText(
                                  workouts[index],
                                  textStyle: blackBoldStyle(),
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.12,
                                  width: 75,
                                  color: Colors.white,
                                  child: Image.asset(
                                    'assets/images/gifs/${workouts[index]}.gif',
                                    errorBuilder: (_, __, ___) =>
                                        const Icon(Icons.fitness_center),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        options: CarouselOptions(
                          height: MediaQuery.of(context).size.height * 0.35,
                          viewportFraction: 0.5,
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
                    child: fitnesscoText(
                      'Skip warm-up',
                      textStyle: blackBoldStyle(size: 16),
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
