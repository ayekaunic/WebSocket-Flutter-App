const WebSocket = require('ws');

const wss = new WebSocket.Server({ port: 8080 });

wss.on('connection', (ws) => {
  console.log('Client connected!');
  
  // send hello message to client
  ws.send('Hello, client!');
  
  // handle incoming messages from client
  ws.on('message', (message) => {
    console.log(`Received message: ${message}`);

    if (message.toString()=='/time') {
      ws.send(new Date().toLocaleTimeString());
    } else if (message.toString()=='/date') {
      ws.send(new Date().toDateString().substring(4));
    } else if (message.toString()=='/day') {
      switch (new Date().getDay()) {
        case 1:
          ws.send('Monday');
          break;
        case 2:
          ws.send('Tuesday');
          break;
        case 3:
          ws.send('Wednesday');
          break;
        case 4:
          ws.send('Thursday');
          break;
        case 5:
          ws.send('Friday, happy weekend!');
          break;
        case 6:
          ws.send('Saturday');
          break;
        case 7:
          ws.send('Sunday');
          break;
        default:
          ws.send("Yesterday is history, tomorrow is a mystery. Today is a gift, that's why they call it the present!");
          break;
      }
    } else {
      ws.send(message.toString());
    }
  });
  
  // handle client disconnection
  ws.on('close', () => {
    console.log('Client disconnected.');
  });
});
