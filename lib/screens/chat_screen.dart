import 'package:cloud_firestore/cloud_firestore.dart';
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

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth
  var logged_in_user;
  late String userMsg;

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
                await _auth.signOut();
                Navigator.pop(context); // pops the user to previous screen
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
                          .add({"sender": logged_in_user, "text": userMsg})
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
  void getCurrentUser() {
    final currentUser = _auth.currentUser!;
    try {
      if (currentUser == null) {
        print("The user is not logged in");
        print("Current user is null");
        Fluttertoast.showToast(
          msg: "The current user is null or logged out",
          gravity: ToastGravity.CENTER,
          textColor: Colors.white,
          backgroundColor: Colors.black,
        );
      } else if (currentUser != null) {
        logged_in_user = currentUser.email;
        print("The current logged In user Email: $logged_in_user");
      }
    } catch (e) {
      print("currentUser Exception: $e");
    }
  }
}

// Message Stream Widget
class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection("messages").snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return Container();
        final messages = snapshot.data!.docs;

        List<MessageBubble> messageWidgets = [];
        for (var message in messages) {
          final userMessage = message.get("text");
          final senderMail = message.get("sender");

          messageWidgets.add(
            MessageBubble(
              userMessage: userMessage,
              senderMail: senderMail,
            ),
          );
        }

        return Expanded(
          child: ListView(
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
  const MessageBubble({required this.userMessage, required this.senderMail});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        // we want to align them to left so 👇
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            senderMail,
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            color: Colors.lightBlueAccent,
            elevation: 5.0,
            borderRadius: BorderRadius.circular(30.0),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                userMessage,
                style: const TextStyle(
                  color: Colors.white,
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
