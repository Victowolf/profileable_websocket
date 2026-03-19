# WebSocket Profiler (Dart CLI Prototype)

A lightweight, standalone Dart CLI prototype that demonstrates **frame-level WebSocket profiling** without modifying the Dart SDK.

This project was built as a proof-of-concept for instrumenting WebSocket traffic at user-space level using the **Decorator (Wrapper) pattern**.

It intercepts:

- Outgoing frames (`add()`)
- Incoming frames (`listen()`)

And records:

- Timestamp
- Direction (IN / OUT)
- Frame type (TEXT / BINARY)
- Size (bytes)
- System frame classification (e.g., server greeting)
- Lifecycle events (connect, disconnect, error)

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
│   ├── websocket_event.dart       # Frame event model + formatting
│   ├── event_buffer.dart          # Bounded FIFO event storage
|   ├── connection_summary.dart    # Connection stats model + printer
│   └── profileable_websocket.dart # WebSocket wrapper (core logic)
│
└── pubspec.yaml

```
---

# Demo Run Flow

```
PS D:\imp\projects\internship\websocket_profiler> dart run bin/main.dart
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
> hii
Echo received: hii

Type messages. Type "back" to return.
> hello
Echo received: hello

Type messages. Type "back" to return.
> how are you?
Echo received: how are you?

Type messages. Type "back" to return.
> x0x
Echo received: x0x

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
[13:16:26.564] LC  | BINARY | 0 bytes    | connected
[13:16:26.564] IN  | TEXT   | 32 bytes   | server greeting
[13:16:31.499] OUT | TEXT   | 3 bytes    | sent
[13:16:31.744] IN  | TEXT   | 3 bytes    | received
[13:16:34.843] OUT | TEXT   | 5 bytes    | sent
[13:16:35.094] IN  | TEXT   | 5 bytes    | received
[13:16:39.582] OUT | TEXT   | 12 bytes   | sent
[13:16:39.822] IN  | TEXT   | 12 bytes   | received
[13:16:44.779] OUT | TEXT   | 3 bytes    | sent
[13:16:45.022] IN  | TEXT   | 3 bytes    | received
[13:16:53.545] LC  | BINARY | 0 bytes    | disconnected
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
Connection Started: 2026-03-19 13:16:26.564561
Connection Closed : 2026-03-19 13:16:53.545171
Duration          : 26s
Messages Sent     : 4
Messages Received : 5
Bytes Sent        : 23
Bytes Received    : 55
Close Reason      : Connection closed normally
-----------------------------------

=== WebSocket Profiler ===
1. Toggle Connection (On/Off): 🔴
2. Test Mode (Send Messages)
3. View Logs
4. View Connection Summary
5. Exit
Select option: 5
Goodbye!
PS D:\imp\projects\internship\websocket_profiler> 
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

It provides a solid base for expanding WebSocket support in Dart DevTools or evolving into a standalone WebSocket analysis tool.