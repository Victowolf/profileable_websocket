import 'dart:convert';

class ConnectionSummary {
  DateTime connectedAt;
  DateTime? closedAt;
  int messagesSent = 0;
  int messagesReceived = 0;
  int totalSentBytes = 0;
  int totalReceivedBytes = 0;
  bool errorOccurred = false;
  String? closeReason;
  final List<Duration> _latencies = [];

  ConnectionSummary({DateTime? connected})
    : connectedAt = connected ?? DateTime.now();

  Duration get duration =>
      closedAt != null ? closedAt!.difference(connectedAt) : Duration.zero;

  void addLatency(Duration latency) {
    _latencies.add(latency);
  }

  double get avgLatencyMs {
    if (_latencies.isEmpty) return 0;

    final totalMs = _latencies
        .map((e) => e.inMilliseconds)
        .reduce((a, b) => a + b);

    return totalMs / _latencies.length;
  }

  Map<String, dynamic> toJson() {
    return {
      "connected_at": connectedAt.toIso8601String(),
      "closed_at": closedAt?.toIso8601String(),
      "duration_sec": duration.inSeconds,
      "messages_sent": messagesSent,
      "messages_received": messagesReceived,
      "bytes_sent": totalSentBytes,
      "bytes_received": totalReceivedBytes,
      "avg_latency_ms": avgLatencyMs,
      "error": errorOccurred,
      "close_reason": closeReason,
    };
  }

  void printSummary() {
    print('\n--- WebSocket Connection Summary ---');
    print('Connection Started: ${connectedAt.toLocal()}');
    if (closedAt != null) {
      print('Connection Closed : ${closedAt!.toLocal()}');
      print('Duration          : ${duration.inSeconds}s');
    } else {
      print('Connection still active');
    }
    print('Messages Sent     : $messagesSent');
    print('Messages Received : $messagesReceived');
    print('Bytes Sent        : $totalSentBytes');
    print('Bytes Received    : $totalReceivedBytes');
    print('Avg Latency       : ${avgLatencyMs.toStringAsFixed(2)} ms');
    if (errorOccurred) print('❗ Error occurred during connection');
    if (closeReason != null) print('Close Reason      : $closeReason');
    const encoder = JsonEncoder.withIndent('  ');
    print('json:\n${encoder.convert(toJson())}');
    print('-----------------------------------\n');
  }
}
