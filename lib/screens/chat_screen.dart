import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:bubble/bubble.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String messageText;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  //
  // void getMessage() async{
  //   final messages = await _firestore.collection('messages').get();
  //   for (var message in messages.docs){
  //     print(message.data());
  //   }
  // }

  // void messagesStream() async {
  //   await for (var snapshot in _firestore.collection('messages').snapshots()) {
  //     for (var message in snapshot.docs) {
  //       print(message.data());
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Color(0xFF17202c),
        appBar: AppBar(
          elevation: 0,
          leading: null,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  // messagesStream();

                  _auth.signOut();
                  Navigator.popAndPushNamed(context, WelcomeScreen.id);
                }),
          ],
          title: Text('⚡️Chat'),
          backgroundColor: Color(0xFF17202c),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MessageStream(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border(
                        top: BorderSide(
                            color: Colors.white.withOpacity(0.2), width: 1.0),
                        right: BorderSide(
                            color: Colors.white.withOpacity(0.2), width: 1.0),
                        bottom: BorderSide(
                          color: Colors.white.withOpacity(0.2),
                          width: 1.0,
                        ),
                        left: BorderSide(
                            color: Colors.white.withOpacity(0.2), width: 1.0)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please';
                            }
                            return null;
                          },

                          controller: messageTextController,
                          onChanged: (value) {
                            messageText = value;
                          },
                          decoration: kMessageTextFieldDecoration,
                          onFieldSubmitted: (value){
                            if (_formKey.currentState.validate()) {
                              messageTextController.clear();
                              _firestore.collection('messages').add(
                                {
                                  'text': messageText,
                                  'sender': loggedInUser.email,
                                  'date and time': DateTime.now().toString(),
                                },
                              );
                            }
                          },
                        ),
                      ),
                      TextButton.icon(
                        label: Text(''),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            messageTextController.clear();
                            _firestore.collection('messages').add(
                              {
                                'text': messageText,
                                'sender': loggedInUser.email,
                                'date and time': DateTime.now().toString(),
                              },
                            );
                          }
                          // print(DateTime.now().toString());
                        },
                        style: ButtonStyle(
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                        ),
                        icon: Icon(
                          Icons.send,
                          size: 18,
                          color: Colors.white,
                        ),
                        // child: Text(
                        //   'Send',
                        //   style: kSendButtonTextStyle,
                        // ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      // ignore: missing_return
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message['text'];
          final messageSender = message['sender'];
          final currentUser = loggedInUser.email;
          final messageDateTime = message['date and time'];
          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: currentUser == messageSender,
            dateTime: messageDateTime,
            currentTime: messageDateTime.toString().substring(11, 16),
          );
          messageBubbles.add(messageBubble);
          messageBubbles.sort((a, b) =>
              DateTime.parse(b.dateTime).compareTo(DateTime.parse(a.dateTime)));
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {this.sender, this.text, this.isMe, this.dateTime, this.currentTime});

  final String sender;
  final String text;
  final bool isMe;
  final String dateTime;
  final String currentTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(1.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              // children: [
              //   Text(
              //     '$sender',
              //     style: TextStyle(
              //       color: Colors.white,
              //       fontSize: 12,
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),
              //   Padding(
              //     padding: EdgeInsets.fromLTRB(18, 6, 2, 2),
              //     child: Text(
              //       '$currentTime',
              //       textAlign: TextAlign.right,
              //       style: TextStyle(
              //           fontSize: 10,
              //           color: Colors.white.withOpacity(0.8),
              //           fontStyle: FontStyle.italic),
              //     ),
              //   ),
              // ],
            ),
          ),
          Bubble(
            margin: isMe ? BubbleEdges.fromLTRB(80, 1, 0, 1) : BubbleEdges.fromLTRB(0, 1, 80, 1),
            color: isMe ? Color(0xFF348065) : Color(0xFF585f67),
            child: Padding(
              padding: const EdgeInsets.all(3.0),

              child: Column(
                crossAxisAlignment: isMe? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    '$sender',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6,bottom: 6),
                    child: Text(
                      '$text',
                      textAlign: isMe ? TextAlign.right : TextAlign.left,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    '$currentTime',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9
                    ),
                  ),
                ],
              ),
            ),
            nip: isMe ? BubbleNip.rightTop : BubbleNip.leftTop,
          ),
        ],
      ),
    );
  }
}
