import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/widgets/directionalButtons.dart';
import 'package:flutter/material.dart';
// Toast Package
import 'package:fluttertoast/fluttertoast.dart';
// Firebase Package
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var email;
  var password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: SizedBox(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              onChanged: (value) {
                //Do something with the user input.
                email = value;
                print("Email $email");
              },
              decoration:
                  kTextInputDecoration.copyWith(hintText: "Enter your email"),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              obscureText: true,
              onChanged: (value) {
                //Do something with the user input.
                password = value;
                print("Password: $password");
              },
              decoration: kTextInputDecoration.copyWith(
                  hintText: "Enter your password"),
            ),
            SizedBox(
              height: 24.0,
            ),
            DirectionalButton(
                color: Colors.lightBlueAccent,
                buttonTitle: "Log In",
                onPress: () async {
                  // Need to insert the user Login Firebase Code Here
                  try {
                    UserCredential _user =
                        await _auth.signInWithEmailAndPassword(
                            email: email, password: password);
                    if (_user != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                      Fluttertoast.showToast(
                        msg: "logged In",
                        gravity: ToastGravity.CENTER,
                        textColor: Colors.white,
                        backgroundColor: Colors.black,
                      );
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      print('No user found for that email.');
                      Fluttertoast.showToast(
                        msg: "No user found for that email",
                        gravity: ToastGravity.CENTER,
                        textColor: Colors.white,
                        backgroundColor: Colors.black,
                      );
                    }
                  } catch (e) {
                    print("Login Exception: $e");
                    Fluttertoast.showToast(
                      msg: "Login Exception: $e",
                      gravity: ToastGravity.CENTER,
                      textColor: Colors.white,
                      backgroundColor: Colors.black,
                    );
                  }
                }),
            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: 16.0),
            //   child: Material(
            //     color: Colors.lightBlueAccent,
            //     borderRadius: BorderRadius.all(Radius.circular(30.0)),
            //     elevation: 5.0,
            //     child: MaterialButton(
            //       onPressed: () {
            //         //Implement login functionality.
            //       },
            //       minWidth: 200.0,
            //       height: 42.0,
            //       child: Text(
            //         'Log In',
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
