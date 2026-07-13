import 'package:dartz/dartz.dart';
import 'package:the_warehouse_gym/core/errors/failures.dart';
import '../entities/message.dart';

abstract class MessagingRepository {
  Future<Either<Failure, List<Message>>> getMessages(
    String currentUid,
    String otherUid, {
    required bool isClientView,
  });

  Future<Either<Failure, void>> sendMessage(
    Message message, {
    required bool isClientView,
  });

  Stream<List<Message>> watchMessages(
    String currentUid,
    String otherUid, {
    required bool isClientView,
  });
}
