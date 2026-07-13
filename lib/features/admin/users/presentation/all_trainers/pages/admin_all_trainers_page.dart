import 'package:the_warehouse_gym/core/router/app_router.dart';
import 'package:the_warehouse_gym/core/constants/app_colors.dart';
import 'package:the_warehouse_gym/core/utils/toast_utils.dart';
import 'package:the_warehouse_gym/core/widgets/fitnessco_ui.dart';
import 'package:the_warehouse_gym/core/widgets/loading_widget.dart';
import 'package:the_warehouse_gym/features/admin/users/presentation/all_trainers/viewmodels/admin_all_trainers_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widgets/admin_trainer_row_widget.dart';

class AdminAllTrainersPage extends HookConsumerWidget {
  const AdminAllTrainersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminAllTrainersViewModelProvider);
    final viewModel = ref.read(adminAllTrainersViewModelProvider.notifier);
    final isLoading = state is Loading;
    final trainers = useState<List>([]);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.loadTrainers();
      });
      return null;
    }, const []);

    ref.listen(adminAllTrainersViewModelProvider, (_, next) {
      if (next is Failure) {
        showErrorToast(next.message);
      }
      if (next is Success) {
        trainers.value = next.trainers;
      }
    });

    return isLoading
        ? const Scaffold(body: LoadingWidget())
        : Scaffold(
            extendBodyBehindAppBar: true,
            appBar: largeGradientAppBar(
              'All Trainers',
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => context.push(AppRouter.addTrainer),
                ),
              ],
            ),
            body: ViewTrainerBackground(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: RefreshIndicator(
                    onRefresh: viewModel.refresh,
                    child: trainers.value.isEmpty
                        ? ListView(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
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
                            itemCount: trainers.value.length,
                            itemBuilder: (context, index) {
                              final trainer = trainers.value[index];
                              return AdminTrainerRow(
                                trainer: trainer,
                                onTap: () => context.push(
                                  AppRouter.adminSelectedTrainer(
                                    trainer['uid'] as String,
                                  ),
                                ),
                                onDelete: () => _confirmDelete(
                                  context,
                                  trainer,
                                  viewModel,
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ),
            ),
          );
  }

  void _confirmDelete(
    BuildContext context,
    Map<String, dynamic> trainer,
    AdminAllTrainersViewModel viewModel,
  ) {
    final firstName = trainer['firstName'] as String? ?? '';
    final lastName = trainer['lastName'] as String? ?? '';
    final uid = trainer['uid'] as String? ?? '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Trainer'),
        content: Text(
          'Are you sure you want to remove $firstName $lastName? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.of(context).pop();
              await viewModel.deleteTrainer(uid);
              showSuccessToast('Trainer removed successfully');
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
