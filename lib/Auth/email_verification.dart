import 'package:flutter/material.dart';
import 'package:meatly/Auth/api/auth_api.dart';
import 'package:meatly/Auth/password_login.dart';
import 'package:meatly/Widget/custombutton.dart';
import 'package:meatly/Widget/customtextbutton.dart';
import 'package:meatly/globalvariables.dart';
import 'package:meatly/navigationscreen.dart';
import 'package:meatly/utilities/colors.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class EmailVerification extends StatefulWidget {
  final String email;

  const EmailVerification({Key? key, required this.email}) : super(key: key);

  @override
  _EmailVerificationState createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  TextEditingController _otpController = TextEditingController();
  final AuthService _authService = AuthService();
  final EmailVerificationController _controller =
      Get.put(EmailVerificationController());

  @override
  void initState() {
    super.initState();
  }

  void _verifyEmail() async {
    _controller.setLoading(true);
    try {
      User? user = FirebaseAuth.instance.currentUser;
      await user!.reload();
      if (user.emailVerified) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      } else {
        showErrorMessage(
            context, 'Email is not verified yet. Please check your email.');
      }
    } catch (e) {
      showErrorMessage(context, 'Failed to verify email: $e');
    }
    _controller.setLoading(false);
  }

  void _resendCode() {
    _authService.sendEmailVerification(widget.email);
    showErrorMessage(context, 'Verification code resent to ${widget.email}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
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
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 25,
                  ),
                  Text(
                    "One time code verification",
                    style: TextStyle(
                      fontSize: 27,
                      color: Colors.black,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                    child: Text(
                      "We have sent a one-time code to the email ending with ***${widget.email.substring(widget.email.length - 12)}. Enter the code below to continue.",
                      style: TextStyle(
                        fontSize: 15,
                        color: greyColor,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  OTPTextField(
                    length: 6,
                    width: MediaQuery.of(context).size.width,
                    fieldWidth: MediaQuery.of(context).size.width / 8,
                    style: TextStyle(fontSize: 17),
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldStyle: FieldStyle.underline,
                    onCompleted: (pin) {
                      _otpController.text = pin;
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 38,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 8, 15, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Didn't receive the code yet?",
                          style: TextStyle(
                            fontSize: 16,
                            color: greyColor,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        GestureDetector(
                          onTap: _resendCode,
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
                                    email: widget.email,
                                  )),
                        );
                      },
                    ),
                    CustomButton(
                      text: "Login",
                      onPressed: _verifyEmail,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmailVerificationController extends GetxController {
  var isLoading = false.obs;

  void setLoading(bool value) {
    isLoading.value = value;
  }
}
