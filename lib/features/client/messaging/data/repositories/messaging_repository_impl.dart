import 'package:dartz/dartz.dart';
import 'package:the_warehouse_gym/core/errors/failures.dart';
import 'package:the_warehouse_gym/core/network/network_info.dart';
import 'package:the_warehouse_gym/features/client/messaging/data/services/chat_socket_service.dart';
import 'package:the_warehouse_gym/features/client/messaging/domain/entities/message.dart';
import 'package:the_warehouse_gym/features/client/messaging/domain/repositories/messaging_repository.dart';

class MessagingRepositoryImpl implements MessagingRepository {
  final ChatSocketService _socketService;
  final NetworkInfo _networkInfo;

  const MessagingRepositoryImpl(this._socketService, this._networkInfo);

  @override
  Future<Either<Failure, List<Message>>> getMessages(
    String currentUid,
    String otherUid, {
    required bool isClientView,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    return const Right([]);
  }

  @override
  Future<Either<Failure, void>> sendMessage(
    Message message, {
    required bool isClientView,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      await _socketService.sendMessage(message.receiverId, message.content);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<Message>> watchMessages(
    String currentUid,
    String otherUid, {
    required bool isClientView,
  }) {
    return _socketService.messageStream.map(
      (models) => models.map((m) => m.toEntity()).toList(),
    );
  }
}
