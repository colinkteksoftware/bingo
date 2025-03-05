import 'dart:io';
import 'dart:typed_data';

void inicioProceso() async {
  // bind the socket server to an address and port
  var address = new InternetAddress('192.168.5.100');
  final server = await ServerSocket.bind(address, 1234);

  // listen for clent connections to the server
  server.listen((client) {
    handleConnection(client);
  });
}

void handleConnection(Socket client) {
  print('Connection from'
      ' ${client.remoteAddress.address}:${client.remotePort}');

  // listen for events from the client
  client.listen(
    // handle data from the client
    (Uint8List data) async {
      await Future.delayed(Duration(seconds: 1));
      final message = String.fromCharCodes(data);

      if (message.length == 528) {
        print(message.length.toString());
        print(message);
        // Trama = message;
      }
    },

    // handle errors
    onError: (error) {
      print(error);
      client.close();
    },

    // handle the client closing the connection
    onDone: () {
      client.close();
    },
  );
}
