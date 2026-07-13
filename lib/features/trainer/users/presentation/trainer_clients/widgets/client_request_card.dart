import 'package:the_warehouse_gym/core/constants/app_colors.dart';
import 'package:the_warehouse_gym/core/router/app_router.dart';
import 'package:the_warehouse_gym/core/widgets/fitnessco_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ClientRequestCard extends StatelessWidget {
  final String clientUid;
  final String firstName;
  final String lastName;
  final String profileImageURL;
  final VoidCallback onApprove;
  final VoidCallback onDeny;

  const ClientRequestCard({
    super.key,
    required this.clientUid,
    required this.firstName,
    required this.lastName,
    required this.profileImageURL,
    required this.onApprove,
    required this.onDeny,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.love,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: SizedBox(
          height: 80,
          child: Row(
            children: [
              buildProfileImage(profileImageURL: profileImageURL, radius: 50),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: fitnesscoText(
                            '$firstName $lastName',
                            textStyle: greyBoldStyle(size: 14),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => context.push(
                            AppRouter.trainerSelectedClient(clientUid),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: fitnesscoText(
                            'View Profile',
                            textStyle: blackBoldStyle(size: 12),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 30,
                          child: ElevatedButton(
                            onPressed: onApprove,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: fitnesscoText(
                              'ACCEPT',
                              textStyle: blackBoldStyle(size: 12),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          child: ElevatedButton(
                            onPressed: onDeny,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: fitnesscoText(
                              'DENY',
                              textStyle: blackBoldStyle(size: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
