// lib/profileable_websocket.dart

import 'dart:async';
import 'dart:io';

import 'websocket_event.dart';
import 'event_buffer.dart';

class ProfileableWebSocket {
  final WebSocket _inner;
  final EventBuffer _buffer;

  ProfileableWebSocket._(this._inner, this._buffer);

  /// constructor to connect
  static Future<ProfileableWebSocket> connect(
    String url, {
    int bufferSize = 100,
  }) async {
    final socket = await WebSocket.connect(url);
    final buffer = EventBuffer(capacity: bufferSize);
    return ProfileableWebSocket._(socket, buffer);
  }

  /// Expose recent events
  List<WebSocketEvent> get recentEvents => _buffer.events;

  /// OUTGOING interception
  void add(dynamic data) {
    _logOutgoing(data);
    _inner.add(data);
  }

  /// INCOMING interception
  StreamSubscription listen(
    void Function(dynamic data)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return _inner.listen(
      (data) {
        _logIncoming(data);
        onData?.call(data);
      },
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  Future<void> close([int? code, String? reason]) {
    return _inner.close(code, reason);
  }

  Future get done => _inner.done;

  // --------------------------
  // Internal Logging
  // --------------------------

  void _logOutgoing(dynamic data) {
    final event = WebSocketEvent(
      timestamp: DateTime.now(),
      direction: FrameDirection.outgoing,
      type: _detectType(data),
      size: _calculateSize(data),
    );

    _buffer.add(event);
  }

  void _logIncoming(dynamic data) {
    final event = WebSocketEvent(
      timestamp: DateTime.now(),
      direction: FrameDirection.incoming,
      type: _detectType(data),
      size: _calculateSize(data),
      preview: data is String ? data : null,
    );

    _buffer.add(event);
  }

  FrameType _detectType(dynamic data) {
    if (data is String) return FrameType.text;
    if (data is List<int>) return FrameType.binary;
    return FrameType.text;
  }

  int _calculateSize(dynamic data) {
    if (data is String) {
      return data.codeUnits.length;
    }
    if (data is List<int>) {
      return data.length;
    }
    return 0;
  }
}
