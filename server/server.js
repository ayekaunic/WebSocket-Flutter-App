const WebSocket = require('ws');

const wss = new WebSocket.Server({ port: 8080 });

wss.on('connection', (ws) => {
  console.log('Client connected.');
  
  // send a message to the client
  ws.send('Hello, client!');
  
  // handle incoming messages from the client
  ws.on('message', (message) => {
    console.log(`Received message: ${message}`);
    ws.send(message.toString());
  });
  
  // handle client disconnection
  ws.on('close', () => {
    console.log('Client disconnected.');
  });
});
