import 'package:the_warehouse_gym/core/di/injection.dart';
import 'package:the_warehouse_gym/core/utils/toast_utils.dart';
import 'package:the_warehouse_gym/features/client/messaging/domain/entities/message.dart';
import 'package:the_warehouse_gym/features/client/messaging/domain/usecases/messaging_usecase.dart';
import 'package:the_warehouse_gym/features/client/messaging/presentation/viewmodels/messaging_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

export 'messaging_state.dart';

class MessagingViewModel extends StateNotifier<MessagingState> {
  final MessagingUseCase _messaging;

  MessagingViewModel({required MessagingUseCase messaging})
      : _messaging = messaging,
        super(const MessagingState.initial());

  Future<void> loadMessages(
    String currentUid,
    String otherUid, {
    required bool isClientView,
  }) async {
    state = const MessagingState.loading();
    final result = await _messaging.getMessages(
      currentUid,
      otherUid,
      isClientView: isClientView,
    );
    result.fold(
      (failure) => state = MessagingState.failed(failure),
      (messages) => state = MessagingState.loaded(messages),
    );
  }

  Future<bool> sendMessage(
    String senderId,
    String receiverId,
    String content, {
    required bool isClientView,
  }) async {
    final previousMessages = _currentMessages();
    final message = Message(
      id: 'pending-${DateTime.now().microsecondsSinceEpoch}',
      senderId: senderId,
      receiverId: receiverId,
      content: content,
      timestamp: DateTime.now(),
    );
    final optimisticMessages = [message, ...previousMessages];
    state = MessagingState.sending(optimisticMessages);

    final result = await _messaging.sendMessage(
      message,
      isClientView: isClientView,
    );
    return result.fold(
      (failure) {
        state = MessagingState.loaded(previousMessages);
        showFailureToast(failure);
        return false;
      },
      (_) {
        // Keep optimistic list until the socket stream replaces it.
        state = MessagingState.loaded(optimisticMessages);
        return true;
      },
    );
  }

  Future<void> refresh(
    String currentUid,
    String otherUid, {
    required bool isClientView,
  }) =>
      loadMessages(currentUid, otherUid, isClientView: isClientView);

  void beginLoading() {
    state = const MessagingState.loading();
  }

  void setMessages(List<Message> messages) {
    state = MessagingState.loaded(messages);
  }

  void reset() {
    state = const MessagingState.initial();
  }

  List<Message> _currentMessages() => state.maybeMap(
        loaded: (value) => value.messages,
        sending: (value) => value.messages,
        orElse: () => const [],
      );
}

final messagingViewModelProvider =
    StateNotifierProvider<MessagingViewModel, MessagingState>((_) {
  return MessagingViewModel(messaging: sl<MessagingUseCase>());
});
