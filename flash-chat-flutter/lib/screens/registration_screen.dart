import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = '/registerScreen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final emailTextFieldController = TextEditingController();
  final passwordTextFieldController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool shwSpinner = false;
  String userMail;
  String userPassword;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: shwSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0,vertical: 20.0),
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
                    userMail = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    labelText: 'Enter Your Email',
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
                  keyboardType: TextInputType.visiblePassword,
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
                        colour: Colors.blueAccent,
                        onPress: () async {
                          emailTextFieldController.clear();
                          passwordTextFieldController.clear();
                          setState(() {
                            shwSpinner = true;
                          });
                          try{
                            final newUser = await _auth.createUserWithEmailAndPassword(email: userMail, password: userPassword);

                            if(newUser != null){
                              Navigator.pushNamed(context, ChatScreen.id);
                            }
                            setState(() {
                              shwSpinner = false;
                            });
                          }catch(e){
                            print(e);
                          }

                        },
                        buttonName: 'Register'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
