// lib/event_buffer.dart

import 'dart:collection';
import 'websocket_event.dart';

class EventBuffer {
  final int capacity;
  final ListQueue<WebSocketEvent> _events;

  EventBuffer({this.capacity = 100}) : _events = ListQueue<WebSocketEvent>();

  void add(WebSocketEvent event) {
    if (_events.length >= capacity) {
      _events.removeFirst();
    }
    _events.addLast(event);
  }

  List<WebSocketEvent> get events => List.unmodifiable(_events);
}
