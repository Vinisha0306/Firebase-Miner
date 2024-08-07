import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_miner/page/chatPage.dart';
import 'package:firebase_miner/page/userPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../global..dart';
import '../helper/auth_model.dart';
import '../helper/database.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () async {
              User? user = await AuthHelper.authHelper.anonymousLoginIn();
              if (user != null) {
                var pref = await SharedPreferences.getInstance();
                // await FireDatabase.fireDatabase.getUser();

                pref.setBool(Global.isLogin, true);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => UserPage(),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Enter Valid UserName Or Password',
                    ),
                    backgroundColor: Colors.red.withOpacity(0.6),
                  ),
                );
              }
            },
            child: const Text('Guest Login'),
          ),
        ],
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: email,
                decoration: InputDecoration(
                  hintText: 'Enter Yor Email',
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter Yor Password',
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  User? user = await AuthHelper.authHelper.login(
                    email: email.text,
                    password: password.text,
                  );
                  if (user != null) {
                    var pref = await SharedPreferences.getInstance();
                    await FireDatabase.fireDatabase.getUser();

                    pref.setBool(Global.isLogin, true);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => UserPage(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Enter Valid UserName Or Password',
                        ),
                        backgroundColor: Colors.red.withOpacity(0.6),
                      ),
                    );
                  }
                },
                child: const Text('Login'),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  UserCredential credential =
                      await AuthHelper.authHelper.signInWithGoogle();
                  User? user = credential.user;

                  if (user != null) {
                    await FireDatabase.fireDatabase.addUser(user: user);
                    await FireDatabase.fireDatabase.getUser();
                    var pref = await SharedPreferences.getInstance();
                    pref.setBool(Global.isLogin, true);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserPage(),
                      ),
                    );
                  }
                },
                child: const Image(
                  image: AssetImage('lib/assests/google.png'),
                  width: 30,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Text('Don\'t have an account? Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
