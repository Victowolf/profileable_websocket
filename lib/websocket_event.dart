// lib/websocket_event.dart

enum FrameDirection { incoming, outgoing, internal }

enum FrameType { text, binary, lifecycle }

class LogColors {
  static const reset = '\x1B[0m';

  static const green = '\x1B[32m';
  static const yellow = '\x1B[33m';
  static const red = '\x1B[31m';
  static const white = '\x1B[37m';
}

class WebSocketEvent {
  final DateTime timestamp;
  final FrameDirection direction;
  final FrameType type;
  final int size;
  final String? preview;
  final String? label;
  final Duration? latency;

  WebSocketEvent({
    required this.timestamp,
    required this.direction,
    required this.type,
    required this.size,
    this.preview,
    this.label,
    this.latency,
  });

  Map<String, dynamic> toJson() {
    return {
      "timestamp": timestamp.toIso8601String(),
      "direction": direction.name,
      "type": type.name,
      "size": size,
      "label": label,
      "latency_ms": latency?.inMilliseconds,
    };
  }

  String get formatted {
    final time = '[${timestamp.toLocal().toIso8601String().substring(11, 23)}]';

    final dir = direction == FrameDirection.incoming
        ? 'IN '
        : direction == FrameDirection.outgoing
        ? 'OUT'
        : 'LC ';

    final typeStr = type.name.toUpperCase().padRight(6);
    final sizeStr = '$size bytes'.padRight(10);

    final labelStr = (label ?? '').padRight(16);
    final latencyStr = latency != null ? '${latency!.inMilliseconds} ms' : '';
    final latencyPadded = latencyStr.padRight(8);

    final line =
        '$time $dir | $typeStr | $sizeStr | $labelStr | $latencyPadded';

    // 🎨 COLOR LOGIC (ONLY FOR LOGS)
    if (direction == FrameDirection.internal) {
      if (label == 'connected' || label == 'server greeting') {
        return '\x1B[32m$line\x1B[0m'; // green
      } else if (label == 'disconnected') {
        return '\x1B[31m$line\x1B[0m'; // red
      } else if (label == 'error') {
        return '\x1B[33m$line\x1B[0m'; // yellow
      }
    }

    // default: white for send/receive
    return '\x1B[37m$line\x1B[0m';
  }

  String get fullLog {
    return '$formatted | json: ${toJson()}';
  }
}
