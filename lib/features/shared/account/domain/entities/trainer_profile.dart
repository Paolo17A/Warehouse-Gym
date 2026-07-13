class TrainerProfile {
  final String sex;
  final String age;
  final String contactNumber;
  final String address;
  final List<String> certifications;
  final List<String> interests;
  final List<String> specialty;

  const TrainerProfile({
    required this.sex,
    required this.age,
    required this.contactNumber,
    required this.address,
    required this.certifications,
    required this.interests,
    required this.specialty,
  });

  TrainerProfile copyWith({
    String? sex,
    String? age,
    String? contactNumber,
    String? address,
    List<String>? certifications,
    List<String>? interests,
    List<String>? specialty,
  }) {
    return TrainerProfile(
      sex: sex ?? this.sex,
      age: age ?? this.age,
      contactNumber: contactNumber ?? this.contactNumber,
      address: address ?? this.address,
      certifications: certifications ?? this.certifications,
      interests: interests ?? this.interests,
      specialty: specialty ?? this.specialty,
    );
  }
}
