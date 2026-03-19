class ConnectionSummary {
  DateTime connectedAt;
  DateTime? closedAt;
  int messagesSent = 0;
  int messagesReceived = 0;
  int totalSentBytes = 0;
  int totalReceivedBytes = 0;
  bool errorOccurred = false;
  String? closeReason;

  ConnectionSummary({DateTime? connected})
    : connectedAt = connected ?? DateTime.now();

  Duration get duration =>
      closedAt != null ? closedAt!.difference(connectedAt) : Duration.zero;

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
    if (errorOccurred) print('❗ Error occurred during connection');
    if (closeReason != null) print('Close Reason      : $closeReason');
    print('-----------------------------------\n');
  }
}
