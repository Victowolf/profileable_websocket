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

---

# Objective

The goal of this prototype is to:

- Demonstrate frame-level WebSocket logging
- Maintain a bounded event buffer
- Provide a menu-driven CLI interface
- Simulate how DevTools-style network profiling could work
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
│   └── profileable_websocket.dart # WebSocket wrapper (core logic)
│
└── pubspec.yaml

```
---

# Demo Run Flow

```
Connecting to wss://echo.websocket.org...  
Connected!

=== WebSocket Profiler ===  
1. Test Mode (Send Messages)  
2. View Logs  
3. Exit  
Select option: 1  

--- Test Mode ---  
Type messages. Type "back" to return.

> hi  
Echo received: hi  

> back  

=== WebSocket Profiler ===  
1. Test Mode (Send Messages)  
2. View Logs  
3. Exit  
Select option: 2  

--- Recent WebSocket Events ---  
[20:56:43.435] IN  | TEXT   | 32 bytes (server greeting received)  
[20:56:52.902] OUT | TEXT   | 2 bytes  
[20:56:53.104] IN  | TEXT   | 2 bytes  
-------------------------------
```

---

# Features Implemented

- Frame-level interception
- IN / OUT classification
- Byte size tracking
- Timestamp precision (milliseconds)
- Server greeting annotation
- Bounded buffer (FIFO)
- Async-safe CLI
- Menu-driven UX
- Clean shutdown handling

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