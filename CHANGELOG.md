# Changelog

All notable changes to the WebSocket Profiler project will be documented in this file.

---
## [Version 4] – Tests, CHANGELOG & Licensing

**Date:** 2026-03-25

### Added
- **Unit tests** (`profileable_websocket_test.dart`) covering:
  - Frame logging and direction detection
  - Latency tracking and aggregation
  - Event and summary JSON serialization
- **CHANGELOG.md** to track prototype version history and milestones
- **LICENSE.md** (MIT) to clarify usage and distribution terms

---

## [Version 3] – Latency Profiling & Structured Logging

**Date:** 2026-03-23

### Added
- Per-message **latency tracking** (OUT → IN)
- Average latency reporting in **connection summary**
- JSON serialization via `toJson()` for:
  - WebSocket events
  - Connection summary
- Machine-friendly log export (structured JSON)
- Column-aligned CLI output with latency column
- **Color-coded logs** for key lifecycle events and message types

---

## [Version 2] – Lifecycle & Connection Profiling

**Date:** 2026-03-19

### Added
- Lifecycle hooks:
  - `connected`, `disconnected`, `error`
- Connection summary:
  - Duration, total messages sent/received, byte totals, close reason
- Log viewing now includes lifecycle markers
- CLI option to toggle connection (On/Off)
- Separation of `recentEvents` and persistent `ConnectionSummary`

---

## [Version 1] – Frame-Level Logging

**Date:** 2026-02-26

### Added
- Wrapper around `dart:io WebSocket` using Decorator pattern
- Intercepted `add()` (OUT) and `listen()` (IN)
- Timestamped frame logging
- Frame direction, size, and type detection (TEXT/BINARY)
- FIFO event buffer (bounded)
- CLI interface with menu-driven testing and viewing

---