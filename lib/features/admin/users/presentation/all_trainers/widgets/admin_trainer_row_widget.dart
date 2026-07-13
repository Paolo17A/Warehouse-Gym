import 'package:the_warehouse_gym/core/widgets/fitnessco_ui.dart';
import 'package:flutter/material.dart';

class AdminTrainerRow extends StatelessWidget {
  final Map<String, dynamic> trainer;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const AdminTrainerRow({
    super.key,
    required this.trainer,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final firstName = trainer['firstName'] as String? ?? '';
    final lastName = trainer['lastName'] as String? ?? '';
    final profileImageURL = trainer['profileImageURL'] as String? ?? '';
    final currentClients = trainer['currentClients'] is List
        ? trainer['currentClients'] as List
        : <dynamic>[];
    final profileDetails =
        trainer['profileDetails'] as Map<String, dynamic>? ?? {};
    final sex = profileDetails['sex'] as String? ?? '';
    final age = profileDetails['age'] ?? 0;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onDelete,
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
