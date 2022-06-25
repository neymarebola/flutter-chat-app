import 'package:chat/views/chatroomscreen.dart';
import 'package:chat/views/signin.dart';
import 'package:chat/views/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: Color(0xff1f1f1f),
          primaryColor: Color(0xff1f1f1f),
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home: auth.currentUser == null ? SignIn() : ChatRoom(),
    );
  }
}
