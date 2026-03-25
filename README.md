# WebSocket Profiler (Dart CLI Prototype)

A lightweight, standalone Dart CLI prototype that demonstrates **frame-level WebSocket profiling** without modifying the Dart SDK.

This project was built as a proof-of-concept for instrumenting WebSocket traffic at user-space level using the **Decorator (Wrapper) pattern**.

It intercepts:

- Outgoing frames (`add()`)
- Incoming frames (`listen()`)

And records:

- Timestamp (v1)
- Direction (IN / OUT) (v1)
- Frame type (TEXT / BINARY) (v1)
- Size (bytes) (v1)
- System frame classification (e.g., server greeting) (v1)
- Lifecycle events (connect, disconnect, error) (v2)
- Per-frame latency (v3)
- JSON export support (v3)
- Testing & Licensing support (v4)

---

# Objective

The goal of this prototype is to:

- Demonstrate frame-level WebSocket logging
- Maintain a bounded event buffer
- Provide a menu-driven CLI interface
- Model how DevTools-style network profiling could work
- Avoid any Dart SDK or VM service modifications

---

# Architecture Overview

## Pattern Used: Wrapper (Decorator)

We wrap `dart:io WebSocket` using composition:
```

ProfileableWebSocket  
        ↓  
Wraps real WebSocket  
        ↓  
Intercepts add() and listen()

```

---

# Folder Structure

```
websocket_profiler/
│
├── bin/
│   └── main.dart                  # CLI entry point (menu-driven interface)
│
├── lib/
│   ├── websocket_event.dart       # Frame event model + formatting + toJson
│   ├── event_buffer.dart          # Bounded FIFO event storage
│   ├── connection_summary.dart    # Connection stats model + printer
│   └── profileable_websocket.dart # WebSocket wrapper (core logic)
│
├── test/
│   └── websocket_event_test.dart  # Unit tests for WebSocketEvent
│
├── LICENSE.md                     # MIT License 
├── CHANGELOG.md                   # Version-wise changes 
└── pubspec.yaml

```
---

# Features Implemented

- Frame-level interception (`add()`, `listen()`)
- Direction-based logging (IN / OUT)
- Lifecycle events (connect / disconnect / error)
- Frame type detection (TEXT / BINARY)
- Byte size tracking
- Timestamped logs (ms precision)
- Server greeting detection
- Bounded buffer (FIFO)
- Interactive CLI
- Connection summary with:
  - Duration
  - Message counts
  - Byte totals
  - Error/close reason
- Formatted CLI log view with color coding (v3)
- Structured JSON log export (v3)
- Foundational testing and licensing support


---

# Demo Run Flow

