import 'dart:convert';
import 'dart:io';

import 'package:websocket_profiler/profileable_websocket.dart';

enum AppMode { menu, test }

Future<void> main() async {
  const url = 'wss://echo.websocket.org';

  AppMode mode = AppMode.menu;
  ProfileableWebSocket? socket;
  ProfileableWebSocket? lastSocket;
  bool isConnected = false;

  void showMenu() {
    final statusIcon = isConnected ? '🟢' : '🔴';
    print('=== WebSocket Profiler ===');
    print('1. Toggle Connection (On/Off): $statusIcon');
    print('2. Test Mode (Send Messages)');
    print('3. View Logs');
    print('4. View Connection Summary');
    print('5. Exit');
    stdout.write('Select option: ');
  }

  showMenu();

  await for (final line
      in stdin.transform(utf8.decoder).transform(const LineSplitter())) {
    if (mode == AppMode.menu) {
      if (line == '1') {
        if (!isConnected) {
          print('Connecting to $url...');
          socket = await ProfileableWebSocket.connect(url);
          lastSocket = socket;
          isConnected = true;

          socket.listen((data) {
            print('Echo received: $data\n');
            if (mode == AppMode.menu) {
              stdout.write('Select option: ');
            } else if (mode == AppMode.test) {
              stdout.write('Type messages. Type "back" to return.\n> ');
            }
          });

          print('Connected.\n');
        } else {
          await socket!.close();
          socket = null;
          isConnected = false;
          print('Disconnected.\n');
        }
        showMenu();
      } else if (line == '2') {
        if (!isConnected) {
          print('Please connect first.\n');
          showMenu();
          continue;
        }
        mode = AppMode.test;
        print('\n--- Test Mode ---');
        stdout.write('Type messages. Type "back" to return.\n> ');
      } else if (line == '3') {
        print('\n--- Recent WebSocket Events ---');
        final events = lastSocket?.recentEvents ?? [];
        if (events.isEmpty) {
          print('No events recorded yet.');
        } else {
          for (final event in events) {
            print(event.formatted);
          }
        }
        print('-------------------------------\n');
        showMenu();
      } else if (line == '4') {
        print('\n--- Connection Summary ---');
        if (lastSocket == null) {
          print('No connection history available.');
        } else {
          lastSocket.summary.printSummary();
        }
        showMenu();
      } else if (line == '5') {
        if (isConnected && socket != null) {
          await socket.close();
        }
        print('Goodbye!');
        break;
      } else {
        print('Invalid option.');
        showMenu();
      }
    } else if (mode == AppMode.test) {
      if (line.toLowerCase() == 'back') {
        mode = AppMode.menu;
        showMenu();
      } else {
        socket?.add(line);
      }
    }
  }
}
