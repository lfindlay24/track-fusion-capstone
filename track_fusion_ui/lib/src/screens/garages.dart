import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/main_drawer.dart';

class Garages extends StatelessWidget {
  static const routeName = '/garages';

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
      body: Expanded(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: MessageBox(),
          ),
        ),
      ),
      drawer: MainDrawer(),
    );
  }
}

class MessageBox extends StatelessWidget {

  final TextEditingController _messageController =
    TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  TextField(
        controller: _messageController,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              debugPrint('Message sent');
              debugPrint(_messageController.text);
            },
          ),
          border: OutlineInputBorder(),
          labelText: 'Message',
        ),
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

    return Column();
  }
}
