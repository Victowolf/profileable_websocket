import 'package:test/test.dart';
import 'package:websocket_profiler/websocket_event.dart';

void main() {
  group('WebSocketEvent', () {
    test('toJson contains all required fields', () {
      final event = WebSocketEvent(
        timestamp: DateTime.parse('2026-03-19T12:00:00.000Z'),
        direction: FrameDirection.incoming,
        type: FrameType.text,
        size: 15,
        label: 'test message',
        latency: Duration(milliseconds: 120),
      );

      final json = event.toJson();

      expect(json['timestamp'], '2026-03-19T12:00:00.000Z');
      expect(json['direction'], 'incoming');
      expect(json['type'], 'text');
      expect(json['size'], 15);
      expect(json['label'], 'test message');
      expect(json['latency_ms'], 120);
    });

    test('formatted output includes latency when present', () {
      final event = WebSocketEvent(
        timestamp: DateTime.now(),
        direction: FrameDirection.incoming,
        type: FrameType.text,
        size: 8,
        label: 'received',
        latency: Duration(milliseconds: 85),
      );

      expect(event.formatted, contains('85 ms'));
    });
  });
}
