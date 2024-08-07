import 'package:firebase_miner/page/userPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/themeController.dart';
import '../helper/auth_model.dart';
import '../helper/database.dart';
import '../model/userModel.dart';
import 'HomePage.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEdit = false;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  ),
                  title: Text('All User'),
                ),
              ),
              const Divider(),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
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
        title: const Text('Profile Page'),
        actions: [
          IconButton(
            onPressed: () {
              name.text = FireDatabase.fireDatabase.currentUser.displayName;
              email.text = FireDatabase.fireDatabase.currentUser.email;
              phone.text = FireDatabase.fireDatabase.currentUser.phoneNumber;
              setState(() {
                isEdit = true;
              });
            },
            icon: const Icon(
              Icons.edit,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: GestureDetector(
                  onTap: () {
                    if (isEdit) {
                      //pick image
                    }
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      FireDatabase.fireDatabase.currentUser.photoURL,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Name',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              isEdit
                  ? TextFormField(
                      controller: name,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    )
                  : Text(
                      FireDatabase.fireDatabase.currentUser.displayName,
                      style: const TextStyle(fontSize: 16),
                    ),
              const SizedBox(height: 20),
              const Text(
                'Email',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              isEdit
                  ? TextFormField(
                      controller: email,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    )
                  : Text(
                      FireDatabase.fireDatabase.currentUser.email,
                      style: TextStyle(fontSize: 16),
                    ),
              const SizedBox(height: 20),
              const Text(
                'Phone',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              isEdit
                  ? TextFormField(
                      controller: phone,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    )
                  : Text(
                      FireDatabase.fireDatabase.currentUser.phoneNumber,
                      style: const TextStyle(fontSize: 16),
                    ),
              const SizedBox(
                height: 20,
              ),
              Visibility(
                visible: isEdit,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      style: const ButtonStyle(
                        textStyle: MaterialStatePropertyAll(
                          TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          isEdit = false;
                        });
                      },
                      child: const Text(
                        'Cancel',
                      ),
                    ),
                    ElevatedButton(
                      style: const ButtonStyle(
                        textStyle: MaterialStatePropertyAll(
                          TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        await FireDatabase.fireDatabase
                            .updateUser(
                              userModel: UserModel(
                                '0',
                                name.text,
                                email.text,
                                FireDatabase.fireDatabase.currentUser.photoURL,
                                phone.text,
                                'offline',
                              ),
                            )
                            .then(
                              (value) => setState(() {
                                isEdit = false;
                              }),
                            );
                      },
                      child: const Text(
                        'Save',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
