import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:the_warehouse_gym/core/di/injection.dart';
import 'package:the_warehouse_gym/core/errors/failures.dart';
import 'package:the_warehouse_gym/core/network/auth_secure_storage.dart';
import 'package:the_warehouse_gym/core/providers/session_providers.dart';
import 'package:the_warehouse_gym/core/utils/toast_utils.dart';
import 'package:the_warehouse_gym/core/widgets/fitnessco_ui.dart';
import 'package:the_warehouse_gym/core/widgets/loading_widget.dart';
import 'package:the_warehouse_gym/core/widgets/no_internet_widget.dart';
import 'package:the_warehouse_gym/features/client/messaging/data/services/chat_socket_service.dart';
import 'package:the_warehouse_gym/features/client/messaging/presentation/chat/utils/chat_access_util.dart';
import 'package:the_warehouse_gym/features/client/messaging/presentation/chat/widgets/message_bubble_widget.dart';
import 'package:the_warehouse_gym/features/client/messaging/presentation/viewmodels/messaging_viewmodel.dart';
import 'package:the_warehouse_gym/features/shared/account/domain/entities/full_user.dart';
import 'package:the_warehouse_gym/features/shared/account/domain/usecases/account_usecase.dart';

class ChatPage extends HookConsumerWidget {
  final String otherUid;
  final String otherName;
  final bool isClientView;

  const ChatPage({
    super.key,
    required this.otherUid,
    required this.otherName,
    required this.isClientView,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(sessionUserProvider);
    final messagingState = ref.watch(messagingViewModelProvider);
    final messagingVm = ref.read(messagingViewModelProvider.notifier);
    final accountUseCase = sl<AccountUseCase>();

    final messageController = useTextEditingController();
    final scrollController = useScrollController();
    final displayName = useState(otherName);
    final isAccessValid = useState<bool?>(null);
    final otherProfile = useState<FullUser?>(null);
    final trainerProfile = useState<FullUser?>(null);

    final currentUid = currentUser?.uid ?? '';

    Future<void> validateAccess() async {
      final otherResult = await accountUseCase.getProfile(otherUid);
      await otherResult.fold(
        (_) async {
          if (context.mounted) {
            showErrorToast('User not found');
            context.pop();
          }
        },
        (other) async {
          otherProfile.value = other;
          if (isClientView) {
            final resolvedName = '${other.firstName} ${other.lastName}'.trim();
            if (resolvedName.isNotEmpty) displayName.value = resolvedName;
            isAccessValid.value = true;
            return;
          }

          final trainerResult = await accountUseCase.getProfile(currentUid);
          trainerResult.fold(
            (_) {
              if (context.mounted) {
                showErrorToast('Error loading chat');
                context.pop();
              }
            },
            (trainer) {
              trainerProfile.value = trainer;
              final trainerClients = trainer.trainerRelationship.currentClients;
              final clientData = {
                'trainerRelationship': {
                  'currentTrainer': other.trainerRelationship.currentTrainer,
                  'isConfirmed': other.trainerRelationship.isConfirmed,
                },
              };
              final canAccess = ChatAccessUtil.trainerCanMessageClient(
                clientData: clientData,
                clientUid: otherUid,
                trainerUid: currentUid,
                trainerCurrentClients: trainerClients,
              );
              if (!canAccess) {
                if (context.mounted) {
                  showErrorToast(
                    'Your client has opted to select a different trainer',
                  );
                  context.pop();
                }
                return;
              }
              final resolvedName =
                  '${other.firstName} ${other.lastName}'.trim();
              if (resolvedName.isNotEmpty) displayName.value = resolvedName;
              isAccessValid.value = true;
            },
          );
        },
      );
    }

    useEffect(() {
      if (currentUid.isEmpty || otherUid.isEmpty) return null;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        validateAccess();
      });
      return null;
    }, [currentUid, otherUid, isClientView]);

    useEffect(() {
      if (currentUid.isEmpty || isAccessValid.value != true) return null;

      final socket = sl<ChatSocketService>();
      StreamSubscription<dynamic>? messageSub;
      StreamSubscription<dynamic>? errorSub;
      var cancelled = false;

      Future<void> connect() async {
        // Defer notifier updates — mutating providers during build/effect setup throws.
        await Future<void>.delayed(Duration.zero);
        if (cancelled) return;

        messagingVm.beginLoading();
        try {
          final token = await sl<AuthSecureStorage>().getToken();
          if (cancelled) return;
          await socket.connect(token);
          if (cancelled) return;

          // Subscribe before joinChat — broadcast streams do not replay history.
          messageSub = socket.messageStream.listen(
            (models) {
              if (cancelled) return;
              messagingVm.setMessages(
                models.map((m) => m.toEntity()).toList(),
              );
            },
          );
          errorSub = socket.errorStream.listen(showErrorToast);

          final history = await socket.joinChat(otherUid);
          if (cancelled) return;
          messagingVm.setMessages(
            history.map((m) => m.toEntity()).toList(),
          );
        } catch (e) {
          if (cancelled) return;
          messagingVm.setMessages(const []);
          if (context.mounted) {
            showErrorToast('Unable to connect to chat');
          }
        }
      }

      connect();

      return () {
        cancelled = true;
        messageSub?.cancel();
        errorSub?.cancel();
        // Leave/disconnect and reset after dispose finishes (Riverpod-safe).
        Future(() async {
          await socket.leaveChat();
          await socket.disconnect();
          messagingVm.reset();
        });
      };
    }, [currentUid, otherUid, isAccessValid.value]);

