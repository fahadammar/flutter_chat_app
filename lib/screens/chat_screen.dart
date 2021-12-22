import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
// Firebase
import 'package:firebase_auth/firebase_auth.dart';
// Toast Package
import 'package:fluttertoast/fluttertoast.dart';

final FirebaseFirestore _firestore =
    FirebaseFirestore.instance; // Firebase Cloud Fire Store
var messageCollection = _firestore.collection("messages");
// Text Editing Controller
late TextEditingController textController = TextEditingController();
// Current user Stuff
final _auth = FirebaseAuth.instance; // Firebase Auth

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String userMsg;
  var logged_in_user;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () async {
                //Implement logout functionality
                //await _auth.signOut();
                // ignore: await_only_futures
                // if (await _auth.currentUser == null) {
                //   // pops the user to previous screen
                //   Navigator.pushNamedAndRemoveUntil(
                //     context,
                //     LoginScreen.id,
                //     ModalRoute.withName(ChatScreen.id),
                //   );
                // }
                logout();
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textController,
                      onChanged: (value) {
                        //Do something with the user input.
                        userMsg = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //Implement send functionality.
                      // when the send will be tapped the  written text message will be clared
                      textController.clear();
                      messageCollection
                          .add({
                            "sender": logged_in_user,
                            "text": userMsg,
                            "messageTime": DateTime.now(),
                          })
                          .then((value) => null)
                          .catchError((error) =>
                              print("Exception Firebase FireStore: $error"));
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // This gets the current user and prints it
  void getCurrentUser() async {
    try {
      if (_auth.currentUser == null) {
        print("The user is not logged in");
        print("Current user is null");
        Fluttertoast.showToast(
          msg: "The current user is null or logged out",
          gravity: ToastGravity.CENTER,
          textColor: Colors.white,
          backgroundColor: Colors.black,
        );
      } else if (_auth.currentUser != null) {
        // ignore: await_only_futures
        logged_in_user = await _auth.currentUser!.email;
        print("The current logged In user Email: $logged_in_user");
      }
    } catch (e) {
      print("currentUser Exception: $e");
    }
  }

  // LogOut Function
  Future logout() async {
    await _auth.signOut().then((value) => Navigator.pushNamedAndRemoveUntil(
          context,
          LoginScreen.id,
          ModalRoute.withName(ChatScreen.id),
        ));
  }
}

// Message Stream Widget
class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection("messages")
          .orderBy(
            'messageTime',
            descending: true, //setTrue
          )
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return Container();
        final messages = snapshot.data!.docs;

        List<MessageBubble> messageWidgets = [];
        for (var message in messages) {
          final userMessage = message.get("text");
          final senderMail = message.get("sender");

          final currentUserMail = _auth.currentUser!.email;
          print("CurrentUser Mail: $currentUserMail");
          messageWidgets.add(
            MessageBubble(
              userMessage: userMessage,
              senderMail: senderMail,
              isMe: currentUserMail == senderMail,
            ),
          );
        }

        return Expanded(
          child: ListView(
            reverse: true,
            children: messageWidgets,
          ),
        );
      },
    );
  }
}

// Message bubble widget
class MessageBubble extends StatelessWidget {
  final String userMessage;
  final String senderMail;
  final bool isMe;
  const MessageBubble({
    required this.userMessage,
    required this.senderMail,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        // we want to align msg text & box, to left so 👇
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Text(
            senderMail,
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            color: isMe ? Colors.white : Colors.lightBlueAccent,
            elevation: 5.0,
            borderRadius: isMe
                ? const BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                  ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                userMessage,
                style: TextStyle(
                  color: isMe ? Colors.black : Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
