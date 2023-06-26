import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:web_socket_channel/io.dart';

var _channel = IOWebSocketChannel.connect('ws://192.168.1.7:8080');
TextEditingController _controller = TextEditingController();
final FlutterLocalNotificationsPlugin _notifications =
    FlutterLocalNotificationsPlugin();

// method to send data to the server
void _sendMessage() {
  if (_controller.text.isNotEmpty) {
    _channel.sink.add(_controller.text);
    _controller.text = '';
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  _notifications.initialize(initializationSettings);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
    return MaterialApp(
      title: 'WebSocket Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('WebSocket Server')),
        body: Padding(
          padding: const EdgeInsets.all(23),
          child: Column(
            children: [
              const SizedBox(height: 25),
              Form(
                child: TextFormField(
                  controller: _controller,
                  decoration:
                      const InputDecoration(labelText: 'Send a message'),
                ),
              ),
              const SizedBox(height: 23),
              StreamBuilder(
                stream: _channel.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return SelectableText('Error:\n${snapshot.error}');
                  }
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return const Text('Not connected.');
                    case ConnectionState.waiting:
                      return const Text('Waiting for connection...');
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final message = snapshot.data.toString();
                        _showNotification(
                          title: 'Server',
                          body: message,
                        );
                        return Text('Server: $message');
                      }
                      return const Text('No data received yet.');
                    case ConnectionState.done:
                      return const Text('Connection closed.');
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

  // Define the _showNotification method
  Future<void> _showNotification(
      {required String title, required String body}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'description',
      importance: Importance.max,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notifications.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }
}
