import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

final _channel = IOWebSocketChannel.connect('ws://192.168.1.3:8080');
TextEditingController _controller = TextEditingController();

// method to send data to the server
void _sendMessage() {
  if (_controller.text.isNotEmpty) {
    _channel.sink.add(_controller.text);
    _controller.text = '';
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
                  } else {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return const SelectableText('Not connected.');
                      case ConnectionState.waiting:
                        return const SelectableText(
                            'Waiting for connection...');
                      case ConnectionState.active:
                        if (snapshot.hasData) {
                          final message = snapshot.data.toString();
                          return SelectableText('Server received: $message');
                        }
                        return const Text('No data received yet.');
                      case ConnectionState.done:
                        return const SelectableText('Connection closed.');
                    }
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
