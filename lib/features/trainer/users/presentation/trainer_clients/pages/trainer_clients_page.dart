import 'package:the_warehouse_gym/core/constants/app_colors.dart';
import 'package:the_warehouse_gym/core/errors/failures.dart';
import 'package:the_warehouse_gym/core/providers/session_providers.dart';
import 'package:the_warehouse_gym/core/utils/toast_utils.dart';
import 'package:the_warehouse_gym/core/widgets/fitnessco_ui.dart';
import 'package:the_warehouse_gym/core/widgets/loading_widget.dart';
import 'package:the_warehouse_gym/core/widgets/no_internet_widget.dart';
import 'package:the_warehouse_gym/features/trainer/users/presentation/trainer_clients/viewmodels/trainer_clients_viewmodel.dart';
import 'package:the_warehouse_gym/features/trainer/users/presentation/trainer_clients/widgets/client_request_card.dart';
import 'package:the_warehouse_gym/features/trainer/users/presentation/trainer_clients/widgets/current_client_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TrainerClientsPage extends HookConsumerWidget {
  const TrainerClientsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trainerUid = ref.watch(sessionUserProvider)?.uid ?? '';
    final state = ref.watch(trainerClientsViewModelProvider);
    final viewModel = ref.read(trainerClientsViewModelProvider.notifier);
    final tabController = useTabController(initialLength: 2);

    useEffect(() {
      if (trainerUid.isEmpty) return null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.loadClients(trainerUid);
      });
      return null;
    }, [trainerUid]);

    ref.listen<TrainerClientsState>(trainerClientsViewModelProvider, (_, next) {
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
            body: NoInternetWidget(
              onRetry: () => viewModel.refresh(trainerUid),
            ),
          );
        }
        return Scaffold(
          appBar: largeGradientAppBar('My Clients'),
          body: Center(child: Text(message)),
        );
      },
      success: (data) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: largeGradientAppBar('My Clients'),
          body: ViewTrainerBackground(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TabBar(
                      controller: tabController,
                      labelColor: AppColors.purpleSnail,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: AppColors.purpleSnail,
                      tabs: [
                        Tab(
                          child: fitnesscoText(
                            'CURRENT CLIENTS',
                            textStyle: blackBoldStyle(size: 12),
                          ),
                        ),
                        Tab(
                          child: fitnesscoText(
                            'CLIENT REQUESTS',
                            textStyle: blackBoldStyle(size: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => viewModel.refresh(trainerUid),
                      color: AppColors.purpleSnail,
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          _CurrentClientsTab(
                            clients: data.currentClients,
                            onRemove: (clientUid) {
                              Map<String, dynamic>? client;
                              for (final entry in data.currentClients) {
                                if (entry['uid'] == clientUid) {
                                  client = entry;
                                  break;
                                }
                              }
                              if (client == null) return;
                              _confirmRemove(
                                context,
                                client,
                                trainerUid,
                                viewModel,
                              );
                            },
                          ),
                          _ClientRequestsTab(
                            requests: data.pendingRequests,
                            trainerUid: trainerUid,
                            viewModel: viewModel,
                            onAccepted: () => tabController.animateTo(0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _confirmRemove(
    BuildContext context,
    Map<String, dynamic> client,
    String trainerUid,
    TrainerClientsViewModel viewModel,
  ) {
    final firstName = client['firstName'] as String? ?? '';
    final lastName = client['lastName'] as String? ?? '';
    final clientUid = client['uid'] as String? ?? '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Remove Client'),
        content: Text(
          'Remove $firstName $lastName from your client list?',
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
              await viewModel.removeClient(trainerUid, clientUid);
              showSuccessToast('Client removed');
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}

class _CurrentClientsTab extends StatelessWidget {
  final List<Map<String, dynamic>> clients;
  final ValueChanged<String> onRemove;

  const _CurrentClientsTab({
    required this.clients,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(10),
      children: [
        roundedContainer(
          color: AppColors.love,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: fitnesscoText(
                  'CURRENT CLIENTS',
                  textStyle: greyBoldStyle(size: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: roundedContainer(
                  color: Colors.white.withValues(alpha: 0.75),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.55,
                    child: clients.isEmpty
                        ? Center(
                            child: fitnesscoText(
                              'No Current Clients',
                              textStyle: greyBoldStyle(size: 15),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(5),
                            itemCount: clients.length,
                            itemBuilder: (context, index) {
                              final client = clients[index];
                              final uid = client['uid'] as String? ?? '';
                              final firstName =
                                  client['firstName'] as String? ?? '';
                              final lastName =
                                  client['lastName'] as String? ?? '';
                              final profileImageURL =
                                  client['profileImageURL'] as String? ?? '';

                              return CurrentClientCard(
                                clientUid: uid,
                                firstName: firstName,
                                lastName: lastName,
                                profileImageURL: profileImageURL,
                                onRemove: () => onRemove(uid),
                              );
                            },
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ClientRequestsTab extends StatelessWidget {
  final List<Map<String, dynamic>> requests;
  final String trainerUid;
  final TrainerClientsViewModel viewModel;
  final VoidCallback onAccepted;

  const _ClientRequestsTab({
    required this.requests,
    required this.trainerUid,
    required this.viewModel,
    required this.onAccepted,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(10),
      children: [
        fitnesscoText(
          'Client Requests',
          textStyle: greyBoldStyle(size: 18),
        ),
        const Divider(thickness: 1.5),
        roundedContainer(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: requests.isEmpty
                ? Center(
                    child: fitnesscoText(
                      'No Client Requests',
                      textStyle: blackBoldStyle(),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(5),
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final client = requests[index];
                      final uid = client['uid'] as String? ?? '';
                      final firstName = client['firstName'] as String? ?? '';
                      final lastName = client['lastName'] as String? ?? '';
                      final profileImageURL =
                          client['profileImageURL'] as String? ?? '';

                      return ClientRequestCard(
                        clientUid: uid,
                        firstName: firstName,
                        lastName: lastName,
                        profileImageURL: profileImageURL,
                        onApprove: () {
                          viewModel.confirmClient(trainerUid, uid);
                          onAccepted();
                        },
                        onDeny: () => viewModel.rejectClient(trainerUid, uid),
                      );
                    },
                  ),
          ),
        ),
        const Divider(thickness: 1.5),
      ],
    );
  }
}
