import 'package:the_warehouse_gym/core/constants/app_colors.dart';
import 'package:the_warehouse_gym/core/router/app_router.dart';
import 'package:the_warehouse_gym/core/widgets/fitnessco_ui.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CurrentClientCard extends StatelessWidget {
  final String clientUid;
  final String firstName;
  final String lastName;
  final String profileImageURL;
  final VoidCallback onRemove;

  const CurrentClientCard({
    super.key,
    required this.clientUid,
    required this.firstName,
    required this.lastName,
    required this.profileImageURL,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final name = '$firstName $lastName'.trim();

    void openProfile() {
      context.push(AppRouter.trainerSelectedClient(clientUid));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: openProfile,
                child: buildProfileImage(
                  profileImageURL: profileImageURL,
                  radius: 32,
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: openProfile,
                      borderRadius: BorderRadius.circular(4),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          name.isEmpty ? 'Unknown Client' : name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    const Gap(10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _ClientActionButton(
                          label: 'Message',
                          backgroundColor: AppColors.jigglypuff,
                          foregroundColor: Colors.black87,
                          onPressed: () => context.push(
                            AppRouter.chat(
                              clientUid,
                              name: name.isEmpty ? null : name,
                              isClient: false,
                            ),
                          ),
                        ),
                        _ClientActionButton(
                          label: 'Workouts',
                          backgroundColor: AppColors.jigglypuff,
                          foregroundColor: Colors.white,
                          onPressed: () =>
                              context.push(AppRouter.prescribeWorkout(clientUid)),
                        ),
                        _ClientActionButton(
                          label: 'Remove',
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.red,
                          borderColor: Colors.red.withValues(alpha: 0.5),
                          onPressed: onRemove,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(10),
          const Divider(thickness: 1.5, height: 1),
        ],
      ),
    );
  }
}

class _ClientActionButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;
  final VoidCallback onPressed;

  const _ClientActionButton({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: borderColor != null
                ? BorderSide(color: borderColor!)
                : BorderSide.none,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: foregroundColor,
          ),
        ),
      ),
    );
  }
}
