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
  Completer<void>? _joinCompleter;
  final _messagesController = StreamController<List<MessageModel>>.broadcast();
  final _errorController = StreamController<String>.broadcast();
  List<MessageModel> _messages = [];

  ChatSocketService(this._config);

  Stream<List<MessageModel>> get messageStream => _messagesController.stream;

  Stream<String> get errorStream => _errorController.stream;

  List<MessageModel> get currentMessages => List.unmodifiable(_messages);

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
      ..onConnect((_) {
        if (!completer.isCompleted) completer.complete();
      })
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
    _joinCompleter = null;
    if (!_messagesController.isClosed) {
      _messagesController.add(const []);
    }
    final socket = _socket;
    _socket = null;
    _connectedToken = null;
    if (socket != null) {
      socket.dispose();
    }
  }

  /// Joins a thread and returns the loaded history (newest first).
  Future<List<MessageModel>> joinChat(String otherUserId) async {
    final socket = _socket;
    if (socket == null || !socket.connected) {
      throw StateError('Socket is not connected.');
    }

    _joinCompleter = Completer<void>();
    socket.emit(joinEvent, {'otherUserId': otherUserId});
    await _joinCompleter!.future.timeout(const Duration(seconds: 15));
    return currentMessages;
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
    if (data is! Map) {
      _failJoin('Invalid chat:joined payload');
      return;
    }
    final map = Map<String, dynamic>.from(data);
    _threadId = map['threadId'] as String?;
    final rawMessages = map['messages'] as List<dynamic>? ?? [];
    _messages = rawMessages
        .whereType<Map>()
        .map((m) => MessageModel.fromSocketJson(Map<String, dynamic>.from(m)))
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    if (!_messagesController.isClosed) {
      _messagesController.add(List.unmodifiable(_messages));
    }
    final joinCompleter = _joinCompleter;
    _joinCompleter = null;
    if (joinCompleter != null && !joinCompleter.isCompleted) {
      joinCompleter.complete();
    }
  }

  void _failJoin(String message) {
    final joinCompleter = _joinCompleter;
    _joinCompleter = null;
    if (joinCompleter != null && !joinCompleter.isCompleted) {
      joinCompleter.completeError(message);
    }
    if (!_errorController.isClosed) {
      _errorController.add(message);
    }
  }

  void _onMessage(dynamic data) {
    if (data is! Map) return;
    final map = Map<String, dynamic>.from(data);
    final messageJson = map['message'];
    if (messageJson is! Map) return;
    final message =
        MessageModel.fromSocketJson(Map<String, dynamic>.from(messageJson));
    _messages = [message, ..._messages];
    if (!_messagesController.isClosed) {
      _messagesController.add(List.unmodifiable(_messages));
    }
  }

  void _onError(dynamic data) {
    if (data is Map) {
      final message = data['message'] as String? ?? 'Chat error';
      if (!_errorController.isClosed) {
        _errorController.add(message);
      }
      final joinCompleter = _joinCompleter;
      _joinCompleter = null;
      if (joinCompleter != null && !joinCompleter.isCompleted) {
        joinCompleter.completeError(message);
      }
    }
  }

  void dispose() {
    disconnect();
    _messagesController.close();
    _errorController.close();
  }
}
