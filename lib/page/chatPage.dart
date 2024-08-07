import 'package:firebase_miner/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../helper/database.dart';
import '../model/chat_model.dart';
import '../model/userModel.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController controller = TextEditingController();
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel userModel =
        ModalRoute.of(context)!.settings.arguments as UserModel;
    return Scaffold(
      appBar: AppBar(
        title: Text(userModel.displayName),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FireDatabase.fireDatabase.getChats(userModel: userModel),
              builder: (context, snapShots) {
                if (snapShots.hasData) {
                  List<ChatModel> chats = snapShots.data?.docs
                          .map(
                            (e) => ChatModel.fromMap(
                              e.data(),
                            ),
                          )
                          .toList() ??
                      [];
                  return ListView.builder(
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onLongPress: () {
                          if (chats[index].type == 'sent') {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: GestureDetector(
                                  onTap: () {
                                    FireDatabase.fireDatabase.deleteChat(
                                      userModel: userModel,
                                      chat: chats[index],
                                    );
                                    Navigator.pop(context);
                                  },
                                  child: const Row(
                                    children: [
                                      Text(
                                        'Delete',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        child: Align(
                          alignment: chats[index].type == 'sent'
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.all(8.0),
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: chats[index].type == 'sent'
                                  ? Colors.blueAccent
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              crossAxisAlignment: chats[index].type == 'sent'
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  chats[index].msg,
                                  style: TextStyle(
                                      color: chats[index].type == 'sent'
                                          ? Colors.white
                                          : Colors.black),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  chats[index].time.pickTime,
                                  style: TextStyle(
                                      color: chats[index].type == 'sent'
                                          ? Colors.white70
                                          : Colors.black54,
                                      fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onSubmitted: (val) {
                      if (controller.text != '') {
                        FireDatabase.fireDatabase
                            .sendChat(
                              user: userModel,
                              chat: ChatModel(
                                DateTime.now(),
                                controller.text,
                                'sent',
                                'unseen',
                              ),
                            )
                            .then(
                              (value) => controller.clear(),
                            );
                      }
                      scrollController.animateTo(
                        scrollController.position.maxScrollExtent,
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeInOut,
                      );
                    },
                    scrollController: scrollController,
                    textInputAction: TextInputAction.send,
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (controller.text != '') {
                      FireDatabase.fireDatabase
                          .sendChat(
                            user: userModel,
                            chat: ChatModel(
                              DateTime.now(),
                              controller.text,
                              'sent',
                              'unseen',
                            ),
                          )
                          .then(
                            (value) => controller.clear(),
                          );
                    }

                    scrollController.animateTo(
                      scrollController.position.maxScrollExtent,
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
