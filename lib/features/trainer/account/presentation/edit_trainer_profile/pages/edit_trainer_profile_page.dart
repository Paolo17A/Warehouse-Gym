import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_warehouse_gym/core/constants/app_colors.dart';
import 'package:the_warehouse_gym/core/constants/sex_options.dart';
import 'package:the_warehouse_gym/core/errors/failures.dart';
import 'package:the_warehouse_gym/core/providers/session_providers.dart';
import 'package:the_warehouse_gym/core/widgets/fitnessco_ui.dart';
import 'package:the_warehouse_gym/core/widgets/loading_widget.dart';
import 'package:the_warehouse_gym/core/widgets/no_internet_widget.dart';
import 'package:the_warehouse_gym/features/trainer/account/presentation/edit_trainer_profile/viewmodels/trainer_account_viewmodel.dart';

class EditTrainerProfilePage extends HookConsumerWidget {
  const EditTrainerProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(trainerAccountViewModelProvider);
    final viewModel = ref.read(trainerAccountViewModelProvider.notifier);
    final currentUser = ref.watch(sessionUserProvider);
    final uid = currentUser?.uid ?? '';

    final formKey = useMemoized(GlobalKey<FormState>.new);
    final formReady = useState(false);

    final ageCtrl = useTextEditingController();
    final contactCtrl = useTextEditingController();
    final addressCtrl = useTextEditingController();

    final sex = useState<String>(SexOptions.defaultValue);

    // Chip-based list fields
    final certificationsCtrl = useTextEditingController();
    final interestsCtrl = useTextEditingController();
    final specialtyCtrl = useTextEditingController();

    final certifications = useState<List<String>>([]);
    final interests = useState<List<String>>([]);
    final specialty = useState<List<String>>([]);

    final selectedImagePath = useState<String?>(null);

