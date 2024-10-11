import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/main_drawer.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:track_fusion_ui/globals.dart' as globals;
import 'package:intl/intl.dart';

class Garages extends StatefulWidget {

  static const routeName = '/garages';

  @override
  State<StatefulWidget> createState() => GaragesState();
}

class GaragesState extends State<Garages> {
  var dropdownValue = 'Select Garage';

  final IO.Socket _socket = IO.io(
      'https://socket-server-63629209317.us-central1.run.app',
      IO.OptionBuilder().setTransports(['websocket']).build());

  final textMessageController = TextEditingController();

  final List<Message> _messages = [];

  _connectSocket() {
    _socket.onConnect((data) {
      print('Connected to WSS Server');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Connected to WSS Server')),
      );
    });
    _socket.onDisconnect((data) {
      print('Disconnected from WSS Server');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Disconnected from WSS Server')),
      );
    });
    _socket.onConnectError((data) {
      print('Connection error: $data');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error when connecting to WSS Server')),
      );
    });
    _socket.on('message', (data) {
      debugPrint('Message from WSS Server: $data');
      setState(() {
        _messages.insert(
            0,
            new Message(data['text'], data['user'],
                DateTime.fromMillisecondsSinceEpoch(data['time']).toLocal()));
      });
    });
  }

  _signIn(String groupName, String userName) {
    _socket.emit('signin', {
      'user': userName,
      'room': groupName,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Signed into group ' + groupName)),
    );
  }

  @override
  void initState() {
    super.initState();
    _connectSocket();
  }

  void _addMessage(String message) {
    _socket.emit('sendMessage', message);
  }

  @override
  Widget build(BuildContext context) {

    debugPrint("Current Garage: " + dropdownValue);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Garages',
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _signInPopUp(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            items: <String>['Select Garage', 'dOpEBdZ59s2iEwYkVkKr', 'Garage 2', 'Garage 3']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                dropdownValue = value!;
                _signIn(value, globals.userId);
              });
            },
            value: dropdownValue,
          ),
          Expanded(
            child: ListView.builder(
              reverse: true,
              shrinkWrap: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return Align(
                    alignment: _messages[index].user == globals.userId
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: MessageDisplay(message: _messages[index]));
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: MessageBox(textMessageController, this),
          ),
        ],
      ),
      drawer: MainDrawer(),
    );
  }

  Future<void> _signInPopUp(BuildContext context) {
    final groupController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('What Garage do you want to enter?'),
          content: TextField(
            controller: groupController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Title',
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Submit'),
              onPressed: () {
                _signIn(groupController.text, globals.userId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class Message {
  final String text;
  final String user;
  final DateTime dateTime;

  Message(this.text, this.user, this.dateTime);
}

class MessageBox extends StatelessWidget {
  late GaragesState parent;

  late TextEditingController _messageController;

  MessageBox(TextEditingController messageController, GaragesState parent) {
    _messageController = messageController;
    this.parent = parent;
  }

  void sendMessage() {
    debugPrint('Message sent');
    debugPrint(_messageController.text);
    parent._addMessage(_messageController.text);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
        textInputAction: TextInputAction.none,
        onSubmitted: (value) {
          sendMessage();
        },
        controller: _messageController,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              sendMessage();
            },
          ),
          border: OutlineInputBorder(),
          labelText: 'Message',
        ));
  }
}

class MessageDisplay extends StatelessWidget {
  final Message message;

  const MessageDisplay({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      margin: EdgeInsets.symmetric(vertical: 5),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
      decoration: BoxDecoration(
        color: message.user == globals.userId ? Colors.blue[200] : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Card(
        child: ListTile(
          dense: true,
          title: Text(message.text),
          subtitle: Text(message.user + ' - ' + DateFormat('HH:mm').format(message.dateTime)),
        ),
      ),
    );
  }
}
