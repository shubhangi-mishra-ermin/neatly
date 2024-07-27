import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meatly/Auth/createaccount.dart';
import 'package:meatly/api/localstorage.dart';
import 'package:meatly/main.dart';
import 'package:meatly/screens/Home/homepage.dart';
import 'package:meatly/navigationscreen.dart';
import 'package:meatly/Widget/custombutton.dart';
import 'package:meatly/Widget/customtextbutton.dart';
import 'package:meatly/globalvariables.dart';
import 'package:meatly/utilities/colors.dart';
import 'package:meatly/utilities/textstyles.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:meatly/Auth/password_login.dart';
import 'package:get/get.dart';

class PhoneVerification extends StatefulWidget {
  final String phoneNum;
  final String verificationId;

  const PhoneVerification({
    Key? key,
    required this.phoneNum,
    required this.verificationId,
  }) : super(key: key);

  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  late String _smsCode;
  final PhoneVerificationController _controller =
      Get.put(PhoneVerificationController());

  void _verifyOTP() async {
    try {
      _controller.setLoading(true);
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: _smsCode,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      _handleSignInResult(context, userCredential.user);
    } catch (e) {
      _controller.setLoading(false);
      showErrorMessage(context, 'Invalid OTP');
    }
  }

  void _handleSignInResult(BuildContext context, User? user) {
    _controller.setLoading(false);
    if (user != null) {
      if (user.metadata != null &&
          user.metadata.creationTime != null &&
          user.metadata.lastSignInTime != null) {
        print("user.metadata.creationTime :: ${user.metadata.creationTime}");
        print(
            "user.metadata.lastSignInTime :: ${user.metadata.lastSignInTime}");
        if (user.metadata.creationTime == user.metadata.lastSignInTime) {
          nextPage(
              context,
              CreateAccount(
                phonenumber: widget.phoneNum,
              ));
        } else {
          nextPage(context, HomeScreen());
        }
      } else {
        showErrorMessage(context, 'User metadata is null or incomplete');
      }
    } else {
      showErrorMessage(context, 'User is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: _controller.isLoading.value
              ? Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 36,
                              width: 36,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 4.0,
                                        offset: Offset(0.0, 2.0))
                                  ]),
                              child: Icon(
                                Icons.arrow_back_ios_rounded,
                                size: 20,
                              ),
                            ),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height / 25),
                          Text(
                            "One time code verification",
                            style: AppTextStyle.pageHeadingSemiBold,
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                            child: Text(
                              "We have sent an one time code to phone number ending with ***${widget.phoneNum.substring(widget.phoneNum.length - 3)}. Enter the code below to continue.",
                              style: TextStyle(
                                fontSize: 15,
                                color: greyColor,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          OTPTextField(
                            length: 6,
                            width: MediaQuery.of(context).size.width,
                            fieldWidth: MediaQuery.of(context).size.width / 8,
                            style: TextStyle(fontSize: 17),
                            textFieldAlignment: MainAxisAlignment.spaceAround,
                            fieldStyle: FieldStyle.underline,
                            onCompleted: (pin) {
                              setState(() {
                                _smsCode = pin;
                              });
                            },
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height / 38),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 8, 15, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Didn't you get the code yet?",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: greyColor,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    // final user =
                                    //     FirebaseAuth.instance.currentUser!;
                                    // String currentUserCredential = user.uid;
                                    print("resend button");
                                    // print(
                                    //     "currentUserCredential verification screen:: ${currentUserCredential ?? ""}");

                                    // print(
                                    //     "currentUserCredential verification screen:: ${currentUserCredential ?? ""}");
                                  },
                                  child: Text(
                                    "Resend",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: primaryColor,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            CustomTextButton(
                              text: 'Use password',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PhonePassword(
                                          email: widget.phoneNum)),
                                );
                              },
                            ),
                            CustomButton(
                              text: 'Login',
                              onPressed: _verifyOTP,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class PhoneVerificationController extends GetxController {
  var isLoading = false.obs;

  void setLoading(bool value) {
    isLoading.value = value;
  }
}
