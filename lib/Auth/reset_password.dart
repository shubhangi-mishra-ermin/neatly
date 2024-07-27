import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meatly/Auth/login_signup.dart';
import 'package:meatly/Widget/custombutton.dart';
import 'package:meatly/Widget/customtextfield.dart';
import 'package:meatly/Widget/textfield.dart';
import 'package:meatly/utilities/colors.dart';
import 'package:meatly/utilities/textstyles.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool setobscureText = true;
  bool setobscureText2 = true;
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  double _height = 110;
  double _width = double.infinity;
  bool _state = true;

  bool get isPasswordLengthValid => _passwordController.text.length >= 6;
  bool get doPasswordsMatch =>
      _passwordController.text == _confirmPasswordController.text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
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
                              offset: Offset(0.0, 2.0),
                            ),
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
                    Text("Reset Password",
                        style: AppTextStyle.pageHeadingSemiBold),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                      child: Text(
                        "Your new password must be different from the previously used password",
                        style: AppTextStyle.hintText,
                      ),
                    ),
                    SizedBox(height: 30),
                    Text("New password", style: AppTextStyle.labelText),
                    SizedBox(height: 10),
                    TextFeildStyle(
                      hintText: '●●●●●●●●●',
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a  password.';
                        }
                        return null;
                      },
                      obscureText: setobscureText,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            setobscureText = !setobscureText;
                          });
                        },
                        icon: SvgPicture.asset(
                          setobscureText
                              ? "lib/assets/icons/password.svg"
                              : "lib/assets/icons/closepasswordeye_icon.svg",
                          // color: headingOrange,
                        ),
                      ),
                      textAlignVertical: TextAlignVertical.center,
                      controller: _passwordController,
                      height: 50,
                      onChanged: (value) {
                        setState(() {}); // Update state to reflect validation
                      },
                      border: InputBorder.none,
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          isPasswordLengthValid ? Icons.check : Icons.close,
                          color:
                              isPasswordLengthValid ? Colors.green : Colors.red,
                          size: MediaQuery.of(context).size.width / 30,
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            "The minimum length of the password should be 6 characters",
                            style: AppTextStyle.messageText.copyWith(
                              color: isPasswordLengthValid
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text("Confirm password", style: AppTextStyle.labelText),
                    SizedBox(height: 10),
                    TextFeildStyle(
                      hintText: '●●●●●●●●●',
                      controller: _confirmPasswordController,
                      obscureText: setobscureText2,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            setobscureText2 = !setobscureText2;
                          });
                        },
                        icon: SvgPicture.asset(
                          setobscureText2
                              ? "lib/assets/icons/password.svg"
                              : "lib/assets/icons/closepasswordeye_icon.svg",
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {}); // Update state to reflect validation
                      },
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          doPasswordsMatch ? Icons.check : Icons.close,
                          color: doPasswordsMatch ? Colors.green : Colors.red,
                          size: MediaQuery.of(context).size.width / 30,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Both passwords must match",
                          style: AppTextStyle.messageText.copyWith(
                            color: doPasswordsMatch ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                width: _width,
                height: _height,
                duration: const Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.white,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5.0,
                      offset: Offset(0.0, -3.0),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Visibility(
                            visible: _state,
                            child: GestureDetector(
                              onTap: isPasswordLengthValid && doPasswordsMatch
                                  ? () {
                                      showBottomDrawer(context);
                                      // setState(() {
                                      //   _state = false;
                                      //   _height = 320;
                                      // });
                                    }
                                  : null,
                              child: Container(
                                height: MediaQuery.of(context).size.height / 16,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  border: Border.all(
                                    color: primaryColor,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 0.0,
                                      offset: Offset(0.0, 0.0),
                                    ),
                                  ],
                                ),
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
                          Visibility(
                            visible: !_state,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 5,
                                  width: 60,
                                  transform:
                                      Matrix4.translationValues(0.0, -8.0, 0.0),
                                  decoration: BoxDecoration(
                                    color: Color(0xffC4C4C4),
                                    border: Border.all(
                                      color: Color(0xffC4C4C4),
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 0.0,
                                        offset: Offset(0.0, 0.0),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 8,
                                  child: Image(
                                    image: AssetImage(
                                        "lib/assets/images/success.png"),
                                  ),
                                ),
                                Text(
                                  "Password changed",
                                  style: TextStyle(
                                    fontSize: 27,
                                    color: Colors.black,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 8, 8, 8),
                                  child: Center(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Password changed successfully, you can login again with a new password",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: greyColor,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginSignup(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height:
                                        MediaQuery.of(context).size.height / 18,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      border: Border.all(
                                        color: primaryColor,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 0.0,
                                          offset: Offset(0.0, 0.0),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Done",
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
                              ],
                            ),
                          ),
                        ],
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

  void showBottomDrawer(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 5,
              width: screenWidth * 0.15,
              decoration: BoxDecoration(
                color: Color(0xffC4C4C4),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Image.asset(
              'lib/assets/images/success.png',
              height: screenHeight * 0.12,
            ),
            SizedBox(height: screenHeight * 0.02),
            Text('Password Changed', style: AppTextStyle.pageHeadingSemiBold),
            SizedBox(height: screenHeight * 0.01),
            Text(
                'Password changed successfully, you can login again with a new password',
                textAlign: TextAlign.center,
                style: AppTextStyle.hintText),
            SizedBox(height: screenHeight * 0.03),
            CustomButton(
              text: "Done",
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginSignup()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
