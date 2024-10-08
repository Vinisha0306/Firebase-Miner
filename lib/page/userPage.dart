import 'package:firebase_miner/page/HomePage.dart';
import 'package:firebase_miner/page/profilePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../controller/themeController.dart';
import '../helper/auth_model.dart';
import '../helper/database.dart';
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
        backgroundColor: Provider.of<ThemeController>(context).isdark
            ? Colors.black
            : Colors.white,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                },
                child: const ListTile(
                  leading: Icon(
                    CupertinoIcons.chat_bubble_2_fill,
                  ),
                  title: Text('Chats'),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const ListTile(
                  leading: Icon(
                    CupertinoIcons.profile_circled,
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
                  ),
                  title: Text('Log Out'),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ThemeController>(context, listen: false)
                  .ChangeTheme();
            },
            icon: Provider.of<ThemeController>(context).isdark
                ? const Icon(
                    Icons.sunny,
                  )
                : const Icon(
                    CupertinoIcons.moon_fill,
                  ),
          ),
        ],
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
            // List<ChatModel> allChats;
            //
            // if (allUsers.isNotEmpty) {
            //   allChats =
            //       FireDatabase.fireDatabase.getAllUserLastChat(users: allUsers);
            // } else {
            //   allChats = List.generate(
            //       allUsers.length,
            //       (index) => ChatModel(
            //           DateTime.now(), 'No Any Chat Yet!!', 'sent', 'unSeen'));
            // }
            return ListView.builder(
              itemCount: allUsers.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  FireDatabase.fireDatabase
                      .addFriends(user: allUsers[index])
                      .then(
                        (value) => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor:
                                Provider.of<ThemeController>(context).isdark
                                    ? Colors.black
                                    : Colors.white,
                            title: const Text('Add Successful in Friend..!.'),
                            content: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Image(
                                image: AssetImage('lib/assests/added.png'),
                                width: 70,
                              ),
                            ),
                          ),
                        ),
                      );
                  // .then((value) {
                  //   if (allUsers.isNotEmpty) {
                  //     allChats = FireDatabase.fireDatabase
                  //         .getAllUserLastChat(users: allUsers);
                  //     print("allChats :: ${allChats[allChats.length - 1].msg}");
                  //   } else {
                  //     allChats = List.generate(
                  //       allUsers.length,
                  //       (index) => ChatModel(DateTime.now(),
                  //           'No Any Chat Yet!!', 'sent', 'unSeen'),
                  //     );
                  //   }
                  //   setState(() {});
                  // }
                },
                child: ListTile(
                  leading: CircleAvatar(
                    foregroundImage: NetworkImage(
                      allUsers[index].photoURL,
                    ),
                  ),
                  subtitle: Text(
                    allUsers[index].email,
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
