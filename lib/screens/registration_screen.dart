import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/widgets/directionalButtons.dart';
import 'package:flutter/material.dart';
// Toast Package
import 'package:fluttertoast/fluttertoast.dart';
// Firebase Package
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool showLoader = false;
  var email;
  var password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showLoader,
        child: Padding(
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
                  decoration: kTextInputDecoration.copyWith(
                      hintText: 'Enter your email')),
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
                      hintText: "Enter your password")),
              SizedBox(
                height: 24.0,
              ),
              DirectionalButton(
                color: Colors.blueAccent,
                buttonTitle: "Register",
                onPress: () async {
                  // to show the loader
                  setState(() {
                    showLoader = true;
                  });
                  try {
                    UserCredential _user =
                        await _auth.createUserWithEmailAndPassword(
                            email: email, password: password);
                    if (_user != null) {
                      Navigator.pushNamed(context, LoginScreen.id);
                    }
                    // to not show the loader
                    setState(() {
                      showLoader = false;
                    });
                  } on FirebaseAuthException catch (e) {
                    setState(() {
                      showLoader = false;
                    });
                    if (e.code == 'email-already-in-use') {
                      print('The account already exists for that email.');
                      Fluttertoast.showToast(
                        msg: "The account already exists for that email.",
                        gravity: ToastGravity.CENTER,
                        textColor: Colors.white,
                        backgroundColor: Colors.black,
                      );
                    }
                  } catch (e) {
                    setState(() {
                      showLoader = false;
                    });
                    print("Registration Exception $e");
                    Fluttertoast.showToast(
                      msg: "Registration Exception $e",
                      gravity: ToastGravity.CENTER,
                      textColor: Colors.white,
                      backgroundColor: Colors.black,
                    );
                  }
                },
              ),
              // Padding(
              //   padding: EdgeInsets.symmetric(vertical: 16.0),
              //   child: Material(
              //     color: Colors.blueAccent,
              //     borderRadius: BorderRadius.all(Radius.circular(30.0)),
              //     elevation: 5.0,
              //     child: MaterialButton(
              //       onPressed: () {
              //         //Implement registration functionality.
              //       },
              //       minWidth: 200.0,
              //       height: 42.0,
              //       child: Text(
              //         'Register',
              //         style: TextStyle(color: Colors.white),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
