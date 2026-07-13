import 'package:the_warehouse_gym/core/router/app_router.dart';
import 'package:gap/gap.dart';
import 'package:the_warehouse_gym/core/constants/app_colors.dart';
import 'package:the_warehouse_gym/core/errors/failures.dart';
import 'package:the_warehouse_gym/core/providers/session_providers.dart';
import 'package:the_warehouse_gym/core/widgets/fitnessco_ui.dart';
import 'package:the_warehouse_gym/core/widgets/no_internet_widget.dart';
import 'package:the_warehouse_gym/features/client/account/presentation/viewmodels/client_account_viewmodel.dart';
import 'package:the_warehouse_gym/features/client/bmi/domain/entities/bmi_entry.dart';
import 'package:the_warehouse_gym/features/client/bmi/presentation/viewmodels/bmi_viewmodel.dart';
import 'package:the_warehouse_gym/features/client/home/presentation/viewmodels/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class BmiHistoryPage extends HookConsumerWidget {
  const BmiHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(sessionUserProvider)?.uid ?? '';
    final bmiState = ref.watch(bmiViewModelProvider);
    final viewModel = ref.read(bmiViewModelProvider.notifier);

    useEffect(() {
      if (uid.isEmpty) return null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.loadHistory(uid);
      });
      return null;
    }, [uid]);

    ref.listen<BmiState>(bmiViewModelProvider, (previous, next) {
      final wasSubmitting = previous?.isSubmitting ?? false;
      final isNowLoaded = next.maybeMap(
        loaded: (_) => true,
        orElse: () => false,
      );
      if (wasSubmitting && isNowLoaded) {
        ref.read(homeViewModelProvider.notifier).refresh(uid);
        ref.read(clientAccountViewModelProvider.notifier).refresh(uid);
      }
    });

    if (bmiState.failure is NetworkFailure) {
      return FitnesscoScreenShell(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Center(
            child: fitnesscoText(
              'BMI History',
              textStyle: whiteBoldStyle(size: 30),
            ),
          ),
        ),
        body: NoInternetWidget(onRetry: () => viewModel.loadHistory(uid)),
      );
    }

    final latestBmi =
        bmiState.entries.isNotEmpty ? bmiState.entries.first.bmiValue : 0.0;

    return FitnesscoScreenShell(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Center(
          child: fitnesscoText(
            'BMI History',
            textStyle: whiteBoldStyle(size: 30),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRouter.addBmi),
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
      body: SwitchedLoadingContainer(
        isLoading: bmiState.isLoading,
        child: RegisterAuthBackground(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  const Gap(20),
                  if (bmiState.entries.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: fitnesscoText(
                        latestBmi.toStringAsFixed(2),
                        textStyle: blackBoldStyle(size: 50),
                      ),
                    ),
                  const Gap(15),
                  _BmiChart(),
                  const Gap(15),
                  if (bmiState.entries.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: fitnesscoText('No BMI records yet.'),
                    )
                  else
                    roundedContainer(
                      color: AppColors.love,
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.45,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              fitnesscoText(
                                'My BMI History',
                                textStyle: blackBoldStyle(),
                              ),
                              ...bmiState.entries.map(
                                (entry) => _BmiEntryRow(entry: entry),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BmiChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        children: [
          fitnesscoText('BMI Chart', textStyle: blackBoldStyle()),
          const Gap(10),
          roundedContainer(
            color: AppColors.love.withValues(alpha: 0.75),
            height: 150,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      fitnesscoText('Underweight', textStyle: blackBoldStyle()),
                      fitnesscoText('> 18.5'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      fitnesscoText('Normal', textStyle: blackBoldStyle()),
                      fitnesscoText('18.5 - 24.9'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      fitnesscoText('Overweight', textStyle: blackBoldStyle()),
                      fitnesscoText('25 - 29.9'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      fitnesscoText('Obese', textStyle: blackBoldStyle()),
                      fitnesscoText('30 +'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BmiEntryRow extends StatelessWidget {
  final BmiEntry entry;

  const _BmiEntryRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MM - dd - yyyy').format(entry.dateTime);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 40,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 252, 138, 206),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            fitnesscoText(
              formattedDate,
              textStyle: const TextStyle(color: Colors.white),
            ),
            fitnesscoText(
              'BMI: ${entry.bmiValue.toStringAsFixed(2)}',
              textStyle: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
