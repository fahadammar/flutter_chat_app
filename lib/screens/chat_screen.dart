import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
// Firebase
import 'package:firebase_auth/firebase_auth.dart';
// Toast Package
import 'package:fluttertoast/fluttertoast.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var logged_in_user;
  @override
  void initState() {
    // TODO: implement initState
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
              onPressed: () {
                //Implement logout functionality
                _auth.signOut();
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
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //Implement send functionality.
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
