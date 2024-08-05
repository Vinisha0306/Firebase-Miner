import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../global..dart';
import '../helper/database.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    whereToNext();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Welcome to Chat App',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future<void> whereToNext() async {
    var pref = await SharedPreferences.getInstance();
    var isLoggedIn = pref.getBool(Global.isLogin);
    Future.delayed(const Duration(seconds: 3), () {
      if (isLoggedIn != null) {
        (isLoggedIn)
            ? FireDatabase.fireDatabase.getUser().then(
                  (value) => Navigator.pushReplacementNamed(context, '/user'),
                )
            : Navigator.pushReplacementNamed(context, '/login');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }
}
