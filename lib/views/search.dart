import 'dart:convert';
import 'dart:io';

import 'package:chat/models/pairid.dart';
import 'package:chat/views/conversation_screen.dart';
import 'package:chat/views/signup.dart';
import 'package:chat/widgets/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../models/usermodel.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchInputController = new TextEditingController();
  DatabaseReference ref = FirebaseDatabase.instance.reference().child("Users");
  List<UserModel> list = [];
  final FirebaseAuth auth = FirebaseAuth.instance;

  void getUserByUsername(String key) {
    ref.onValue.listen((event) {
      for (final child in event.snapshot.children) {
        // Handle the post.
        final json = child.value as Map<dynamic, dynamic>;

        var uid = json['id'];
        var username = json['username'];
        var email = json['email'];
        var password = json['password'];

        if (username == key) {
          UserModel user = new UserModel(username, email, password);
          user.setUserId = uid;
          setState(() {
            list.add(user);
          });
        }
      }
    }, onError: (error) {
      // Error.
    });
  }

  String currentUserId() {
    final User user = auth.currentUser!;
    final String uid = user.uid;
    return uid;
  }

  createChatRoomConversation(
      String senderId, String reciverId, String recieverName) {
    // gui id cua ng gui va ng nhan sang man hinh chat
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConversationScreen(
            senderId: senderId,
            recieverId: reciverId,
            receiverName: recieverName,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60), child: appBarMain(context)),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: searchInputController,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                    decoration: const InputDecoration(
                        hintText: "search user...",
                        hintStyle: const TextStyle(
                          color: Colors.white54,
                        ),
                        border: InputBorder.none),
                  )),
                  GestureDetector(
                    onTap: () {
                      var key = searchInputController.text;
                      setState(() {
                        list.clear();
                      });
                      getUserByUsername(
                          key); // lay danh sach user co ten nhap vao
                      //searchList();
                    },
                    child: Container(
                      child: Image.asset('assets/images/search.png',
                          height: 25, width: 25),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: _itemRow(list[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemRow(UserModel user) {
    return ListTile(
        title: Container(
            child: Row(
      children: [
        Column(
          children: [
            Text(user.getUsername,
                style: TextStyle(fontSize: 16, color: Colors.white)),
            Text(user.getEmail,
                style: TextStyle(fontSize: 12, color: Colors.white)),
          ],
        ),
        Spacer(),
        GestureDetector(
          onTap: () {
            createChatRoomConversation(
                currentUserId(), user.getUserId, user.getUsername);
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(20)),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Text("Messages",
                style: TextStyle(fontSize: 12, color: Colors.white)),
          ),
        )
      ],
    )));
  }
}