```
=== WebSocket Profiler ===
1. Toggle Connection (On/Off): 🔴
2. Test Mode (Send Messages)
3. View Logs
4. View Connection Summary
5. Exit
Select option: 1
Connecting to wss://echo.websocket.org...
Connected.

=== WebSocket Profiler ===
1. Toggle Connection (On/Off): 🟢
2. Test Mode (Send Messages)
3. View Logs
4. View Connection Summary
5. Exit
Select option: Echo received: Request served by 4d896d95b55478

Select option: 2

--- Test Mode ---
Type messages. Type "back" to return.
> Hi
Echo received: Hi

Type messages. Type "back" to return.
> Hello!!
Echo received: Hello!!

Type messages. Type "back" to return.
> How are you?
Echo received: How are you?

Type messages. Type "back" to return.
> xox
Echo received: xox

Type messages. Type "back" to return.
> back
=== WebSocket Profiler ===
1. Toggle Connection (On/Off): 🟢
2. Test Mode (Send Messages)
3. View Logs
4. View Connection Summary
5. Exit
Select option: 1
Disconnected.

=== WebSocket Profiler ===
1. Toggle Connection (On/Off): 🔴
2. Test Mode (Send Messages)
3. View Logs
4. View Connection Summary
5. Exit
Select option: 3

--- Recent WebSocket Events ---
logs:

TIME          DIR  | TYPE   | SIZE       | LABEL            | LATENCY
-------------------------------------------------------------------
[12:34:13.112] LC  | BINARY | 0 bytes    | connected        |
[12:34:13.112] IN  | TEXT   | 32 bytes   | server greeting  |
[12:34:23.837] OUT | TEXT   | 2 bytes    | sent             |
[12:34:24.015] IN  | TEXT   | 2 bytes    | received         | 178 ms
[12:34:30.489] OUT | TEXT   | 7 bytes    | sent             |
[12:34:30.717] IN  | TEXT   | 7 bytes    | received         | 227 ms
[12:34:40.831] OUT | TEXT   | 12 bytes   | sent             |
[12:34:40.999] IN  | TEXT   | 12 bytes   | received         | 168 ms
[12:34:43.315] OUT | TEXT   | 3 bytes    | sent             |
[12:34:43.485] IN  | TEXT   | 3 bytes    | received         | 170 ms
[12:34:49.461] LC  | BINARY | 0 bytes    | disconnected     |

json:

[
  {
    "timestamp": "2026-03-23T12:34:13.112314",
    "direction": "internal",
    "type": "binary",
    "size": 0,
    "label": "connected",
    "latency_ms": null
  },
  {
    "timestamp": "2026-03-23T12:34:13.112314",
    "direction": "incoming",
    "type": "text",
    "size": 32,
    "label": "server greeting",
    "latency_ms": null
  },
  {
    "timestamp": "2026-03-23T12:34:23.837267",
    "direction": "outgoing",
    "type": "text",
    "size": 2,
    "label": "sent",
    "latency_ms": null
  },
  {
    "timestamp": "2026-03-23T12:34:24.015850",
    "direction": "incoming",
    "type": "text",
    "size": 2,
    "label": "received",
    "latency_ms": 178
  },
  {
    "timestamp": "2026-03-23T12:34:30.489416",
    "direction": "outgoing",
    "type": "text",
    "size": 7,
    "label": "sent",
    "latency_ms": null
  },
  {
    "timestamp": "2026-03-23T12:34:30.717343",
    "direction": "incoming",
    "type": "text",
    "size": 7,
    "label": "received",
    "latency_ms": 227
  },
  {
    "timestamp": "2026-03-23T12:34:40.831068",
    "direction": "outgoing",
    "type": "text",
    "size": 12,
    "label": "sent",
    "latency_ms": null
  },
  {
    "timestamp": "2026-03-23T12:34:40.999620",
    "direction": "incoming",
    "type": "text",
    "size": 12,
    "label": "received",
    "latency_ms": 168
  },
  {
    "timestamp": "2026-03-23T12:34:43.315407",
    "direction": "outgoing",
    "type": "text",
    "size": 3,
    "label": "sent",
    "latency_ms": null
  },
  {
    "timestamp": "2026-03-23T12:34:43.485827",
    "direction": "incoming",
    "type": "text",
    "size": 3,
    "label": "received",
    "latency_ms": 170
  },
  {
    "timestamp": "2026-03-23T12:34:49.461520",
    "direction": "internal",
    "type": "binary",
    "size": 0,
    "label": "disconnected",
    "latency_ms": null
  }
]
-------------------------------

=== WebSocket Profiler ===
1. Toggle Connection (On/Off): 🔴
2. Test Mode (Send Messages)
3. View Logs
4. View Connection Summary
5. Exit
Select option: 4

--- Connection Summary ---

--- WebSocket Connection Summary ---
Connection Started: 2026-03-23 12:34:13.112314
Connection Closed : 2026-03-23 12:34:49.461520
Duration          : 36s
Messages Sent     : 4
Messages Received : 5
Bytes Sent        : 24
Bytes Received    : 56
Avg Latency       : 185.75 ms
Close Reason      : Connection closed normally
json:
{
  "connected_at": "2026-03-23T12:34:13.112314",
  "closed_at": "2026-03-23T12:34:49.461520",
  "duration_sec": 36,
  "messages_sent": 4,
  "messages_received": 5,
  "bytes_sent": 24,
  "bytes_received": 56,
  "avg_latency_ms": 185.75,
  "error": false,
  "close_reason": "Connection closed normally"
}
-----------------------------------

=== WebSocket Profiler ===
1. Toggle Connection (On/Off): 🔴
2. Test Mode (Send Messages)
3. View Logs
4. View Connection Summary
5. Exit
Select option: 5
Goodbye!
```

---

# Running Locally

## 1️) Prerequisites

Dart SDK ≥ 3.x
Check:
`dart --version`

---

## 2️) Install Dependencies

From project root:
`dart pub get`

---

## 3️) Run the CLI

`dart run bin/main.dart`

---

# 📌 Conclusion

This prototype successfully demonstrates:

- Real-time WebSocket frame profiling
- Clean architectural separation
- Async-safe CLI design
- DevTools-compatible interception foundation
- Human-friendly profiling (formatted CLI logs with latency, lifecycle, color)
- Machine-readable output (JSON logs & summaries)
- Testing & Licensing support (v4)

It provides a solid base for expanding WebSocket support in Dart DevTools or evolving into a standalone WebSocket analysis tool.

# 🔗 Discussions

Follow development updates in [Discussions → Progress Log](https://github.com/Victowolf/profileable_websocket/discussions/1)