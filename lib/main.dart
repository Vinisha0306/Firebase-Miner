import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_miner/page/chatPage.dart';
import 'package:firebase_miner/page/login_page.dart';
import 'package:firebase_miner/page/profilePage.dart';
import 'package:firebase_miner/page/signUpPage.dart';
import 'package:firebase_miner/page/splashScreen.dart';
import 'package:firebase_miner/page/userPage.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/chat': (context) => ChatPage(),
        '/profile': (context) => ProfilePage(),
        '/user': (context) => UserPage(),
      },
    );
  }
}
