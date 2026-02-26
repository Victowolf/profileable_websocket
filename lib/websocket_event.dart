// lib/websocket_event.dart

enum FrameDirection { incoming, outgoing }

enum FrameType { text, binary }

class WebSocketEvent {
  final DateTime timestamp;
  final FrameDirection direction;
  final FrameType type;
  final int size;
  final String? preview;

  WebSocketEvent({
    required this.timestamp,
    required this.direction,
    required this.type,
    required this.size,
    this.preview,
  });

  String get formatted {
    final time =
        "${timestamp.hour.toString().padLeft(2, '0')}:"
        "${timestamp.minute.toString().padLeft(2, '0')}:"
        "${timestamp.second.toString().padLeft(2, '0')}."
        "${timestamp.millisecond.toString().padLeft(3, '0')}";

    final dir = direction == FrameDirection.outgoing ? "OUT" : "IN ";
    final t = type == FrameType.text ? "TEXT  " : "BINARY";

    String annotation = "";

    if (direction == FrameDirection.incoming &&
        preview != null &&
        preview!.startsWith("Request served by")) {
      annotation = " (server greeting received)";
    }

    return "[$time] $dir | $t | $size bytes$annotation";
  }
}
