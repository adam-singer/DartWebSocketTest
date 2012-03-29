#import('dart:html');

class WebSocketTest {

  WebSocket webSocket;
  String wsUri = "ws://echo.websocket.org";
  InputElement inputUri;
  InputElement checkedSecure;
  ButtonElement connect;
  ButtonElement disconnect;
  ButtonElement send;
  InputElement sendMessage;
  ButtonElement clearLog;
  Element consoleLog;
  
  WebSocketTest() {

  }

  void run() {
    inputUri = document.query("#wsUri");
    checkedSecure = document.query("#secureCb");
    connect = document.query("#connect");
    disconnect = document.query("#disconnect");
    send = document.query("#send");
    sendMessage = document.query("#sendMessage");
    clearLog = document.query("#clearLogBut");
    consoleLog = document.query("#consoleLog");
    
    inputUri.value = wsUri;
    disconnect.disabled = true;
    
    checkedSecure.on.click.add((var event) {
      if (checkedSecure.checked) {
        wsUri = "wss://echo.websocket.org";
      } else {
        wsUri = "ws://echo.websocket.org";
      }
      
      inputUri.value = wsUri;
    });
    
    connect.on.click.add((e) {
      print("connecting");
      consoleLog.elements.add(new Element.html("<p>connecting</p>"));
      webSocket = new WebSocket(wsUri);
      
      webSocket.on.open.add((o) {
        consoleLog.elements.add(new Element.html("<p>opened</p>"));
        disconnect.disabled = false;
        connect.disabled = true;
        send.disabled = false;
        sendMessage.disabled = false;
      });
      
      webSocket.on.close.add((c) {
        consoleLog.elements.add(new Element.html("<p>disconnecting</p>"));
        
        disconnect.disabled = true;
        connect.disabled = false;
        send.disabled = true;
        sendMessage.disabled = true;
      });
      
      webSocket.on.message.add((MessageEvent m) =>
        consoleLog.elements.add(new Element.html("<p>${m.data}</p>")));
      
      webSocket.on.error.add((er) =>
        consoleLog.elements.add(new Element.html("<p>${er}</p>")));
      
    });
        
    disconnect.on.click.add((_) => webSocket.close());
    
    send.on.click.add((_) {
      if (webSocket.readyState == WebSocket.OPEN) {
        webSocket.send(sendMessage.value);
      }
    });
    
    clearLog.on.click.add((_) => consoleLog.elements.clear());
  }


}

void main() {
  new WebSocketTest().run();
}
