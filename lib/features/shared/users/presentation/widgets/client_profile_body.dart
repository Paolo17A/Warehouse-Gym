import 'package:the_warehouse_gym/core/constants/app_colors.dart';
import 'package:gap/gap.dart';
import 'package:the_warehouse_gym/core/widgets/fitnessco_ui.dart';
import 'package:the_warehouse_gym/features/client/bmi/domain/utils/bmi_calculator.dart';
import 'package:the_warehouse_gym/features/shared/account/domain/entities/full_user.dart';
import 'package:the_warehouse_gym/features/shared/account/domain/entities/user_profile.dart';
import 'package:flutter/material.dart';

class ClientProfileBody extends StatelessWidget {
  final FullUser user;

  const ClientProfileBody({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final profile = user.clientProfile;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: profile != null
                ? _clientGeneralData(context, user, profile)
                : Column(
                    children: [
                      clientProfileImage(user.profileImageURL),
                      const Gap(8),
                    ],
                  ),
          ),
          const Gap(24),
          if (profile != null) ...[
            _personalDetailsSection(profile),
            const Gap(16),
            _workoutProfileSection(profile),
            const Gap(16),
            _healthInformationSection(profile),
          ],
          const Gap(24),
        ],
      ),
    );
  }

  Widget _clientGeneralData(
    BuildContext context,
    FullUser user,
    UserProfile profile,
  ) {
    final currentBmi = _resolveCurrentBmi(user);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Column(
              children: [
                clientProfileImage(user.profileImageURL),
                const Gap(15),
                Text(
                  currentBmi > 0 ? currentBmi.toStringAsFixed(2) : '—',
                  style: const TextStyle(
                    fontSize: 35,
                    color: AppColors.nearMoon,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                fitnesscoText(
                  'CURRENT BMI',
                  textStyle: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Column(
              children: [
                fitnesscoText(
                  '${profile.firstName} ${profile.lastName}',
                  textStyle: blackBoldStyle(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    fitnesscoText(
                      'Age: ${profile.age}',
                      textStyle: greyBoldStyle(size: 15),
                    ),
                    const Gap(10),
                    fitnesscoText(
                      profile.sex,
                      textStyle: const TextStyle(
                        color: AppColors.nearMoon,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const Gap(20),
                fitnesscoText('Height: ${profile.height} cm'),
                fitnesscoText('Weight: ${profile.weight} kg'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _resolveCurrentBmi(FullUser user) {
    if (user.bmiHistory.isNotEmpty) {
      return (user.bmiHistory.last['bmiValue'] as num?)?.toDouble() ?? 0;
    }
    final profile = user.clientProfile;
    if (profile == null) return 0;
    return BmiCalculator.fromMetric(
      heightCm: profile.height,
      weightKg: profile.weight,
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

  Widget _personalDetailsSection(UserProfile profile) {
    return roundedContainer(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader('Personal Details'),
            const Gap(12),
            _infoGrid([
              _InfoItem('Age', '${profile.age} yrs'),
              _InfoItem('Sex', profile.sex),
              _InfoItem('Height', '${profile.height} cm'),
              _InfoItem('Weight', '${profile.weight} kg'),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _workoutProfileSection(UserProfile profile) {
    return roundedContainer(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader('Workout Profile'),
            const Gap(12),
            _infoGrid([
              _InfoItem('Experience', profile.workoutExperience),
              _InfoItem('Availability', profile.workoutAvailability),
              _InfoItem('Frequency', '${profile.workoutFrequency}x/week'),
              _InfoItem('Sleep', '${profile.sleepHours} hrs/day'),
            ]),
            if (profile.muscleGoal.isNotEmpty) ...[
              const Gap(12),
              _infoRow('Muscle Goal', profile.muscleGoal),
            ],
            if (profile.bodyConcerns.isNotEmpty) ...[
              const Gap(8),
              _infoRow('Body Concerns', profile.bodyConcerns),
            ],
            if (profile.dedicationSpan.isNotEmpty) ...[
              const Gap(8),
              _infoRow('Dedication Span', profile.dedicationSpan),
            ],
          ],
        ),
      ),
    );
  }

  Widget _healthInformationSection(UserProfile profile) {
    return roundedContainer(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader('Health Information'),
            const Gap(12),
            if (profile.illnesses.isNotEmpty)
              _infoRow('Illnesses', profile.illnesses),
            if (profile.allergies.isNotEmpty)
              _infoRow('Allergies', profile.allergies),
            if (profile.injuries.isNotEmpty)
              _infoRow('Injuries', profile.injuries),
            if (profile.medications.isNotEmpty)
              _infoRow('Medications', profile.medications),
            if (profile.foodDiet.isNotEmpty)
              _infoRow('Food Diet', profile.foodDiet),
            _infoRow(
              'Recently Doctored',
              profile.recentlyDoctored ? 'Yes' : 'No',
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoGrid(List<_InfoItem> items) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 3,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      children: items
          .map(
            (item) => Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.electricLavender.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  fitnesscoText(
                    item.label,
                    textStyle: greyBoldStyle(size: 11),
                  ),
                  fitnesscoText(
                    item.value,
                    textStyle: blackBoldStyle(size: 14),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: fitnesscoText(
              label,
              textStyle: greyBoldStyle(size: 14),
            ),
          ),
          Expanded(
            child: fitnesscoText(
              value,
              textStyle: blackBoldStyle(size: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem {
  final String label;
  final String value;

  const _InfoItem(this.label, this.value);
}