    useEffect(() {
      if (uid.isEmpty) return null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.loadProfile(uid);
      });
      return null;
    }, [uid]);

    useEffect(() {
      if (state.isLoading || state.user == null) {
        formReady.value = false;
        return null;
      }

      final profile = state.user!.trainerProfile;
      if (profile != null) {
        ageCtrl.text = profile.age;
        contactCtrl.text = profile.contactNumber;
        addressCtrl.text = profile.address;
        sex.value = SexOptions.normalize(profile.sex);
        certifications.value = List.from(profile.certifications);
        interests.value = List.from(profile.interests);
        specialty.value = List.from(profile.specialty);
      }

      formReady.value = true;
      return null;
    }, [state.isLoading, state.user]);

    Future<void> pickImage() async {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) selectedImagePath.value = image.path;
    }

    Future<void> onSave() async {
      if (!formKey.currentState!.validate()) return;

      if (selectedImagePath.value != null) {
        await viewModel.uploadAndUpdateProfileImage(
          uid,
          selectedImagePath.value!,
        );
      }

      await viewModel.updateProfile(uid, {
        'trainerProfile': {
          'sex': sex.value,
          'age': ageCtrl.text.trim(),
          'contactNumber': contactCtrl.text.trim(),
          'address': addressCtrl.text.trim(),
          'certifications': certifications.value,
          'interests': interests.value,
          'specialty': specialty.value,
        },
      });

      viewModel.refresh(uid);
    }

    if (state.isLoading || !formReady.value) {
      return const Scaffold(body: LoadingWidget());
    }

    if (state.failure is NetworkFailure) {
      return Scaffold(
        body: NoInternetWidget(onRetry: () => viewModel.refresh(uid)),
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: FitnesscoScreenShell(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: AuthLoadingStack(
          isLoading: state.isSubmitting,
          children: [
            RegisterAuthBackground(
              child: RefreshIndicator(
                onRefresh: () => viewModel.refresh(uid),
                color: AppColors.purpleSnail,
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(30),
                        Center(
                          child: fitnesscoText(
                            'Edit Profile Description',
                            textStyle: whiteBoldStyle(size: 25),
                          ),
                        ),
                        const Gap(20),
                        Center(
                          child: GestureDetector(
                            onTap: pickImage,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 56,
                                  backgroundColor: AppColors.electricLavender,
                                  backgroundImage:
                                      state.user?.profileImageURL.isNotEmpty ==
                                              true
                                          ? NetworkImage(
                                              state.user!.profileImageURL,
                                            )
                                          : const AssetImage(
                                              'assets/images/defaultProfile.png',
                                            ) as ImageProvider,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      color: AppColors.purpleSnail,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Gap(24),
                        roundedContainer(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _sectionHeader('Basic Information'),
                                const Gap(12),
                                _buildDropdown<String>(
                                  label: 'Sex',
                                  value: sex.value,
                                  items: SexOptions.options,
                                  onChanged: (v) {
                                    if (v != null) sex.value = v;
                                  },
                                ),
                                const Gap(12),
                                _buildTextField(
                                  ageCtrl,
                                  'Age',
                                  keyboardType: TextInputType.number,
                                  required: true,
                                ),
                                const Gap(12),
                                _buildTextField(
                                  contactCtrl,
                                  'Contact Number',
                                  keyboardType: TextInputType.phone,
                                  required: true,
                                ),
                                const Gap(12),
                                _buildTextField(
                                  addressCtrl,
                                  'Address',
                                  required: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Gap(16),
                        roundedContainer(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _sectionHeader('Certifications'),
                                const Gap(8),
                                _buildChipInput(
                                  controller: certificationsCtrl,
                                  hint: 'Add certification...',
                                  chips: certifications.value,
                                  onAdd: (value) {
                                    if (value.isNotEmpty &&
                                        !certifications.value.contains(value)) {
                                      certifications.value = [
                                        ...certifications.value,
                                        value,
                                      ];
                                      certificationsCtrl.clear();
                                    }
                                  },
                                  onDelete: (item) {
                                    certifications.value = certifications.value
                                        .where((e) => e != item)
                                        .toList();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Gap(16),
                        roundedContainer(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _sectionHeader('Interests'),
                                const Gap(8),
                                _buildChipInput(
                                  controller: interestsCtrl,
                                  hint: 'Add interest...',
                                  chips: interests.value,
                                  onAdd: (value) {
                                    if (value.isNotEmpty &&
                                        !interests.value.contains(value)) {
                                      interests.value = [
                                        ...interests.value,
                                        value,
                                      ];
                                      interestsCtrl.clear();
                                    }
                                  },
                                  onDelete: (item) {
                                    interests.value = interests.value
                                        .where((e) => e != item)
                                        .toList();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Gap(16),
                        roundedContainer(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _sectionHeader('Specialty'),
                                const Gap(8),
                                _buildChipInput(
                                  controller: specialtyCtrl,
                                  hint: 'Add specialty...',
                                  chips: specialty.value,
                                  onAdd: (value) {
                                    if (value.isNotEmpty &&
                                        !specialty.value.contains(value)) {
                                      specialty.value = [
                                        ...specialty.value,
                                        value,
                                      ];
                                      specialtyCtrl.clear();
                                    }
                                  },
                                  onDelete: (item) {
                                    specialty.value = specialty.value
                                        .where((e) => e != item)
                                        .toList();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Gap(32),
                        Center(
                          child: AuthGradientButton(
                            label: 'Save Changes',
                            width: 250,
                            onTap: state.isSubmitting ? () {} : onSave,
                          ),
                        ),
                        const Gap(24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return fitnesscoText(
      title,
      textStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.purpleSnail,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    bool required = false,
  }) {
    return FormField<String>(
      initialValue: controller.text,
      validator: required
          ? (v) => controller.text.trim().isEmpty ? '$label is required' : null
          : null,
      builder: (field) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          fitnesscoFormTextField(label, keyboardType, controller),
          if (field.hasError)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 12),
              child: Text(
                field.errorText!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required void Function(T?) onChanged,
  }) {
    assert(items.isNotEmpty, 'Dropdown items cannot be empty');
    final selected =
        value != null && items.contains(value) ? value : items.first;

    return DropdownButtonFormField<T>(
      initialValue: selected,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.purpleSnail),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(width: 1, color: AppColors.nearMoon),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      ),
      items: items
          .map((e) => DropdownMenuItem<T>(value: e, child: Text('$e')))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildChipInput({
    required TextEditingController controller,
    required String hint,
    required List<String> chips,
    required void Function(String) onAdd,
    required void Function(String) onDelete,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: fitnesscoFormTextField(
                hint,
                TextInputType.text,
                controller,
              ),
            ),
            const Gap(8),
            IconButton(
              onPressed: () => onAdd(controller.text.trim()),
              icon: const Icon(Icons.add_circle, color: AppColors.purpleSnail),
            ),
          ],
        ),
        if (chips.isNotEmpty) ...[
          const Gap(8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: chips
                .map(
                  (chip) => Chip(
                    label: fitnesscoText(
                      chip,
                      textStyle: blackBoldStyle(size: 13),
                    ),
                    onDeleted: () => onDelete(chip),
                    backgroundColor: AppColors.electricLavender,
                    deleteIconColor: AppColors.purpleSnail,
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }
}
