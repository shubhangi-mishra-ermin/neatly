import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:meatly/Widget/splashScreen.dart';
import 'package:meatly/screens/cart&checkout/widget/cartitem.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_app_check/firebase_app_check.dart';

SharedPreferences? prefs;
final user = FirebaseAuth.instance.currentUser!;
String currentUserCredential = user.uid;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
    webProvider:
        ReCaptchaV3Provider('6LdLDgcqAAAAAJFvrI0kr62O4916hbnJGPJ91kUF'),
    androidProvider: AndroidProvider.playIntegrity,
    // appleProvider: AppleProvider.appAttest,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: HomeScreen(),
      home: SplashScreen(),
    );
  }
}
