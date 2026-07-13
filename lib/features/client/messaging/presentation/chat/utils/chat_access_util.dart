/// Resolves trainer-client relationship fields from v2 nested and v1 root user docs.
class ChatAccessUtil {
  const ChatAccessUtil._();

  static String resolveCurrentTrainer(Map<String, dynamic> userData) {
    final rel = userData['trainerRelationship'] as Map<String, dynamic>? ?? {};
    final nested = rel['currentTrainer'] as String? ?? '';
    if (nested.trim().isNotEmpty) return nested.trim();
    return (userData['currentTrainer'] as String? ?? '').trim();
  }

  static bool isConfirmedWithTrainer(Map<String, dynamic> userData) {
    final rel = userData['trainerRelationship'] as Map<String, dynamic>? ?? {};
    if (rel['isConfirmed'] == true) return true;
    return userData['isConfirmed'] == true;
  }

  static List<String> resolveCurrentClients(Map<String, dynamic> trainerData) {
    final rel = trainerData['trainerRelationship'] as Map<String, dynamic>?;
    final nested = rel?['currentClients'];
    if (nested is List) {
      return nested.map((e) => e.toString()).toList();
    }
    final root = trainerData['currentClients'];
    if (root is List) {
      return root.map((e) => e.toString()).toList();
    }
    return const [];
  }

  /// Trainer may message when the client lists them as trainer, or when the
  /// client is on the trainer's confirmed client list (My Clients source).
  static bool trainerCanMessageClient({
    required Map<String, dynamic> clientData,
    required String clientUid,
    required String trainerUid,
    required List<String> trainerCurrentClients,
  }) {
    if (resolveCurrentTrainer(clientData) == trainerUid) return true;
    return trainerCurrentClients.contains(clientUid);
  }
}
