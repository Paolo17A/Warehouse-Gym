class ChatParticipants {
  final String trainerUid;
  final String clientUid;

  const ChatParticipants({
    required this.trainerUid,
    required this.clientUid,
  });

  static ChatParticipants fromViewer(
    String currentUid,
    String otherUid, {
    required bool isClientView,
  }) {
    return ChatParticipants(
      trainerUid: isClientView ? otherUid : currentUid,
      clientUid: isClientView ? currentUid : otherUid,
    );
  }
}
