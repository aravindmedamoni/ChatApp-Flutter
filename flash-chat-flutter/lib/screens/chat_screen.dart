import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = Firestore.instance;
String currentUserUid; // for getting current user Id
FirebaseUser currentUser; // for getting current user

class ChatScreen extends StatefulWidget {
  static const String id = '/chatScreen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();

      if (user != null) {
        currentUser = user;
        setState(() {
          currentUserUid = user.uid;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void getUserData() async {
//    final messages = await _firestore.collection('message').document(currentUser.uid).collection('SentMessages').getDocuments();
//    for(var message in messages.documents){
//      print(message.data);
//    }
    await for (var snopshot in _firestore
        .collection('message')
        .document(currentUserUid)
        .collection('SentMessages')
        .snapshots())
      for (var message in snopshot.documents) {
        print(message.data);
      }
  }

  @override
  Widget build(BuildContext context) {
    getCurrentUser();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);
                // getUserData();
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
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //Implement send functionality.
                      messageTextController.clear();
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': currentUser.email,
                      });
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
}

// It is for getting the message (up to date loading
// each and every time when message is sent or receive)
class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, snopshot) {
        if (!snopshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blueGrey,
            ),
          );
        }
        final messages = snopshot.data.documents.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data['text'];
          final messageSender = message.data['sender'];

          final loggedInUser = currentUser.email;

          if (loggedInUser == messageSender) {
            // something do
          }

          final messageBubble = new MessageBubble(
            text: messageText,
            sender: messageSender,
            isMe: loggedInUser == messageSender,
          );
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

// it is for the message Text
class MessageBubble extends StatelessWidget {
  final String text;
  final String sender;
  final bool isMe;

  MessageBubble({this.text, this.sender, this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        crossAxisAlignment:isMe ? CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(
              color: Colors.black38,
              fontSize: 12.0,
            ),
          ),
          Material(
            color: isMe ? Colors.lightBlue[300]:Colors.white,
            elevation: 5.0,
            borderRadius:isMe ? BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0)):BorderRadius.only(
              bottomLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0)
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16.0,
                  color:isMe ? Colors.white:Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
