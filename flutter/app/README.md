# WebSocket Flutter App with Push Notifications
This is a Flutter application that demonstrates a WebSocket client-server communication. The app connects to a WebSocket server and sends messages to it. When a message is received from the server, a push notification is displayed on the device.

## Usage
1. Ensure that the WebSocket server is running and accessible at the specified address (ws://192.168.1.7:8080 in this example).
2. Launch the app on a connected device or emulator using flutter run.
3. The app interface will display a text input field to send messages to the server.
4. Whenever a message is received from the server, a push notification will be displayed on the device.
5. Tap the floating action button with the send icon to send a message to the server.
6. The received messages from the server will be displayed in the app interface along with the prefix "Server: ".

## Implementation Details
The code is divided into the following sections:
- WebSocket Channel Setup: The WebSocket channel is created using IOWebSocketChannel.connect() to connect to the specified server address. An onError callback is added to handle any connection errors.
- Notification Plugin Initialization: The FlutterLocalNotificationsPlugin is initialized with appropriate Android settings for push notifications.
- Main App Widget: The MyApp widget represents the main application. It sets up the app interface and handles the WebSocket communication. The user can input messages to send to the server, and received messages are displayed along with push notifications.
- Sending Messages: The _sendMessage() method is called when the send button is pressed. It sends the message from the text input field to the server using the WebSocket channel.
- Receiving Messages: The StreamBuilder listens to the WebSocket channel's stream and updates the UI based on the connection state and received messages. When a message is received, a push notification is shown using the _showNotification() method.
- Showing Push Notifications: The _showNotification() method creates and displays a push notification with the provided title and body using the FlutterLocalNotificationsPlugin.

## Notes
1. Make sure to replace the server address (ws://192.168.1.7:8080) with the actual address of your WebSocket server.
2. Customize the notification channel ID, name, and description according to your requirements.
3. Ensure that the necessary Android resources (app icon) are present in the project for push notifications to work correctly.
4. Feel free to modify the code to fit your specific needs and explore additional features and enhancements for your WebSocket app.
