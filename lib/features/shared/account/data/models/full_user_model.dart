import 'package:the_warehouse_gym/core/constants/sex_options.dart';
import 'package:the_warehouse_gym/features/shared/account/domain/entities/full_user.dart';
import 'package:the_warehouse_gym/features/shared/account/domain/entities/trainer_profile.dart';
import 'package:the_warehouse_gym/features/shared/account/domain/entities/trainer_relationship.dart';
import 'package:the_warehouse_gym/features/shared/account/domain/entities/user_profile.dart';

class FullUserModel {
  final String uid;
  final String email;
  final String accountType;
  final String profileImageURL;
  final String password;
  final Map<String, dynamic> rootData;
  final Map<String, dynamic>? profileDetails;
  final Map<String, dynamic>? trainerProfileData;
  final Map<String, dynamic>? trainerRelationshipData;
  final List<dynamic> bmiHistory;

  const FullUserModel({
    required this.uid,
    required this.email,
    required this.accountType,
    required this.profileImageURL,
    required this.password,
    required this.rootData,
    this.profileDetails,
    this.trainerProfileData,
    this.trainerRelationshipData,
    required this.bmiHistory,
  });

  factory FullUserModel.fromJson(Map<String, dynamic> data) {
    final uid = data['uid']?.toString() ?? data['id']?.toString() ?? '';
    return FullUserModel(
      uid: uid,
      email: data['email']?.toString() ?? '',
      accountType: data['accountType']?.toString() ?? 'CLIENT',
      profileImageURL: data['profileImageURL']?.toString() ?? '',
      password: data['password']?.toString() ?? '',
      rootData: Map<String, dynamic>.from(data),
      profileDetails: _asMap(data['profileDetails']),
      trainerProfileData: _asMap(data['trainerProfile']),
      trainerRelationshipData: _asMap(data['trainerRelationship']),
      bmiHistory: data['bmiHistory'] is List ? data['bmiHistory'] as List : [],
    );
  }

  static Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  factory FullUserModel.fromFirestore(dynamic doc) {
    throw UnsupportedError('Firestore is no longer supported.');
  }

  FullUser toEntity() {
    final isTrainer = accountType.toUpperCase() == 'TRAINER';
    final firstName = _resolveFirstName();
    final lastName = _resolveLastName();

    return FullUser(
      uid: uid,
      email: email,
      accountType: accountType,
      profileImageURL: profileImageURL,
      password: password,
      firstName: firstName,
      lastName: lastName,
      clientProfile: !isTrainer && profileDetails != null
          ? _parseClientProfile(profileDetails!)
          : null,
      trainerProfile: isTrainer
          ? _parseTrainerProfile(
              trainerProfileData ?? profileDetails ?? const {},
            )
          : trainerProfileData != null
              ? _parseTrainerProfile(trainerProfileData!)
              : null,
      trainerRelationship: _resolveTrainerRelationship(
        nested: trainerRelationshipData,
        root: rootData,
      ),
      bmiHistory: bmiHistory,
    );
  }

  String _resolveFirstName() {
    final rootName = _stringValue(rootData['firstName']);
    if (rootName.isNotEmpty) return rootName;
    return _stringValue(profileDetails?['firstName']);
  }

  String _resolveLastName() {
    final rootName = _stringValue(rootData['lastName']);
    if (rootName.isNotEmpty) return rootName;
    return _stringValue(profileDetails?['lastName']);
  }

  static String _stringValue(dynamic value) {
    if (value == null) return '';
    if (value is Map) {
      final id = value['uid'] ?? value['id'] ?? value['_id'] ?? value['\$oid'];
      if (id != null) return id.toString();
    }
    return value.toString();
  }

  static int _intValue(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double _doubleValue(dynamic value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static bool _boolValue(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      return normalized == 'true' || normalized == '1' || normalized == 'yes';
    }
    return false;
  }

  static List<String> _stringList(dynamic value) {
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }
    return const [];
  }

  static UserProfile _parseClientProfile(Map<String, dynamic> data) {
    return UserProfile(
      firstName: _stringValue(data['firstName']),
      lastName: _stringValue(data['lastName']),
      age: _intValue(data['age']),
      sex: SexOptions.normalize(_stringValue(data['sex'])),
      height: _doubleValue(data['height']),
      weight: _doubleValue(data['weight']),
      workoutExperience: _stringValue(data['workoutExperience']),
      workoutAvailability: _stringValue(data['workoutAvailability']),
      workoutFrequency: _intValue(data['workoutFrequency']),
      sleepHours: _intValue(data['sleepHours']),
      illnesses: _stringValue(data['illnesses']),
      allergies: _stringValue(data['allergies']),
      injuries: _stringValue(data['injuries']),
      medications: _stringValue(data['medications']),
      steroids: _stringValue(data['steroids']),
      foodDiet: _stringValue(data['foodDiet']),
      bodyConcerns: _stringValue(data['bodyConcerns']),
      muscleGoal: _stringValue(data['muscleGoal']),
      dedicationSpan: _stringValue(data['dedicationSpan']),
      specialPlans: _stringValue(data['specialPlans']),
      recentlyDoctored: _boolValue(data['recentlyDoctored']),
    );
  }

  static TrainerProfile _parseTrainerProfile(Map<String, dynamic> data) {
    return TrainerProfile(
      sex: SexOptions.normalize(_stringValue(data['sex'])),
      age: _stringValue(data['age']),
      contactNumber: _stringValue(data['contactNumber']),
      address: _stringValue(data['address']),
      certifications: _stringList(data['certifications']),
      interests: _stringList(data['interests']),
      specialty: _stringList(data['specialty']),
    );
  }

  static TrainerRelationship _resolveTrainerRelationship({
    Map<String, dynamic>? nested,
    required Map<String, dynamic> root,
  }) {
    final nestedMap = nested ?? const <String, dynamic>{};

    dynamic pick(String key) {
      if (nestedMap.containsKey(key)) return nestedMap[key];
      return root[key];
    }

    return TrainerRelationship(
      currentTrainer: _stringValue(pick('currentTrainer')),
      isConfirmed: _boolValue(pick('isConfirmed')),
      currentClients: _stringList(pick('currentClients')),
    );
  }
}
