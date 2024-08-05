import 'package:flutter/material.dart';

import '../helper/database.dart';
import '../model/userModel.dart';

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
