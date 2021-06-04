import 'package:flutter/material.dart';

const kSendButtonTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
  errorStyle: TextStyle(
    fontSize: 0,
  ),
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.white, width: 1.0),
    right: BorderSide(color: Colors.white, width: 1.0),
    bottom: BorderSide(color: Colors.white, width: 1.0,),
    left: BorderSide(color: Colors.white, width: 1.0)
  ),

);
