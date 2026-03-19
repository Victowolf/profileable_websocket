// lib/profileable_websocket.dart

import 'connection_summary.dart';
import 'dart:async';
import 'dart:io';

import 'websocket_event.dart';
import 'event_buffer.dart';

class ProfileableWebSocket {
  final WebSocket _inner;
  final EventBuffer _buffer;
  final ConnectionSummary summary = ConnectionSummary();

  ProfileableWebSocket._(this._inner, this._buffer);

  /// constructor to connect
  static Future<ProfileableWebSocket> connect(
    String url, {
    int bufferSize = 100,
  }) async {
    final socket = await WebSocket.connect(url);
    final buffer = EventBuffer(capacity: bufferSize);
    final profiler = ProfileableWebSocket._(socket, buffer);
    profiler._logLifecycle('connected');
    return profiler;
  }

  /// Expose recent events
  List<WebSocketEvent> get recentEvents => _buffer.events;

  /// OUTGOING interception
  void add(dynamic data) {
    _logOutgoing(data);
    _inner.add(data);
    summary.messagesSent++;
    summary.totalSentBytes += _calculateSize(data);
  }

  /// INCOMING interception
  StreamSubscription listen(
    void Function(dynamic data)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return _inner.listen(
      (message) {
        _logIncoming(message);
        summary.messagesReceived++;
        summary.totalReceivedBytes += _calculateSize(message);
        onData?.call(message);
      },
      onError: (error) {
        summary.errorOccurred = true;
        summary.closedAt = DateTime.now();
        summary.closeReason = 'Connection closed due to error';
        _logLifecycle('error');
        if (onError != null) {
          onError(error);
        }
      },
      onDone: () {
        summary.closedAt = DateTime.now();
        summary.closeReason = 'Connection closed normally';
        _logLifecycle('disconnected');
        if (onDone != null) {
          onDone();
        }
      },
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
      label: 'sent',
    );
    _buffer.add(event);
  }

  bool _greetingLogged = false;
  void _logIncoming(dynamic data) {
    final label = !_greetingLogged ? 'server greeting' : 'received';
    _greetingLogged = true;

    final event = WebSocketEvent(
      timestamp: DateTime.now(),
      direction: FrameDirection.incoming,
      type: _detectType(data),
      size: _calculateSize(data),
      label: label,
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

  void _logLifecycle(String label) {
    final event = WebSocketEvent(
      timestamp: DateTime.now(),
      direction: FrameDirection.internal,
      type: FrameType.binary,
      size: 0,
      label: label,
    );
    _buffer.add(event);
  }
}
