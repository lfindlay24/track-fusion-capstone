import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/main_drawer.dart';

class Garages extends StatefulWidget {
  static const routeName = '/garages';

  @override
  State<StatefulWidget> createState() => GaragesState();
}

class GaragesState extends State<Garages> {
  final textMessageController = TextEditingController();

  final List<String> _messages = [];

  void _addMessage(String message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Garages',
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              shrinkWrap: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return MessageDisplay(message: _messages[index]);
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
        )
      );
  }
}

class MessageDisplay extends StatelessWidget {
  final String message;

  const MessageDisplay({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(message),
      ),
    );
  }
}
