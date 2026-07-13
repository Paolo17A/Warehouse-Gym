import 'package:the_warehouse_gym/features/shared/auth/domain/entities/app_user.dart';

class UserModel {
  final String uid;
  final String email;
  final String accountType;
  final bool accountInitialized;
  final String profileImageURL;

  const UserModel({
    required this.uid,
    required this.email,
    required this.accountType,
    required this.accountInitialized,
    required this.profileImageURL,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final uid = json['uid'] as String? ?? json['id'] as String? ?? '';
    return UserModel(
      uid: uid,
      email: json['email'] as String? ?? '',
      accountType: (json['accountType'] as String? ?? 'CLIENT').toUpperCase(),
      accountInitialized: json['accountInitialized'] as bool? ?? false,
      profileImageURL: json['profileImageURL'] as String? ?? '',
    );
  }

  factory UserModel.fromFirestore(dynamic doc) {
    throw UnsupportedError('Firestore is no longer supported.');
  }

  AppUser toEntity() {
    return AppUser(
      uid: uid,
      email: email,
      accountType: accountType,
      accountInitialized: accountInitialized,
      profileImageURL: profileImageURL,
    );
  }
}