    ref.listen<MessagingState>(messagingViewModelProvider, (_, next) {
      if (next.failure != null) showFailureToast(next.failure!);
    });

    AppBar chatAppBar() {
      return AppBar(
        toolbarHeight: 40,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: fitnesscoText(
          displayName.value,
          textStyle: blackBoldStyle(size: 18),
        ),
      );
    }

    final waitingForMessages = messagingState.maybeMap(
      initial: (_) => true,
      loading: (_) => true,
      orElse: () => false,
    );

    if (isAccessValid.value != true || waitingForMessages) {
      return FitnesscoScreenShell(
        appBar: chatAppBar(),
        body: const ChatBackground(child: LoadingWidget()),
      );
    }

    if (messagingState.failure is NetworkFailure &&
        messagingState.messages.isEmpty) {
      return FitnesscoScreenShell(
        appBar: chatAppBar(),
        body: ChatBackground(
          child: NoInternetWidget(
            onRetry: () => validateAccess(),
          ),
        ),
      );
    }

    Future<bool> validateBeforeSend() async {
      final other = otherProfile.value;
      if (other == null) return false;

      if (isClientView) {
        return true;
      }

      final trainer = trainerProfile.value;
      if (trainer == null) return false;

      final clientData = {
        'trainerRelationship': {
          'currentTrainer': other.trainerRelationship.currentTrainer,
          'isConfirmed': other.trainerRelationship.isConfirmed,
        },
      };
      final canAccess = ChatAccessUtil.trainerCanMessageClient(
        clientData: clientData,
        clientUid: otherUid,
        trainerUid: currentUid,
        trainerCurrentClients: trainer.trainerRelationship.currentClients,
      );
      if (!canAccess) {
        if (context.mounted) {
          showErrorToast('Your client has removed you as their trainer');
          context.pop();
        }
        return false;
      }
      return true;
    }

    Future<void> onSend() async {
      final text = messageController.text.trim();
      if (text.isEmpty) return;
      if (!await validateBeforeSend()) return;
      if (!context.mounted) return;

      FocusScope.of(context).unfocus();
      messageController.clear();
      await messagingVm.sendMessage(
        currentUid,
        otherUid,
        text,
        isClientView: isClientView,
      );
    }

    return FitnesscoScreenShell(
      appBar: chatAppBar(),
      body: ChatBackground(
        child: Column(
          children: [
            Expanded(
              child: messagingState.messages.isEmpty
                  ? const _EmptyChat()
                  : ListView.builder(
                      controller: scrollController,
                      reverse: true,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.only(
                        bottom: 12,
                        left: 13,
                        right: 13,
                        top: 8,
                      ),
                      itemCount: messagingState.messages.length,
                      itemBuilder: (context, index) {
                        final msg = messagingState.messages[index];
                        final isMe = msg.senderId == currentUid;
                        final nextMessage =
                            index + 1 < messagingState.messages.length
                                ? messagingState.messages[index + 1]
                                : null;
                        final sameSenderAsNext =
                            nextMessage?.senderId == msg.senderId;

                        if (sameSenderAsNext) {
                          return MessageBubble.next(
                            message: msg.content,
                            isMe: isMe,
                          );
                        }
                        return MessageBubble.first(
                          message: msg.content,
                          isMe: isMe,
                        );
                      },
                    ),
            ),
            _MessageInputBar(
              controller: messageController,
              isSending: messagingState.isSending,
              onSend: onSend,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyChat extends StatelessWidget {
  const _EmptyChat();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: fitnesscoText(
        'No messages found',
        textStyle: greyBoldStyle(size: 16),
      ),
    );
  }
}

class _MessageInputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isSending;
  final Future<void> Function() onSend;

  const _MessageInputBar({
    required this.controller,
    required this.isSending,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, bottom: 8, right: 14),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                enableSuggestions: true,
                decoration: const InputDecoration(
                  labelText: 'Send a message...',
                ),
                onSubmitted: (_) => onSend(),
              ),
            ),
            if (isSending)
              const Padding(
                padding: EdgeInsets.all(12),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else
              IconButton(
                color: Theme.of(context).colorScheme.primary,
                onPressed: onSend,
                icon: const Icon(Icons.send),
              ),
          ],
        ),
      ),
    );
  }
}
