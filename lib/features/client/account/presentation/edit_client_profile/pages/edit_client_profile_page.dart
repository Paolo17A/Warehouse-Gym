import 'dart:io';

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
import 'package:the_warehouse_gym/features/client/account/presentation/viewmodels/client_account_viewmodel.dart';

const _workoutExperiences = [
  'NO EXPERIENCE',
  'NOVICE',
  'AMATEUR',
  'EXPERIENCED',
  'ATHLETE',
];

const _dietChoices = ['CARNIVORE', 'VEGETARIAN', 'ALL-AROUND'];

const _bodyConcernChoices = ['WEIGHT LOSS', 'WEIGHT GAIN', 'ATHLETICISM'];

const _muscleGoalChoices = [
  'UPPER BODY',
  'CORE',
  'LEGS',
  'BUTTOCKS',
  'WHOLE BODY',
];

const _dedicationSpanChoices = [
  '1 MONTH',
  '3 MONTHS',
  '6 MONTHS',
  'FULL-TIME TRAINING',
];

String _dropdownValue(String? value, List<String> options, [String? fallback]) {
  if (value != null && value.isNotEmpty) return value;
  return fallback ?? options.first;
}

List<String> _dropdownItems(String value, List<String> options) {
  if (value.isNotEmpty && !options.contains(value)) {
    return [value, ...options];
  }
  return options;
}

class EditClientProfilePage extends HookConsumerWidget {
  const EditClientProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(clientAccountViewModelProvider);
    final viewModel = ref.read(clientAccountViewModelProvider.notifier);
    final currentUser = ref.watch(sessionUserProvider);
    final uid = currentUser?.uid ?? '';

    final formKey = useMemoized(GlobalKey<FormState>.new);
    final formReady = useState(false);

    final firstNameCtrl = useTextEditingController();
    final lastNameCtrl = useTextEditingController();
    final ageCtrl = useTextEditingController();
    final heightCtrl = useTextEditingController();
    final weightCtrl = useTextEditingController();
    final workoutFreqCtrl = useTextEditingController();
    final sleepHoursCtrl = useTextEditingController();
    final workoutAvailabilityCtrl = useTextEditingController();
    final illnessesCtrl = useTextEditingController();
    final allergiesCtrl = useTextEditingController();
    final injuriesCtrl = useTextEditingController();
    final medicationsCtrl = useTextEditingController();
    final steroidsCtrl = useTextEditingController();
    final specialPlansCtrl = useTextEditingController();

    final sex = useState<String>(SexOptions.defaultValue);
    final workoutExperience = useState<String>(_workoutExperiences.first);
    final foodDiet = useState<String>(_dietChoices.first);
    final bodyConcern = useState<String>(_bodyConcernChoices.first);
    final muscleGoal = useState<String>(_muscleGoalChoices.first);
    final dedicationSpan = useState<String>(_dedicationSpanChoices.first);
    final recentlyDoctored = useState<bool>(false);
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

      final user = state.user!;
      final profile = user.clientProfile;

      if (profile != null) {
        firstNameCtrl.text = profile.firstName;
        lastNameCtrl.text = profile.lastName;
        ageCtrl.text = profile.age > 0 ? profile.age.toString() : '';
        heightCtrl.text = profile.height > 0 ? profile.height.toString() : '';
        weightCtrl.text = profile.weight > 0 ? profile.weight.toString() : '';
        workoutFreqCtrl.text = profile.workoutFrequency > 0
            ? profile.workoutFrequency.toString()
            : '';
        sleepHoursCtrl.text =
            profile.sleepHours > 0 ? profile.sleepHours.toString() : '';
        workoutAvailabilityCtrl.text = profile.workoutAvailability;
        illnessesCtrl.text = profile.illnesses;
        allergiesCtrl.text = profile.allergies;
        injuriesCtrl.text = profile.injuries;
        medicationsCtrl.text = profile.medications;
        steroidsCtrl.text = profile.steroids;
        specialPlansCtrl.text = profile.specialPlans;

        sex.value = SexOptions.normalize(profile.sex);
        workoutExperience.value = _dropdownValue(
          profile.workoutExperience,
          _workoutExperiences,
        );
        foodDiet.value = _dropdownValue(profile.foodDiet, _dietChoices);
        bodyConcern.value =
            _dropdownValue(profile.bodyConcerns, _bodyConcernChoices);
        muscleGoal.value = _dropdownValue(profile.muscleGoal, _muscleGoalChoices);
        dedicationSpan.value =
            _dropdownValue(profile.dedicationSpan, _dedicationSpanChoices);
        recentlyDoctored.value = profile.recentlyDoctored;
      }

