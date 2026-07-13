import 'package:the_warehouse_gym/core/constants/app_colors.dart';
import 'package:gap/gap.dart';
import 'package:the_warehouse_gym/core/widgets/fitnessco_ui.dart';
import 'package:the_warehouse_gym/features/shared/account/domain/entities/full_user.dart';
import 'package:flutter/material.dart';

class TrainerProfileBody extends StatelessWidget {
  final FullUser user;
  final Color? containerBorderColor;

  const TrainerProfileBody({
    super.key,
    required this.user,
    this.containerBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    final trainerProfile = user.trainerProfile;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                trainerProfileImage(user.profileImageURL),
                const Gap(12),
                fitnesscoText(
                  user.fullName,
                  textStyle: const TextStyle(
                    color: AppColors.purpleSnail,
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                  ),
                ),
                if (trainerProfile != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      fitnesscoText(
                        trainerProfile.sex,
                        textStyle: blackBoldStyle(size: 13),
                      ),
                      const Gap(10),
                      fitnesscoText(
                        '${trainerProfile.age} years old',
                      ),
                    ],
                  ),
                  fitnesscoText(
                    '${user.trainerRelationship.currentClients.length} Clients',
                    textStyle: blackBoldStyle(size: 15),
                  ),
                ],
                const Gap(4),
                fitnesscoText(
                  user.email,
                  textStyle: greyBoldStyle(size: 14),
                ),
              ],
            ),
          ),
          const Gap(24),
          if (trainerProfile != null) ...[
            roundedContainer(
              color: Colors.white,
              borderColor: containerBorderColor,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionHeader('Basic Information'),
                    const Gap(12),
                    _infoRow('Sex', trainerProfile.sex),
                    _infoRow('Age', trainerProfile.age),
                    _infoRow('Contact', trainerProfile.contactNumber),
                    _infoRow('Address', trainerProfile.address),
                  ],
                ),
              ),
            ),
            if (trainerProfile.specialty.isNotEmpty) ...[
              const Gap(16),
              roundedContainer(
                color: Colors.white,
                borderColor: containerBorderColor,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionHeader('Specialty'),
                      const Gap(8),
                      _chipList(
                          trainerProfile.specialty, AppColors.purpleSnail),
                    ],
                  ),
                ),
              ),
            ],
            if (trainerProfile.certifications.isNotEmpty) ...[
              const Gap(16),
              roundedContainer(
                color: Colors.white,
                borderColor: containerBorderColor,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionHeader('Certifications'),
                      const Gap(8),
                      _chipList(trainerProfile.certifications, Colors.teal),
                    ],
                  ),
                ),
              ),
            ],
            if (trainerProfile.interests.isNotEmpty) ...[
              const Gap(16),
              roundedContainer(
                color: Colors.white,
                borderColor: containerBorderColor,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionHeader('Interests'),
                      const Gap(8),
                      _chipList(trainerProfile.interests, Colors.blueGrey),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ],
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

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: fitnesscoText(
              label,
              textStyle: greyBoldStyle(size: 14),
            ),
          ),
          Expanded(
            child: fitnesscoText(
              value.isNotEmpty ? value : '—',
              textStyle: blackBoldStyle(size: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chipList(List<String> items, Color color) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: items
          .map(
            (item) => Chip(
              label: fitnesscoText(
                item,
                textStyle: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
              backgroundColor: color.withValues(alpha: 0.1),
              side: BorderSide(color: color.withValues(alpha: 0.3)),
            ),
          )
          .toList(),
    );
  }
}
