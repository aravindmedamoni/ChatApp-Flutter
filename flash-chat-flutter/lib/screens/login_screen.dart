import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String id = '/loginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailTextFieldController = TextEditingController();
  final passwordTextFieldController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String userEmail;
  String userPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Container(
                      height: 200.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                  SizedBox(
                    height: 48.0,
                  ),
                  TextField(
                    controller: emailTextFieldController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      color: Colors.black87,
                    ),
                    onChanged: (value) {
                      //Do something with the user input.
                      userEmail = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                      labelText: 'Enter your Email',
                      prefixIcon: Icon(
                        Icons.mail,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    controller: passwordTextFieldController,
                    obscureText: true,
                    style: TextStyle(
                      color: Colors.black87,
                    ),
                    onChanged: (value) {
                      //Do something with the user input.
                      userPassword = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                      labelText: 'Enter your password',
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 30.0),
                      child: RoundedButton(
                          colour: Colors.lightBlueAccent,
                          onPress: () async {
                            emailTextFieldController.clear();
                            passwordTextFieldController.clear();
                            setState(() {
                              showSpinner = true;
                            });
                            try{
                              final user = await _auth.signInWithEmailAndPassword(email: userEmail, password: userPassword);

                              if(user != null){
                                Navigator.pushNamed(context, ChatScreen.id);
                              }
                              showSpinner = false;
                            }catch(e){
                              print(e);
                            }
                          },
                          buttonName: 'Log In')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
