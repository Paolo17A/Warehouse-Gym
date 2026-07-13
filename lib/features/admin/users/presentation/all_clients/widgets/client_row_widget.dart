import 'package:flutter/material.dart';

import '../../../../../../core/widgets/fitnessco_ui.dart';

class ClientRow extends StatelessWidget {
  final Map<String, dynamic> client;
  final VoidCallback onTap;

  const ClientRow({super.key, required this.client, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final firstName = client['firstName'] as String? ?? '';
    final lastName = client['lastName'] as String? ?? '';
    final profileImageURL = client['profileImageURL'] as String? ?? '';
    final profileDetails =
        client['profileDetails'] as Map<String, dynamic>? ?? {};
    final sex = profileDetails['sex'] as String? ?? '';
    final age = profileDetails['age'] ?? 0;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                clientProfileImage(profileImageURL),
                clientProfileContent(
                  context,
                  firstName,
                  lastName,
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
