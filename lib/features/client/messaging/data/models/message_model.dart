import 'package:the_warehouse_gym/features/client/messaging/data/services/chat_participants.dart';
import 'package:the_warehouse_gym/features/client/messaging/domain/entities/message.dart';

class MessageModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;

  const MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
  });

  factory MessageModel.fromSocketJson(Map<String, dynamic> data) {
    final ts = data['timestamp'];
    DateTime parsedTimestamp;
    if (ts is String && ts.isNotEmpty) {
      parsedTimestamp = DateTime.tryParse(ts) ?? DateTime.now();
    } else {
      parsedTimestamp = DateTime.now();
    }
    return MessageModel(
      id: data['id'] as String? ?? '',
      senderId: data['senderId'] as String? ?? '',
      receiverId: data['receiverId'] as String? ?? '',
      content: data['content'] as String? ?? '',
      timestamp: parsedTimestamp,
    );
  }

  factory MessageModel.fromThreadFirestore(
    dynamic doc, {
    required ChatParticipants participants,
  }) {
    throw UnsupportedError('Firestore is no longer supported.');
  }

  factory MessageModel.fromEntity(Message message) {
    return MessageModel(
      id: message.id,
      senderId: message.senderId,
      receiverId: message.receiverId,
      content: message.content,
      timestamp: message.timestamp,
    );
  }

  Message toEntity() {
    return Message(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      content: content,
      timestamp: timestamp,
    );
  }
}
