class TrainerRelationship {
  final String currentTrainer;
  final bool isConfirmed;
  final List<String> currentClients;

  const TrainerRelationship({
    required this.currentTrainer,
    required this.isConfirmed,
    required this.currentClients,
  });

  bool get hasTrainer => currentTrainer.isNotEmpty;

  TrainerRelationship copyWith({
    String? currentTrainer,
    bool? isConfirmed,
    List<String>? currentClients,
  }) {
    return TrainerRelationship(
      currentTrainer: currentTrainer ?? this.currentTrainer,
      isConfirmed: isConfirmed ?? this.isConfirmed,
      currentClients: currentClients ?? this.currentClients,
    );
  }
}
