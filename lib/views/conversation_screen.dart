import 'package:chat/models/Message.dart';
import 'package:chat/models/pairId.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ConversationScreen extends StatefulWidget {
  final String senderId, recieverId, receiverName;

  const ConversationScreen(
      {Key? key,
      required this.senderId,
      required this.recieverId,
      required this.receiverName})
      : super(key: key);

  @override
  State<ConversationScreen> createState() => _ConversationScreenState(
      this.senderId, this.recieverId, this.receiverName);
}

bool myMsg = true;

class MessageTile extends StatelessWidget {
  const MessageTile({Key? key, required this.message}) : super(key: key);
  final Message message;

  @override
  Widget build(BuildContext context) {
    myMsg = message.getIsMy;
    return Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        width: MediaQuery.of(context).size.width,
        alignment: myMsg ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: myMsg
                      ? [const Color(0xff007e74), const Color(0xff2a75bc)]
                      : [const Color(0x1affffff), const Color(0x1affffff)]),
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Text(
            message.getText,
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
        ));
  }
}

class _ConversationScreenState extends State<ConversationScreen> {
  final String senderId, recieverId, recieverName;
  _ConversationScreenState(this.senderId, this.recieverId, this.recieverName);

  TextEditingController sendMsgController = new TextEditingController();
  late FirebaseDatabase database = FirebaseDatabase.instance;
  late DatabaseReference ref = database.reference().child("Messages");
  late Stream chatMessageStream;
  late List<Message> listm = [];

  @override
  void initState() {
    super.initState();
    showMessage();
  }

  Widget ChatMessageList() {
    return ListView.builder(
        itemCount: listm.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: MessageTile(message: listm[index]),
          );
        });
  }

  // hien thi tin nhan cua mk
  showMessage() {
    Query query = ref.orderByChild("time");
    query.onValue.listen((event) {
      setState(() {
        listm.clear();
      });
      for (final child in event.snapshot.children) {
        // Handle the post.for (final child in event.snapshot.children) {
        // Handle the post.
        final json = child.value as Map<dynamic, dynamic>;

        String senderId = json['senderId'];
        String reciverId = json['receiverId'];
        String mId = json['mId'];
        String text = json['text'];
        int time = json['time'];

        if (senderId == this.recieverId && reciverId == this.senderId) {
          setState(() {
            Message m =
                new Message(mId, senderId, reciverId, text, time, false);
            listm.add(m);
          });
        }
        if (senderId == this.senderId && reciverId == this.recieverId) {
          setState(() {
            Message m = new Message(mId, senderId, reciverId, text, time, true);
            listm.add(m);
          });
        }
      }
    }, onError: (error) {
      // Error.
      print(error.message);
    });
  }

  void saveMessageToDb(Message m) {
    var msgInfo = {
      "mId": m.getMId,
      "senderId": m.getSenderId,
      "receiverId": m.getRecieverId,
      "text": m.getText,
      "time": m.getTime
    };
    var mId = m.getSenderId + m.getRecieverId + m.getTime.toString();
    database.reference().child("Messages").push().set(msgInfo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(this.recieverName),
        ),
        body: Container(
          child: Stack(children: [
            ChatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                  color: Color(0x54ffffff),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                        controller: sendMsgController,
                        style: TextStyle(color: Colors.white54, fontSize: 14),
                        decoration: InputDecoration(
                            hintText: "Write something...",
                            hintStyle: TextStyle(color: Colors.white54),
                            border: InputBorder.none),
                      )),
                      GestureDetector(
                        // click để gửi tin nhắn lên server
                        onTap: () {
                          String mId = this.senderId + this.recieverId;
                          int time = DateTime.now().microsecondsSinceEpoch;
                          String text = sendMsgController.text;
                          if (text != "") {
                            Message m = new Message(mId, this.senderId,
                                this.recieverId, text, time, true);
                            saveMessageToDb(m);
                            sendMsgController.text = "";
                          }
                          //sendMsgController.text = "";
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: myMsg
                                      ? [
                                          const Color(0x36ffffff),
                                          const Color(0x0ffffff)
                                        ]
                                      : [
                                          const Color(0x1affffff),
                                          const Color(0x1affffff)
                                        ]),
                              borderRadius: BorderRadius.circular(40)),
                          padding: EdgeInsets.all(12),
                          child: Image.asset('assets/images/send.png'),
                        ),
                      )
                    ],
                  )),
            )
          ]),
        ));
  }
}
