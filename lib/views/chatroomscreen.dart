import 'package:chat/models/message.dart';
import 'package:chat/models/usermodel.dart';
import 'package:chat/services/auth.dart';
import 'package:chat/views/conversation_screen.dart';
import 'package:chat/views/search.dart';
import 'package:chat/views/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../models/pair.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseDatabase db = FirebaseDatabase.instance;
  List<Pair> listContact = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListContactedUser();
  }

  void getListContactedUser() {
    final User user = auth.currentUser!;
    final String uid = user.uid;

    db.reference().child("Messages").onValue.listen((event) async {
      for (final child in event.snapshot.children) {
        // Handle the post.
        final json = child.value as Map<dynamic, dynamic>;

        var senderId = json['senderId'];
        var receiverId = json['receiverId'];
        var mId = json['mId'];
        var text = json['text'];
        var time = json['time'];

        // neu nhu id cua ng gui hoac ng nhan = id cua mk thi them username cua id do vao list.
        if (senderId == auth.currentUser?.uid) {
          if (checkIfExisted(receiverId)) {
            var dbRef = db
                .reference()
                .child("Users")
                .child(receiverId)
                .child("username");
            var snapshot = await dbRef.get(); // 👈 Use await here 🧐
            var username = snapshot.value;
            Pair pair = new Pair(receiverId, username.toString());
            setState(() {
              listContact.add(pair);
            });
          }
        } else if (receiverId == auth.currentUser?.uid) {
          if (checkIfExisted(senderId)) {
            var dbRef =
                db.reference().child("Users").child(senderId).child("username");
            var snapshot = await dbRef.get(); // 👈 Use await here 🧐
            var username = snapshot.value;
            Pair pair = new Pair(receiverId, username.toString());
            setState(() {
              listContact.add(pair);
            });
          }
        }
      }
      for (int i = 0; i < listContact.length; i++) {
        print(listContact[i]);
      }
    }, onError: (error) {
      // Error.
    });
  }

  bool checkIfExisted(String s) {
    if (listContact.length > 0) {
      for (int i = 0; i < listContact.length; i++) {
        if (listContact[i].getUid == s) {
          return false;
        }
      }
    }

    return true;
  }

  Widget chatRoomList() {
    return (ListView.builder(
        itemCount: listContact.length,
        itemBuilder: ((context, index) {
          return ChatRoomtile(
              username: listContact[index].getUsername,
              contactId: listContact[index].getUid);
        })));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/logo2.png',
          height: 50,
          width: 50,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              authMethods.signOut().then((value) {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => SignIn()));
              });
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          ),
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
    );
  }
}

FirebaseAuth auth = FirebaseAuth.instance;

class ChatRoomtile extends StatelessWidget {
  const ChatRoomtile(
      {Key? key, required this.username, required this.contactId})
      : super(key: key);

  final String username, contactId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConversationScreen(
                    senderId: auth.currentUser!.uid,
                    recieverId: contactId,
                    receiverName: username)));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(40)),
              child: Text("${username.substring(0, 1).toUpperCase()}",
                  style: TextStyle(color: Colors.white)),
            ),
            SizedBox(
              width: 8,
            ),
            Text(username, style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
