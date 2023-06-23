const WebSocket = require("ws");

const wss = new WebSocket.WebSocketServer({ port: 8080 });

wss.on('connection', (ws) => {
    console.log('Client connected.');

    // handle incoming message from the client
    ws.on('message', (message) => {
        console.log('Received message: ${message}');
    });

    // send message to client
    ws.send('Hello, client!');

    // handle client disconnection
    ws.on('close', () => {
        console.log('Client disconnected.');
    });
});