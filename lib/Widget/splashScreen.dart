import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meatly/Auth/login_signup.dart';
import 'package:meatly/navigationscreen.dart';
import 'package:meatly/utilities/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = FirebaseAuth.instance.currentUser;

    Timer(
        Duration(seconds: 2),
        () => Navigator.pushReplacement(
            context,
            // MaterialPageRoute(builder:
            //     (context) => HomeScreen()
            // )
            MaterialPageRoute(
                builder: (context) =>
                    user != null ? HomeScreen() : LoginSignup())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4.5,
              child: Image(
                fit: BoxFit.fitWidth,
                image: AssetImage("lib/assets/images/splashvc.png"),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.8,
              height: MediaQuery.of(context).size.height / 4.5,
              child: Image(
                fit: BoxFit.fitWidth,
                image: AssetImage("lib/assets/images/logo.png"),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 5.5,
            ),
          ],
        ),
      ),
    );
  }
}
