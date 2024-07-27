import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meatly/api/localstorage.dart';

import 'package:meatly/globalvariables.dart';
import 'package:meatly/main.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return null;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    return userCredential.user;
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      print('User signed in with Google: ${_auth.currentUser!.displayName}');
    } catch (e) {
      print('Error signing in with Google: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in with Google: $e')),
      );
    }
  }

  UserCredential? userCredential;
  Future<void> signInWithPhone(String phoneNumber, BuildContext context,
      {required Function(String) onCodeSent}) async {
    String formattedPhoneNumber =
        phoneNumber.startsWith('+') ? phoneNumber : '+$phoneNumber';

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: formattedPhoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            userCredential =
                await FirebaseAuth.instance.signInWithCredential(credential);
            print("User successfully signed in: ${userCredential?.user?.uid}");

            prefs?.setString(
                LocalStorage.userId, userCredential?.user?.uid ?? "");
            print(
                "LocalStorage.userID :: ${prefs?.getString(LocalStorage.userId)}");

            onCodeSent("");
          } catch (e) {
            print('Error signing in after verification: $e');
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          showErrorMessage(context, "${e.message}");
          print('Verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('Auto retrieval timeout');
        },
      );
    } catch (e) {
      print('Failed to verify phone number: $e');
    }
  }

  // void _handleSignInResult(User? user, BuildContext context) {
  //   if (user != null) {
  //     if (user.metadata.creationTime == user.metadata.lastSignInTime) {
  //       nextPage(context, CreateAccount());
  //     } else {
  //       nextPage(context, HomeScreen());
  //     }
  //   }
  // }
  Future<void> sendEmailVerification(String email) async {
    User? user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> registerWithEmail(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<bool> checkIfUserExists(String uid) async {
    var userSnapshot =
        await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    return userSnapshot.exists;
  }
}
