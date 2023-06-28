import 'package:app/screens/connect.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  // Ensure that Flutter initializes the necessary bindings
  WidgetsFlutterBinding.ensureInitialized();
  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
    return const MaterialApp(
      title: 'WebSocket Flutter Demo',
      home: Connect(),
    );
  }
}
