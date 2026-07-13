import 'dart:async';

import 'package:the_warehouse_gym/core/config/app_config.dart';
import 'package:the_warehouse_gym/features/client/messaging/data/models/message_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class ChatSocketService {
  static const joinEvent = 'chat:join';
  static const leaveEvent = 'chat:leave';
  static const sendEvent = 'chat:send';
  static const joinedEvent = 'chat:joined';
  static const messageEvent = 'chat:message';
  static const errorEvent = 'chat:error';

  final AppConfig _config;
  io.Socket? _socket;
  String? _connectedToken;
  String? _threadId;
  final _messagesController = StreamController<List<MessageModel>>.broadcast();
  final _errorController = StreamController<String>.broadcast();
  List<MessageModel> _messages = [];

  ChatSocketService(this._config);

  Stream<List<MessageModel>> get messageStream => _messagesController.stream;

  Stream<String> get errorStream => _errorController.stream;

  Future<void> connect(String? token) async {
    if (token == null || token.isEmpty) {
      throw StateError('Missing auth token for chat socket.');
    }
    if (_socket != null && _connectedToken == token && _socket!.connected) {
      return;
    }
    await disconnect();

    _socket = io.io(
      _config.socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setPath(_config.socketPath)
          .setAuth({'token': token})
          .disableAutoConnect()
          .build(),
    );

    _socket!
      ..on(joinedEvent, _onJoined)
      ..on(messageEvent, _onMessage)
      ..on(errorEvent, _onError);

    final completer = Completer<void>();
    _socket!
      ..onConnect((_) => completer.complete())
      ..onConnectError((error) {
        if (!completer.isCompleted) {
          completer.completeError(error ?? 'Socket connect failed');
        }
      })
      ..connect();

    await completer.future.timeout(const Duration(seconds: 15));
    _connectedToken = token;
  }

  Future<void> disconnect() async {
    _threadId = null;
    _messages = [];
    _messagesController.add(const []);
    final socket = _socket;
    _socket = null;
    _connectedToken = null;
    if (socket != null) {
      socket.dispose();
    }
  }

  Future<void> joinChat(String otherUserId) async {
    final socket = _socket;
    if (socket == null || !socket.connected) {
      throw StateError('Socket is not connected.');
    }
    final completer = Completer<void>();
    void handler(dynamic data) {
      if (!completer.isCompleted) completer.complete();
    }

    socket.once(joinedEvent, handler);
    socket.emit(joinEvent, {'otherUserId': otherUserId});
    await completer.future.timeout(const Duration(seconds: 15));
  }

  Future<void> leaveChat() async {
    final socket = _socket;
    final threadId = _threadId;
    if (socket == null || threadId == null) return;
    socket.emit(leaveEvent, {'threadId': threadId});
    _threadId = null;
  }

  Future<void> sendMessage(String otherUserId, String content) async {
    final socket = _socket;
    if (socket == null || !socket.connected) {
      throw StateError('Socket is not connected.');
    }
    socket.emit(sendEvent, {
      'otherUserId': otherUserId,
      'content': content,
    });
  }

  void _onJoined(dynamic data) {
    if (data is! Map) return;
    final map = Map<String, dynamic>.from(data);
    _threadId = map['threadId'] as String?;
    final rawMessages = map['messages'] as List<dynamic>? ?? [];
    _messages = rawMessages
        .whereType<Map>()
        .map((m) => MessageModel.fromSocketJson(Map<String, dynamic>.from(m)))
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    _messagesController.add(List.unmodifiable(_messages));
  }

  void _onMessage(dynamic data) {
    if (data is! Map) return;
    final map = Map<String, dynamic>.from(data);
    final messageJson = map['message'];
    if (messageJson is! Map) return;
    final message =
        MessageModel.fromSocketJson(Map<String, dynamic>.from(messageJson));
    _messages = [message, ..._messages];
    _messagesController.add(List.unmodifiable(_messages));
  }

  void _onError(dynamic data) {
    if (data is Map) {
      final message = data['message'] as String? ?? 'Chat error';
      _errorController.add(message);
    }
  }

  void dispose() {
    disconnect();
    _messagesController.close();
    _errorController.close();
  }
}
