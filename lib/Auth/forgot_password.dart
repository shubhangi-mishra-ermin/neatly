import 'package:flutter/material.dart';
import 'package:meatly/Auth/reset_password.dart';
import 'package:meatly/utilities/colors.dart';
import 'package:meatly/utilities/textstyles.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
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
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                            topLeft: Radius.circular(30),
                          ),
                          // gradient: LinearGradient(
                          //   colors: [Colors.indigo, Colors.blueAccent]),
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
                    height: MediaQuery.of(context).size.height / 25,
                  ),
                  Text("Email verification",
                      style: AppTextStyle.pageHeadingSemiBold),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                    child: Text(
                      "We have sent an one time code to email ending with ***bis23@gmail.com. Enter the code below to continue.",
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
                    length: 5,
                    width: MediaQuery.of(context).size.width,
                    fieldWidth: MediaQuery.of(context).size.width / 6.5,
                    style: TextStyle(fontSize: 17),
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldStyle: FieldStyle.underline,
                    onCompleted: (pin) {
                      print("Completed: " + pin);
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
                          "Didn't you get the code yet?",
                          style: TextStyle(
                            fontSize: 16,
                            color: greyColor,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          "Resend",
                          style: TextStyle(
                            fontSize: 16,
                            color: primaryColor,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ResetPassword()),
                    );
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height / 16,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: primaryColor,
                        border: Border.all(
                          color: primaryColor,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30),
                        ),
                        // gradient: LinearGradient(
                        //   colors: [Colors.indigo, Colors.blueAccent]),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 0.0,
                              offset: Offset(0.0, 0.0))
                        ]),
                    child: Center(
                      child: Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
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
