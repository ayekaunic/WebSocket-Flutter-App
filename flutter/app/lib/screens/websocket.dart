import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

TextEditingController _controller = TextEditingController();

final FlutterLocalNotificationsPlugin _notifications =
    FlutterLocalNotificationsPlugin();

// Configure the Android initialization settings for the notification plugin
const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

// Create the initialization settings for the notifications plugin
const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

// ignore: must_be_immutable
class WebSocketScreen extends StatelessWidget {
  final IOWebSocketChannel webSocketChannel;
  final String username;
  WebSocketScreen(
      {super.key, required this.webSocketChannel, required this.username});

  // Method to send data to the server
  void _sendMessage(WebSocketChannel webSocketChannel) {
    if (_controller.text.isNotEmpty) {
      webSocketChannel.sink.add(_controller.text);
      _controller.text = '';
    }
  }

  bool _five = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        webSocketChannel.sink.close();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('WebSocket Server'),
        ),
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
                stream: webSocketChannel.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    // Show a push notification when error returned while trying to connect to server
                    _showNotification(
                      title: 'Error!',
                      body: "Couldn't connect to server.",
                    );
                    return SelectableText('Error:\n${snapshot.error}');
                  }
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return const Text('Not connected.');
                    case ConnectionState.waiting:
                      return const Text('Waiting for connection...');
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        String message = snapshot.data.toString();
                        // Show a push notification when a message is received
                        if (message == "Hello, client!") {
                          _showNotification(
                            title: 'Server connected!',
                            body: 'Hello, $username!',
                          );
                          message = "Hello, $username!";
                        } else if (_five) {
                          Future.delayed(const Duration(seconds: 5), () {
                            _showNotification(
                              title: 'Server',
                              body: message,
                            );
                          });
                        } else {
                          _showNotification(
                            title: 'Server',
                            body: message,
                          );
                        }
                        return Text('Server: $message');
                      }
                      return const Text('No data received yet.');
                    case ConnectionState.done:
                      // Show a push notification when connection is closed
                      _showNotification(
                        title: 'Connection closed.',
                        body: '',
                      );
                      return const Text('Connection closed.');
                  }
                },
              ),
            ],
          ),
        ),
        floatingActionButton: Wrap(
          direction: Axis.vertical,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(10),
              child: FloatingActionButton(
                tooltip: "Instant",
                onPressed: () {
                  _five = false;
                  _sendMessage(webSocketChannel);
                },
                child: const Icon(Icons.send),
              ),
            ),
            // to check if push notifs showing when app running in the background
            Container(
              margin: const EdgeInsets.all(10),
              child: FloatingActionButton(
                tooltip: "5 seconds",
                onPressed: () {
                  _five = true;
                  _sendMessage(webSocketChannel);
                },
                child: const Icon(Icons.slow_motion_video),
              ),
            ),
          ],
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
      priority: Priority.max,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Initialize the FlutterLocalNotificationsPlugin with the initialization settings
    _notifications.initialize(initializationSettings);
    // Show the notification using the FlutterLocalNotificationsPlugin
    await _notifications.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }
}
