import 'package:the_warehouse_gym/core/router/app_router.dart';
import 'package:the_warehouse_gym/core/constants/app_colors.dart';
import 'package:the_warehouse_gym/core/widgets/fitnessco_ui.dart';
import 'package:the_warehouse_gym/core/widgets/loading_widget.dart';
import 'package:the_warehouse_gym/features/admin/users/presentation/all_clients/viewmodels/all_clients_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../core/utils/toast_utils.dart';
import '../widgets/client_row_widget.dart';

class AllClientsPage extends HookConsumerWidget {
  const AllClientsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(allClientsViewModelProvider);
    final viewModel = ref.read(allClientsViewModelProvider.notifier);
    final isLoading = state is Loading;
    final clients = useState<List>([]);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.loadClients();
      });
      return null;
    }, const []);

    ref.listen(allClientsViewModelProvider, (_, next) {
      if (next is Failure) {
        showErrorToast(next.message);
      }
      if (next is Success) {
        clients.value = next.clients;
      }
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: largeGradientAppBar('All Clients'),
      body: ViewTrainerBackground(
        child: isLoading
            ? const LoadingWidget()
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: RefreshIndicator(
                    onRefresh: viewModel.refresh,
                    child: clients.value.isEmpty
                        ? ListView(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: Center(
                                  child: fitnesscoText(
                                    'NO CLIENTS AVAILABLE',
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
                            itemCount: clients.value.length,
                            itemBuilder: (context, index) {
                              final client = clients.value[index];
                              return ClientRow(
                                client: client,
                                onTap: () => context.push(
                                  AppRouter.adminSelectedClient(
                                    client['uid'] as String,
                                  ),
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
}
