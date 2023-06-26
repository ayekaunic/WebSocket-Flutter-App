import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:web_socket_channel/io.dart';

// Creating a WebSocket channel to connect to the server
var _webSocketChannel = IOWebSocketChannel.connect('ws://192.168.1.7:8080');

// Controller for the input text field
TextEditingController _controller = TextEditingController();

// Initialize the FlutterLocalNotificationsPlugin
final FlutterLocalNotificationsPlugin _notifications =
    FlutterLocalNotificationsPlugin();

// Method to send data to the server
void _sendMessage() {
  if (_controller.text.isNotEmpty) {
    _webSocketChannel.sink.add(_controller.text);
    _controller.text = '';
  }
}

void main() {
  // Ensure that Flutter initializes the necessary bindings
  WidgetsFlutterBinding.ensureInitialized();

  // Configure the Android initialization settings for the notification plugin
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // Create the initialization settings for the notifications plugin
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  // Initialize the FlutterLocalNotificationsPlugin with the initialization settings
  _notifications.initialize(initializationSettings);

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set the system UI mode to immersive sticky
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
              const SizedBox(height: 23),
              Form(
                child: TextFormField(
                  controller: _controller,
                  decoration: const InputDecoration(
                      labelText: 'Send a message, server will send it back'),
                ),
              ),
              const SizedBox(height: 23),
              StreamBuilder(
                stream: _webSocketChannel.stream,
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
                        // Show a push notification when a message is received
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

  // Method to show a notification
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

    // Show the notification using the FlutterLocalNotificationsPlugin
    await _notifications.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }
}
