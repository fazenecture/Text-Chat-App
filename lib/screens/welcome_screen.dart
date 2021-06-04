import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1, milliseconds: 5),
      vsync: this,
      // upperBound: 60.0,
    );
    animation = ColorTween(begin: Colors.lightBlueAccent, end: Colors.white)
        .animate(controller);
    // animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF17202c),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText('Flash Chat',
                        textStyle: TextStyle(
                          fontSize: 45.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.white
                        ),
                        speed: const Duration(milliseconds: 100)),
                  ],
                  isRepeatingAnimation: false,
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            // RoundedButton(
            //   title: 'Log In',
            //   color: Color(0xFF17202c),
            //   onPressed: () {
            //     Navigator.pushNamed(context, LoginScreen.id);
            //   },
            // ),
            MaterialButton(
              height: 48,
              elevation: 0,
              color: Color(0xFF17202c),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.white.withOpacity(0.7))
              ),
              child: Text(
                'Log In',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15
                ),
              ),

              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            SizedBox(
              height: 30,
            ),
            MaterialButton(
              height: 48,
              elevation: 0,
              color: Color(0xFF17202c),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.white.withOpacity(0.7))
              ),
              child: Text(
                'Register',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15
                ),
              ),

              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
