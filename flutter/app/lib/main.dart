import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final _channel = IOWebSocketChannel.connect('ws://192.168.1.2:8080');
TextEditingController _controller = TextEditingController();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// method to send data to the server
void _sendMessage() {
  if (_controller.text.isNotEmpty) {
    _channel.sink.add(_controller.text);
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<void> _showPushNotification(String message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'channel_description',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Message received by server!',
      message,
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebSocket Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('WebSocket Demo')),
        body: Padding(
          padding: const EdgeInsets.all(23),
          child: Column(
            children: [
              Form(
                child: TextFormField(
                  controller: _controller,
                  decoration: const InputDecoration(
                      labelText: 'Send a message to the server'),
                ),
              ),
              const SizedBox(height: 23),
              StreamBuilder(
                stream: _channel.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return SelectableText('Error: ${snapshot.error}');
                  }
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return const SelectableText('Not connected.');
                    case ConnectionState.waiting:
                      return const SelectableText('Waiting for connection...');
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final message = snapshot.data.toString();
                        _showPushNotification(message);
                        return SelectableText('WebSocket Server: $message');
                      }
                      return const Text('No data received yet.');
                    case ConnectionState.done:
                      return const SelectableText('Connection closed.');
                  }
                },
              ),
            ],
          ),
        ),
        floatingActionButton: const FloatingActionButton.large(
          onPressed: _sendMessage,
          child: Icon(Icons.send),
        ),
      ),
    );
  }
}
