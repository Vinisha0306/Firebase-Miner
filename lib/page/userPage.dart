import 'package:firebase_miner/page/profilePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper/auth_model.dart';
import '../helper/database.dart';
import '../model/chat_model.dart';
import '../model/userModel.dart';
import 'login_page.dart';

class UserPage extends StatefulWidget {
  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: 40, left: 20),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    foregroundImage: NetworkImage(
                        FireDatabase.fireDatabase.currentUser.photoURL),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    FireDatabase.fireDatabase.currentUser.displayName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const Divider(),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const ListTile(
                  leading: Icon(
                    CupertinoIcons.chat_bubble_2_fill,
                    color: Colors.black,
                  ),
                  title: Text('Chats'),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserPage(),
                    ),
                  );
                },
                child: const ListTile(
                  leading: Icon(
                    CupertinoIcons.profile_circled,
                    color: Colors.black,
                  ),
                  title: Text('All User'),
                ),
              ),
              const Divider(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(),
                    ),
                  );
                },
                child: const ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Colors.black,
                  ),
                  title: Text('Setting'),
                ),
              ),
              GestureDetector(
                onTap: () {
                  AuthHelper.authHelper.logOut().then(
                    (value) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                  );
                },
                child: const ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                  title: Text('Log Out'),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('User Page'),
      ),
      body: StreamBuilder(
        stream: FireDatabase.fireDatabase.getAllUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<UserModel> allUsers = snapshot.data?.docs
                    .map((e) => UserModel.froMap(e.data()))
                    .toList() ??
                [];

            allUsers.removeWhere(
                (e) => FireDatabase.fireDatabase.currentUser.uid == e.uid);
            print('allUsers Length :: ${allUsers.length}');
            List<ChatModel> allChats;

            if (allUsers.isNotEmpty) {
              allChats =
                  FireDatabase.fireDatabase.getAllUserLastChat(users: allUsers);
            } else {
              allChats = List.generate(
                  allUsers.length,
                  (index) => ChatModel(
                      DateTime.now(), 'No Any Chat Yet!!', 'sent', 'unSeen'));
            }
            return ListView.builder(
              itemCount: allUsers.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/chat',
                    arguments: allUsers[index],
                  );
                },
                child: ListTile(
                  leading: CircleAvatar(
                    foregroundImage: NetworkImage(
                      allUsers[index].photoURL,
                    ),
                  ),
                  subtitle: Text(
                    allChats[index].msg,
                  ),
                  title: Text(
                    allUsers[index].displayName,
                  ),
                ),
              ),
            );
          } else {
            return const Center();
          }
        },
      ),
    );
  }
}
