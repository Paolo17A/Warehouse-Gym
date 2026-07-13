import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:the_warehouse_gym/core/constants/app_colors.dart';
import 'package:the_warehouse_gym/core/utils/toast_utils.dart';
import 'package:the_warehouse_gym/core/widgets/fitnessco_ui.dart';
import 'package:the_warehouse_gym/core/widgets/loading_widget.dart';
import 'package:the_warehouse_gym/features/admin/users/presentation/selected_client/viewmodels/admin_selected_client_profile_viewmodel.dart';
import 'package:the_warehouse_gym/features/shared/users/presentation/widgets/client_profile_body.dart';

import '../../../../../shared/account/domain/entities/full_user.dart';

class AdminSelectedClientProfilePage extends HookConsumerWidget {
  final String clientUid;

  const AdminSelectedClientProfilePage({super.key, required this.clientUid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel =
        ref.read(adminSelectedClientProfileViewModelProvider.notifier);
    final state = ref.watch(adminSelectedClientProfileViewModelProvider);
    final isLoading = state is Loading;
    final fullUser = useState<FullUser?>(null);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.loadProfile(clientUid);
      });
      return null;
    }, [clientUid]);

    ref.listen<AdminSelectedClientProfileState>(
      adminSelectedClientProfileViewModelProvider,
      (_, next) {
        if (next is Success) {
          fullUser.value = next.user;
        }
        if (next is Failure) {
          showErrorToast(next.message);
        }
      },
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: largeGradientAppBar('All Clients'),
      body: ViewTrainerBackground(
        child: isLoading
            ? const LoadingWidget()
            : SafeArea(
                child: RefreshIndicator(
                  onRefresh: () => viewModel.refresh(clientUid),
                  color: AppColors.purpleSnail,
                  child: fullUser.value == null
                      ? ListView(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: Center(
                                child: fitnesscoText(
                                  'No client profile found.',
                                  textStyle: greyBoldStyle(size: 16),
                                ),
                              ),
                            ),
                          ],
                        )
                      : ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            ClientProfileBody(user: fullUser.value!),
                            const Gap(24),
                          ],
                        ),
                ),
              ),
      ),
    );
  }
}
