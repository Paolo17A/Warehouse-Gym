import 'package:the_warehouse_gym/core/router/app_router.dart';
import 'package:the_warehouse_gym/core/constants/app_colors.dart';
import 'package:the_warehouse_gym/core/errors/failures.dart';
import 'package:the_warehouse_gym/core/utils/toast_utils.dart';
import 'package:the_warehouse_gym/core/widgets/fitnessco_ui.dart';
import 'package:the_warehouse_gym/core/widgets/loading_widget.dart';
import 'package:the_warehouse_gym/core/widgets/no_internet_widget.dart';
import 'package:the_warehouse_gym/features/client/users/presentation/all_trainers/viewmodels/client_all_trainers_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ClientAllTrainersPage extends HookConsumerWidget {
  const ClientAllTrainersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(clientAllTrainersViewModelProvider);
    final viewModel = ref.read(clientAllTrainersViewModelProvider.notifier);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.loadTrainers();
      });
      return null;
    }, const []);

    ref.listen<ClientAllTrainersState>(clientAllTrainersViewModelProvider,
        (_, next) {
      next.maybeWhen(
        failure: (message) => showErrorToast(message),
        orElse: () {},
      );
    });

    return state.when(
      loading: () => const Scaffold(body: LoadingWidget()),
      failure: (message) {
        if (message == const NetworkFailure().message) {
          return Scaffold(
            body: NoInternetWidget(onRetry: viewModel.refresh),
          );
        }
        return Scaffold(
          appBar: largeGradientAppBar('All Trainers'),
          body: Center(child: Text(message)),
        );
      },
      success: (trainers) => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: largeGradientAppBar('All Trainers'),
        body: ViewTrainerBackground(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: RefreshIndicator(
                onRefresh: viewModel.refresh,
                child: trainers.isEmpty
                    ? ListView(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: Center(
                              child: fitnesscoText(
                                'NO TRAINERS AVAILABLE',
                                textStyle: const TextStyle(
                                  fontSize: 35,
                                  color: AppColors.purpleSnail,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        itemCount: trainers.length,
                        itemBuilder: (context, index) {
                          final trainer = trainers[index];
                          return _ClientTrainerRow(
                            trainer: trainer,
                            onTap: () => context.push(
                              AppRouter.clientSelectedTrainer(
                                trainer['uid'] as String,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ClientTrainerRow extends StatelessWidget {
  final Map<String, dynamic> trainer;
  final VoidCallback onTap;

  const _ClientTrainerRow({
    required this.trainer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final firstName = trainer['firstName'] as String? ?? '';
    final lastName = trainer['lastName'] as String? ?? '';
    final profileImageURL = trainer['profileImageURL'] as String? ?? '';
    final currentClients = trainer['currentClients'] is List
        ? trainer['currentClients'] as List
        : <dynamic>[];
    final trainerProfile =
        trainer['trainerProfile'] as Map<String, dynamic>? ?? {};
    final sex = trainerProfile['sex'] as String? ?? '';
    final age = trainerProfile['age'] ?? '';

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                trainerProfileImage(profileImageURL),
                trainerProfileContent(
                  context,
                  firstName,
                  lastName,
                  currentClients,
                  sex,
                  age,
                ),
              ],
            ),
            userDivider(),
          ],
        ),
      ),
    );
  }
}
