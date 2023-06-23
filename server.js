const WebSocket = require("ws");

const wss = new WebSocket.WebSocketServer({ port: 8080 });

wss.on('connection', (ws) => {
    console.log('Client connected.');

    // send message to client
    ws.send('Hello, client!');

    // handle incoming message from the client
    ws.on('message', (message) => {
        console.log('Received message: ' + message.toString());
        ws.send('Message received: ' + message.toString());
    });

    // handle client disconnection
    ws.on('close', () => {
        console.log('Client disconnected.');
    });
});