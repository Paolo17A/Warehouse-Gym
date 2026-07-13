import 'package:the_warehouse_gym/core/errors/failures.dart';
import 'package:the_warehouse_gym/features/client/messaging/domain/entities/message.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'messaging_state.freezed.dart';

@freezed
class MessagingState with _$MessagingState {
  const factory MessagingState.initial() = Initial;
  const factory MessagingState.loading() = Loading;
  const factory MessagingState.loaded(List<Message> messages) = Loaded;
  const factory MessagingState.sending(List<Message> messages) = Sending;
  const factory MessagingState.failed(Failure failure) = Failed;
}

extension MessagingStateX on MessagingState {
  bool get isLoading => this is Loading;

  bool get isSending => this is Sending;

  Failure? get failure => maybeMap(
        failed: (value) => value.failure,
        orElse: () => null,
      );

  List<Message> get messages => maybeMap(
        loaded: (value) => value.messages,
        sending: (value) => value.messages,
        orElse: () => const [],
      );
}
