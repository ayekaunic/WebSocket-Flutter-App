import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

final channel = IOWebSocketChannel.connect('ws://192.168.1.5:8080');

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebSocket Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('WebSocket Demo')),
        body: StreamBuilder(
          stream: channel.stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Text('Not connected.');
              case ConnectionState.waiting:
                return const Text('Waiting for connection...');
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final message = snapshot.data.toString();
                  return Text('Received: $message');
                }
                return const Text('No data received yet.');
              case ConnectionState.done:
                return const Text('Connection closed.');
            } // Empty container if none of the cases match
          },
        ),
      ),
    );
  }
}