      formReady.value = true;
      return null;
    }, [state.isLoading, state.user]);

    Future<void> pickImage() async {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImagePath.value = image.path;
      }
    }

    Future<void> onSave() async {
      if (!formKey.currentState!.validate()) return;

      if (selectedImagePath.value != null) {
        await viewModel.uploadAndUpdateProfileImage(
          uid,
          selectedImagePath.value!,
        );
      }

      final success = await viewModel.updateProfile(uid, {
        'firstName': firstNameCtrl.text.trim(),
        'lastName': lastNameCtrl.text.trim(),
        'profileDetails': {
          'firstName': firstNameCtrl.text.trim(),
          'lastName': lastNameCtrl.text.trim(),
          'age': int.tryParse(ageCtrl.text.trim()) ?? 0,
          'sex': SexOptions.normalize(sex.value),
          'height': double.tryParse(heightCtrl.text.trim()) ?? 0.0,
          'weight': double.tryParse(weightCtrl.text.trim()) ?? 0.0,
          'workoutExperience': workoutExperience.value,
          'workoutAvailability': workoutAvailabilityCtrl.text.trim(),
          'workoutFrequency': int.tryParse(workoutFreqCtrl.text.trim()) ?? 0,
          'sleepHours': int.tryParse(sleepHoursCtrl.text.trim()) ?? 0,
          'illnesses': illnessesCtrl.text.trim(),
          'allergies': allergiesCtrl.text.trim(),
          'injuries': injuriesCtrl.text.trim(),
          'medications': medicationsCtrl.text.trim(),
          'steroids': steroidsCtrl.text.trim(),
          'foodDiet': foodDiet.value,
          'bodyConcerns': bodyConcern.value,
          'muscleGoal': muscleGoal.value,
          'dedicationSpan': dedicationSpan.value,
          'specialPlans': specialPlansCtrl.text.trim(),
          'recentlyDoctored': recentlyDoctored.value,
        },
      });
      if (success && context.mounted) {
        viewModel.refresh(uid);
      }
    }

    if (state.isLoading || !formReady.value) {
      return const Scaffold(body: LoadingWidget());
    }

    if (state.failure is NetworkFailure) {
      return Scaffold(
        body: NoInternetWidget(onRetry: () => viewModel.refresh(uid)),
      );
    }

    final profileImageURL = state.user?.profileImageURL ?? '';
    final screenHeight = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 3,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: FitnesscoScreenShell(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Center(
              child: fitnesscoText(
                'Edit Profile Description',
                textStyle: whiteBoldStyle(size: 25),
              ),
            ),
          ),
          body: AuthLoadingStack(
            isLoading: state.isSubmitting,
            children: [
              RegisterAuthBackground(
                child: SafeArea(
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Gap(20),
                          Center(
                            child: GestureDetector(
                              onTap: pickImage,
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 56,
                                    backgroundColor:
                                        AppColors.electricLavender,
                                    backgroundImage:
                                        selectedImagePath.value != null
                                            ? FileImage(
                                                File(selectedImagePath.value!),
                                              )
                                            : profileImageURL.isNotEmpty
                                                ? NetworkImage(
                                                    profileImageURL,
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
                          _profileTabs(
                            screenHeight: screenHeight,
                            profileTab: _profileTab(
                              context,
                              firstNameCtrl: firstNameCtrl,
                              lastNameCtrl: lastNameCtrl,
                              ageCtrl: ageCtrl,
                              heightCtrl: heightCtrl,
                              weightCtrl: weightCtrl,
                              sex: sex,
                            ),
                            workoutTab: _workoutTab(
                              workoutExperience: workoutExperience,
                              workoutFreqCtrl: workoutFreqCtrl,
                              sleepHoursCtrl: sleepHoursCtrl,
                              workoutAvailabilityCtrl: workoutAvailabilityCtrl,
                              bodyConcern: bodyConcern,
                              muscleGoal: muscleGoal,
                              dedicationSpan: dedicationSpan,
                              specialPlansCtrl: specialPlansCtrl,
                            ),
                            healthTab: _healthTab(
                              illnessesCtrl: illnessesCtrl,
                              allergiesCtrl: allergiesCtrl,
                              injuriesCtrl: injuriesCtrl,
                              medicationsCtrl: medicationsCtrl,
                              steroidsCtrl: steroidsCtrl,
                              foodDiet: foodDiet,
                              recentlyDoctored: recentlyDoctored,
                            ),
                          ),
                          const Gap(20),
                          AuthGradientButton(
                            label: 'CONFIRM CHANGES',
                            width: 250,
                            onTap: state.isSubmitting ? () {} : onSave,
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
      ),
    );
  }

  Widget _profileTabs({
    required double screenHeight,
    required Widget profileTab,
    required Widget workoutTab,
    required Widget healthTab,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: roundedContainer(
        width: double.infinity,
        height: screenHeight * 0.55,
        color: AppColors.love.withValues(alpha: 0.4),
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(
                  child: fitnesscoText(
                    'PROFILE',
                    textStyle: blackBoldStyle(size: 10),
                  ),
                ),
                Tab(
                  child: fitnesscoText(
                    'WORKOUT',
                    textStyle: blackBoldStyle(size: 10),
                  ),
                ),
                Tab(
                  child: fitnesscoText(
                    'HEALTH',
                    textStyle: blackBoldStyle(size: 10),
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [profileTab, workoutTab, healthTab],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileTab(
    BuildContext context, {
    required TextEditingController firstNameCtrl,
    required TextEditingController lastNameCtrl,
    required TextEditingController ageCtrl,
    required TextEditingController heightCtrl,
    required TextEditingController weightCtrl,
    required ValueNotifier<String> sex,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          fitnesscoText('FIRST NAME', textStyle: blackBoldStyle(size: 12)),
          SizedBox(
            height: 36,
            child: fitnesscoFormTextField(
              'First Name',
              TextInputType.name,
              firstNameCtrl,
            ),
          ),
          const Gap(20),
          fitnesscoText('LAST NAME', textStyle: blackBoldStyle(size: 12)),
          SizedBox(
            height: 36,
            child: fitnesscoFormTextField(
              'Last Name',
              TextInputType.name,
              lastNameCtrl,
            ),
          ),
          const Gap(20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    fitnesscoText('SEX', textStyle: blackBoldStyle(size: 12)),
                    _buildDropdown<String>(
                      label: 'Sex',
                      value: sex.value,
                      items: SexOptions.options,
                      onChanged: (v) {
                        if (v != null) sex.value = v;
                      },
                    ),
                  ],
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    fitnesscoText('AGE', textStyle: blackBoldStyle(size: 12)),
                    SizedBox(
                      height: 36,
                      child: fitnesscoFormTextField(
                        'Age',
                        TextInputType.number,
                        ageCtrl,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    fitnesscoText('HEIGHT', textStyle: blackBoldStyle(size: 12)),
                    SizedBox(
                      height: 36,
                      child: fitnesscoFormTextField(
                        'Height (cm)',
                        TextInputType.number,
                        heightCtrl,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    fitnesscoText('WEIGHT', textStyle: blackBoldStyle(size: 12)),
                    SizedBox(
                      height: 36,
                      child: fitnesscoFormTextField(
                        'Weight (kg)',
                        TextInputType.number,
                        weightCtrl,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _workoutTab({
    required ValueNotifier<String> workoutExperience,
    required TextEditingController workoutFreqCtrl,
    required TextEditingController sleepHoursCtrl,
    required TextEditingController workoutAvailabilityCtrl,
    required ValueNotifier<String> bodyConcern,
    required ValueNotifier<String> muscleGoal,
    required ValueNotifier<String> dedicationSpan,
    required TextEditingController specialPlansCtrl,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          fitnesscoText(
            'WORKOUT EXPERIENCE',
            textStyle: blackBoldStyle(size: 12),
          ),
          _buildDropdown<String>(
            label: 'Workout Experience',
            value: workoutExperience.value,
            items: _dropdownItems(
              workoutExperience.value,
              _workoutExperiences,
            ),
            onChanged: (v) {
              if (v != null) workoutExperience.value = v;
            },
          ),
          const Gap(12),
          fitnesscoText(
            'WORKOUT FREQUENCY',
            textStyle: blackBoldStyle(size: 12),
          ),
          SizedBox(
            height: 36,
            child: fitnesscoFormTextField(
              'Days per week',
              TextInputType.number,
              workoutFreqCtrl,
            ),
          ),
          const Gap(12),
          fitnesscoText(
            'NORMAL SLEEP HOURS',
            textStyle: blackBoldStyle(size: 12),
          ),
          SizedBox(
            height: 36,
            child: fitnesscoFormTextField(
              'Hours per day',
              TextInputType.number,
              sleepHoursCtrl,
            ),
          ),
          const Gap(12),
          fitnesscoText(
            'WORKOUT AVAILABILITY',
            textStyle: blackBoldStyle(size: 12),
          ),
          SizedBox(
            height: 36,
            child: fitnesscoFormTextField(
              'Availability',
              TextInputType.text,
              workoutAvailabilityCtrl,
            ),
          ),
          const Gap(16),
          fitnesscoText(
            'What is your body concern?',
            textStyle: blackBoldStyle(size: 12),
          ),
          _buildDropdown<String>(
            label: 'Body Concern',
            value: bodyConcern.value,
            items: _dropdownItems(bodyConcern.value, _bodyConcernChoices),
            onChanged: (v) {
              if (v != null) bodyConcern.value = v;
            },
          ),
          const Gap(12),
          fitnesscoText(
            'What part of the muscle or body do you want to improve?',
            textStyle: blackBoldStyle(size: 12),
          ),
          _buildDropdown<String>(
            label: 'Muscle Goal',
            value: muscleGoal.value,
            items: _dropdownItems(muscleGoal.value, _muscleGoalChoices),
            onChanged: (v) {
              if (v != null) muscleGoal.value = v;
            },
          ),
          const Gap(12),
          fitnesscoText(
            'How much time are you willing to dedicate for fitness?',
            textStyle: blackBoldStyle(size: 12),
          ),
          _buildDropdown<String>(
            label: 'Dedication Span',
            value: dedicationSpan.value,
            items: _dropdownItems(
              dedicationSpan.value,
              _dedicationSpanChoices,
            ),
            onChanged: (v) {
              if (v != null) dedicationSpan.value = v;
            },
          ),
          const Gap(12),
          fitnesscoText(
            'Elaborate some specific body plans for your trainer',
            textStyle: blackBoldStyle(size: 12),
          ),
          const Gap(8),
          fitnesscoFormTextField(
            'Special plans',
            TextInputType.multiline,
            specialPlansCtrl,
          ),
        ],
      ),
    );
  }

  Widget _healthTab({
    required TextEditingController illnessesCtrl,
    required TextEditingController allergiesCtrl,
    required TextEditingController injuriesCtrl,
    required TextEditingController medicationsCtrl,
    required TextEditingController steroidsCtrl,
    required ValueNotifier<String> foodDiet,
    required ValueNotifier<bool> recentlyDoctored,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    fitnesscoText(
                      'HAVE ILLNESSES?',
                      textStyle: blackBoldStyle(size: 12),
                    ),
                    SizedBox(
                      height: 36,
                      child: fitnesscoFormTextField(
                        '',
                        TextInputType.text,
                        illnessesCtrl,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    fitnesscoText(
                      'ANY ALLERGIES?',
                      textStyle: blackBoldStyle(size: 12),
                    ),
                    SizedBox(
                      height: 36,
                      child: fitnesscoFormTextField(
                        '',
                        TextInputType.text,
                        allergiesCtrl,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          CheckboxListTile(
            value: recentlyDoctored.value,
            onChanged: (value) => recentlyDoctored.value = value ?? false,
            title: fitnesscoText(
              'Went to a doctor in the last 15-30 days?',
              textStyle: blackBoldStyle(size: 13),
            ),
            contentPadding: EdgeInsets.zero,
            activeColor: AppColors.purpleSnail,
          ),
          fitnesscoText(
            'ANY PAST OR CURRENT INJURIES?',
            textStyle: blackBoldStyle(size: 12),
          ),
          SizedBox(
            height: 36,
            child: fitnesscoFormTextField(
              'Injuries',
              TextInputType.text,
              injuriesCtrl,
            ),
          ),
          const Gap(12),
          fitnesscoText(
            'TAKING SOME MEDICATIONS NOW?',
            textStyle: blackBoldStyle(size: 12),
          ),
          SizedBox(
            height: 36,
            child: fitnesscoFormTextField(
              '',
              TextInputType.text,
              medicationsCtrl,
            ),
          ),
          const Gap(12),
          fitnesscoText(
            'HAVE TAKEN SOME GYM-DRUG RELATED SUBSTANCE?',
            textStyle: blackBoldStyle(size: 12),
          ),
          SizedBox(
            height: 36,
            child: fitnesscoFormTextField(
              '',
              TextInputType.text,
              steroidsCtrl,
            ),
          ),
          const Gap(12),
          fitnesscoText(
            'What is your current food diet?',
            textStyle: blackBoldStyle(size: 12),
          ),
          _buildDropdown<String>(
            label: 'Food Diet',
            value: foodDiet.value,
            items: _dropdownItems(foodDiet.value, _dietChoices),
            onChanged: (v) {
              if (v != null) foodDiet.value = v;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    required void Function(T?) onChanged,
  }) {
    final selected = items.contains(value) ? value : items.first;

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
}
