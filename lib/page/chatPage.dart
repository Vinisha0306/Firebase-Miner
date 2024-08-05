import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatPage extends StatelessWidget {
  final List<types.Message> messages = [];
  final types.User user = types.User(id: 'user-id');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Chat(
        messages: messages,
        onSendPressed: (message) {
          // Add message to the list
          messages.add(message as types.Message);
        },
        user: user,
      ),
    );
  }
}
