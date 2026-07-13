class UserProfile {
  final String firstName;
  final String lastName;
  final int age;
  final String sex;
  final double height;
  final double weight;
  final String workoutExperience;
  final String workoutAvailability;
  final int workoutFrequency;
  final int sleepHours;
  final String illnesses;
  final String allergies;
  final String injuries;
  final String medications;
  final String steroids;
  final String foodDiet;
  final String bodyConcerns;
  final String muscleGoal;
  final String dedicationSpan;
  final String specialPlans;
  final bool recentlyDoctored;

  const UserProfile({
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.sex,
    required this.height,
    required this.weight,
    required this.workoutExperience,
    required this.workoutAvailability,
    required this.workoutFrequency,
    required this.sleepHours,
    required this.illnesses,
    required this.allergies,
    required this.injuries,
    required this.medications,
    required this.steroids,
    required this.foodDiet,
    required this.bodyConcerns,
    required this.muscleGoal,
    required this.dedicationSpan,
    required this.specialPlans,
    required this.recentlyDoctored,
  });

  UserProfile copyWith({
    String? firstName,
    String? lastName,
    int? age,
    String? sex,
    double? height,
    double? weight,
    String? workoutExperience,
    String? workoutAvailability,
    int? workoutFrequency,
    int? sleepHours,
    String? illnesses,
    String? allergies,
    String? injuries,
    String? medications,
    String? steroids,
    String? foodDiet,
    String? bodyConcerns,
    String? muscleGoal,
    String? dedicationSpan,
    String? specialPlans,
    bool? recentlyDoctored,
  }) {
    return UserProfile(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      age: age ?? this.age,
      sex: sex ?? this.sex,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      workoutExperience: workoutExperience ?? this.workoutExperience,
      workoutAvailability: workoutAvailability ?? this.workoutAvailability,
      workoutFrequency: workoutFrequency ?? this.workoutFrequency,
      sleepHours: sleepHours ?? this.sleepHours,
      illnesses: illnesses ?? this.illnesses,
      allergies: allergies ?? this.allergies,
      injuries: injuries ?? this.injuries,
      medications: medications ?? this.medications,
      steroids: steroids ?? this.steroids,
      foodDiet: foodDiet ?? this.foodDiet,
      bodyConcerns: bodyConcerns ?? this.bodyConcerns,
      muscleGoal: muscleGoal ?? this.muscleGoal,
      dedicationSpan: dedicationSpan ?? this.dedicationSpan,
      specialPlans: specialPlans ?? this.specialPlans,
      recentlyDoctored: recentlyDoctored ?? this.recentlyDoctored,
    );
  }
}
