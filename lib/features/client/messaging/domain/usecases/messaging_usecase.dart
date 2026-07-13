import 'package:dartz/dartz.dart';
import 'package:the_warehouse_gym/core/errors/failures.dart';
import '../entities/message.dart';
import '../repositories/messaging_repository.dart';

class MessagingUseCase {
  final MessagingRepository _repository;

  const MessagingUseCase(this._repository);

  Future<Either<Failure, List<Message>>> getMessages(
    String currentUid,
    String otherUid, {
    required bool isClientView,
  }) =>
      _repository.getMessages(
        currentUid,
        otherUid,
        isClientView: isClientView,
      );

  Future<Either<Failure, void>> sendMessage(
    Message message, {
    required bool isClientView,
  }) =>
      _repository.sendMessage(message, isClientView: isClientView);

  Stream<List<Message>> watchMessages(
    String currentUid,
    String otherUid, {
    required bool isClientView,
  }) =>
      _repository.watchMessages(
        currentUid,
        otherUid,
        isClientView: isClientView,
      );
}
