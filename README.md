# WebSocket Flutter App with Server
This project consists of a Flutter application and a WebSocket server that facilitate real-time communication between a client (app) and a server. The Flutter app connects to the WebSocket server and sends messages to it. The server, in turn, echoes the received messages back to the client. Additionally, the Flutter app displays received messages and shows push notifications when new messages arrive.

## WebSocket Server
The WebSocket server is implemented using Node.js and the "ws" library. It listens for incoming WebSocket connections on port 8080.

## Flutter App
The Flutter app serves as the WebSocket client and provides a user interface to send messages and receive responses. It also displays received messages and shows push notifications.
