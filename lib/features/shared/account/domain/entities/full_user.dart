import 'package:the_warehouse_gym/features/shared/account/domain/entities/trainer_profile.dart';
import 'package:the_warehouse_gym/features/shared/account/domain/entities/trainer_relationship.dart';
import 'package:the_warehouse_gym/features/shared/account/domain/entities/user_profile.dart';

class FullUser {
  final String uid;
  final String email;
  final String accountType;
  final String profileImageURL;
  final String password;
  final String firstName;
  final String lastName;
  final UserProfile? clientProfile;
  final TrainerProfile? trainerProfile;
  final TrainerRelationship trainerRelationship;
  final List<dynamic> bmiHistory;

  const FullUser({
    required this.uid,
    required this.email,
    required this.accountType,
    required this.profileImageURL,
    required this.password,
    this.firstName = '',
    this.lastName = '',
    this.clientProfile,
    this.trainerProfile,
    required this.trainerRelationship,
    required this.bmiHistory,
  });

  bool get isClient => accountType.toUpperCase() == 'CLIENT';
  bool get isTrainer => accountType.toUpperCase() == 'TRAINER';
  bool get isAdmin => accountType.toUpperCase() == 'ADMIN';

  String get fullName {
    if (firstName.isNotEmpty || lastName.isNotEmpty) {
      return '$firstName $lastName'.trim();
    }
    if (clientProfile != null) {
      return '${clientProfile!.firstName} ${clientProfile!.lastName}'.trim();
    }
    return email;
  }
}
