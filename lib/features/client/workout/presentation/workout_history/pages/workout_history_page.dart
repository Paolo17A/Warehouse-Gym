import 'package:the_warehouse_gym/core/constants/app_colors.dart';
import 'package:the_warehouse_gym/core/errors/failures.dart';
import 'package:the_warehouse_gym/core/di/injection.dart';
import 'package:the_warehouse_gym/core/providers/session_providers.dart';
import 'package:the_warehouse_gym/features/shared/account/domain/usecases/account_usecase.dart';
import 'package:the_warehouse_gym/core/widgets/fitnessco_ui.dart';
import 'package:the_warehouse_gym/core/widgets/no_internet_widget.dart';
import 'package:the_warehouse_gym/features/client/workout/domain/entities/workout_session.dart';
import 'package:the_warehouse_gym/features/client/workout/presentation/viewmodels/workout_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class WorkoutHistoryPage extends HookConsumerWidget {
  const WorkoutHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(sessionUserProvider)?.uid ?? '';
    final workoutState = ref.watch(workoutViewModelProvider);
    final viewModel = ref.read(workoutViewModelProvider.notifier);
    final firstName = useState('');

    useEffect(() {
      if (uid.isEmpty) return null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.loadHistory(uid);
      });
      sl<AccountUseCase>().getProfile(uid).then((result) {
        result.fold((_) {}, (user) {
          firstName.value = user.firstName;
        });
      });
      return null;
    }, [uid]);

    if (workoutState.failure is NetworkFailure) {
      return FitnesscoScreenShell(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Center(
            child: fitnesscoText(
              'WORKOUT HISTORY',
              textStyle: blackBoldStyle(),
            ),
          ),
        ),
        body: NoInternetWidget(onRetry: () => viewModel.loadHistory(uid)),
      );
    }

    return FitnesscoScreenShell(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        title: Center(
          child: fitnesscoText(
            'WORKOUT HISTORY',
            textStyle: blackBoldStyle(),
          ),
        ),
      ),
      body: SwitchedLoadingContainer(
        isLoading: workoutState.isLoading,
        child: RegisterAuthBackground(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: SafeArea(
                  child: workoutState.history.isEmpty
                      ? Center(
                          child: fitnesscoText('You have no Workout History'),
                        )
                      : RefreshIndicator(
                          onRefresh: () => viewModel.loadHistory(uid),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(20),
                            itemCount: workoutState.history.length,
                            itemBuilder: (context, index) {
                              final session = workoutState.history[index];
                              return _SessionCard(
                                session: session,
                                isFirst: index == 0,
                                firstName: firstName.value,
                              );
                            },
                          ),
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

class _SessionCard extends StatelessWidget {
  final WorkoutSession session;
  final bool isFirst;
  final String firstName;

  const _SessionCard({
    required this.session,
    required this.isFirst,
    required this.firstName,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd MMM yyy').format(session.dateTime);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        height: isFirst ? 350 : 250,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.electricLavender, AppColors.rosePink],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (isFirst)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      fitnesscoText(
                        'Hi, $firstName',
                        textStyle: whiteBoldStyle(size: 32),
                      ),
                      Divider(color: Colors.grey.shade400, thickness: 1),
                      fitnesscoText(
                        'This is what you\'ve achieved so far',
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      Divider(color: Colors.grey.shade400, thickness: 1),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: fitnesscoText(
                  formattedDate,
                  textStyle: blackBoldStyle(size: 30),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: session.exercises.entries.expand((muscleEntry) {
                        final exercisesMap =
                            muscleEntry.value as Map<String, dynamic>? ?? {};
                        return exercisesMap.keys.map(
                          (workout) => fitnesscoText(
                            workout,
                            textStyle: blackBoldStyle(size: 18),
                          ),
                        );
                      }).toList(),
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
