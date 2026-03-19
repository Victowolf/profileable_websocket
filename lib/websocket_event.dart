// lib/websocket_event.dart

enum FrameDirection { incoming, outgoing, internal }

enum FrameType { text, binary, lifecycle }

class WebSocketEvent {
  final DateTime timestamp;
  final FrameDirection direction;
  final FrameType type;
  final int size;
  final String? preview;
  final String? label;

  WebSocketEvent({
    required this.timestamp,
    required this.direction,
    required this.type,
    required this.size,
    this.preview,
    this.label,
  });

  String get formatted {
    final time = '[${timestamp.toLocal().toIso8601String().substring(11, 23)}]';
    final dir = direction == FrameDirection.incoming
        ? 'IN '
        : direction == FrameDirection.outgoing
        ? 'OUT'
        : 'LC ';
    final typeStr = type.toString().split('.').last.toUpperCase().padRight(6);
    final sizeStr = '$size bytes'.padRight(10);
    final labelStr = label != null ? '| ${label!}' : '';
    return '$time $dir | $typeStr | $sizeStr $labelStr';
  }
}
