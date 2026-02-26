import 'dart:convert';
import 'dart:io';

import 'package:websocket_profiler/profileable_websocket.dart';

enum AppMode { menu, test }

Future<void> main() async {
  const url = 'wss://echo.websocket.org';

  print('Connecting to $url...');
  final socket = await ProfileableWebSocket.connect(url);
  print('Connected!\n');

  AppMode mode = AppMode.menu;

  void showMenu() {
    print('\n=== WebSocket Profiler ===');
    print('1. Test Mode (Send Messages)');
    print('2. View Logs');
    print('3. Exit');
    stdout.write('Select option: ');
  }

  socket.listen((data) {
    print('Echo received: $data\n');

    if (mode == AppMode.menu) {
      stdout.write('Select option: ');
    } else if (mode == AppMode.test) {
      stdout.write('Type messages. Type "back" to return.\n> ');
    }
  });

  showMenu();

  await for (final line
      in stdin.transform(utf8.decoder).transform(const LineSplitter())) {
    if (mode == AppMode.menu) {
      if (line == '1') {
        mode = AppMode.test;
        print('\n--- Test Mode ---');
        print('');
        stdout.write('Type messages. Type "back" to return.\n> ');
      } else if (line == '2') {
        print('\n--- Recent WebSocket Events ---');

        final events = socket.recentEvents;
        if (events.isEmpty) {
          print('No events recorded yet.');
        } else {
          for (final event in events) {
            print(event.formatted);
          }
        }

        print('-------------------------------\n');
        showMenu();
      } else if (line == '3') {
        await socket.close();
        print('Disconnected.');
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
        socket.add(line);
      }
    }
  }
}
