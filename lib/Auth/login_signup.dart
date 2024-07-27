import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:meatly/Auth/createaccount.dart';
import 'package:meatly/Auth/email_verification.dart';
import 'package:meatly/Auth/phone_verification.dart';
import 'package:meatly/Widget/custombutton.dart';
import 'package:meatly/Widget/customimagebutton.dart';
import 'package:meatly/Widget/customtextbutton.dart';
import 'package:meatly/Widget/customtextfield.dart';
import 'package:meatly/Widget/customtogglebar.dart';
import 'package:meatly/Auth/api/auth_api.dart';
import 'package:meatly/Widget/progressHud.dart';
import 'package:meatly/globalvariables.dart';
import 'package:meatly/navigationscreen.dart';
import 'package:meatly/utilities/colors.dart';
import 'package:meatly/utilities/textstyles.dart';
import 'package:meatly/utilities/validatorts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginSignup extends StatefulWidget {
  const LoginSignup({Key? key}) : super(key: key);

  @override
  _LoginSignupState createState() => _LoginSignupState();
}

class _LoginSignupState extends State<LoginSignup> {
  bool mobileSelect = true;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phonenumController = TextEditingController();

  String? _phoneNumError;
  String? _emailError;
  final AuthService _authService = AuthService();
  final LoginSignupController _controller = Get.put(LoginSignupController());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

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

  Future<void> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oAuthProvider = OAuthProvider('apple.com');
      final authCredential = oAuthProvider.credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(authCredential);

      print('User signed in with Apple: ${userCredential.user?.displayName}');
    } catch (e) {
      print('Error signing in with Apple: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in with Apple: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ProgressHUD(
        isLoading: _controller.isLoading.value,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 12,
                    width: MediaQuery.of(context).size.width / 2.3,
                    child: Center(
                      child: Image(
                        image: AssetImage("lib/assets/images/Logor.png"),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Log in or sign up",
                        style: AppTextStyle.pageHeading,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      CustomTogglebar(
                        mobileSelect: mobileSelect,
                        onToggle: (bool isSelected) {
                          setState(() {
                            mobileSelect = isSelected;
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      mobileSelect
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Please enter your phone number. You will receive an OTP code in the next step for the verification process.",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: greyColor,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Please enter your Email. You will receive an OTP code in the next step for the verification process.",
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
                      mobileSelect
                          ? IntlPhoneField(
                              decoration:
                                  InputDecoration(errorText: _phoneNumError),
                              controller: _phonenumController,
                              initialCountryCode: 'IN',
                              onChanged: (phone) {
                                print(phone.completeNumber);
                              },
                            )
                          : CustomTextField(
                              inputType: TextInputType.emailAddress,
                              hint: 'Enter your email...',
                              controller: _emailController,
                              errorText: _emailError,
                              onChanged: (value) {
                                setState(() {
                                  _emailError = null;
                                });
                              },
                            ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Or continue with",
                              style: TextStyle(
                                fontSize: 15,
                                color: greyColor,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomImageButton(
                            size: 60,
                            imageAsset: 'lib/assets/images/google logo.png',
                            onPressed: () async {
                              _controller.setLoading(true);

                              User? user =
                                  await _authService.signInWithGoogle();
                              if (user != null) {
                                if (user.metadata != null &&
                                    user.metadata.creationTime != null &&
                                    user.metadata.lastSignInTime != null) {
                                  if (user.metadata.creationTime ==
                                      user.metadata.lastSignInTime) {
                                    _controller.setLoading(false);
                                    print(
                                        "user.metadata.creationTime :: ${user.metadata.creationTime}");
                                    print(
                                        "user.metadata.lastSignInTime :: ${user.metadata.lastSignInTime}");

                                    nextPage(
                                        context,
                                        CreateAccount(
                                          phonenumber: _phonenumController.text,
                                        ));
                                  } else {
                                    _controller.setLoading(false);
                                    print("Inside else");
                                    nextPage(context, HomeScreen());
                                  }
                                } else {
                                  showErrorMessage(context,
                                      'User metadata is null or incomplete');
                                }
                              } else {
                                showErrorMessage(context, 'User is null');
                              }
                            },
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 15,
                          ),
                          CustomImageButton(
                            size: 60,
                            imageAsset: 'lib/assets/images/apple logo.png',
                            onPressed: () {
                              signInWithApple();
                              print('Apple button pressed!');
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        CustomTextButton(
                          text: "Skip",
                          onPressed: () {
                            nextPage(context, HomeScreen());
                          },
                        ),
                        SizedBox(height: 10),
                        CustomButton(
                          text: 'Next',
                          onPressed: () async {
                            bool isValid = mobileSelect
                                ? validatePhone()
                                : validateEmail();

                            if (isValid) {
                              if (mobileSelect) {
                                _controller.setLoading(true);
                                print("userCredential :: ${_authService.userCredential}");
                                await _authService.signInWithPhone(
                                  '+91${_phonenumController.text}',
                                  context,
                                  onCodeSent: (verificationId) {
                                    _controller.setLoading(false);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PhoneVerification(
                                          phoneNum: _phonenumController.text,
                                          verificationId: verificationId,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                _controller.setLoading(true);
                                try {
                                  await _authService
                                      .sendEmailVerification(
                                          _emailController.text)
                                      .then((value) => {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EmailVerification(
                                                  email: _emailController.text,
                                                ),
                                              ),
                                            )
                                          });
                                } catch (e) {
                                  showErrorMessage(context,
                                      'Failed to send email verification');
                                }
                                _controller.setLoading(false);
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool validatePhone() {
    String? phoneNum = _phonenumController.text.trim();
    String? error = FormValidators.validatePhoneNumber(phoneNum);
    setState(() {
      _phoneNumError = error;
    });
    return error == null;
  }

  bool validateEmail() {
    String? email = _emailController.text.trim();
    String? error = FormValidators.validateEmail(email);
    setState(() {
      _emailError = error;
    });
    return error == null;
  }
}

class LoginSignupController extends GetxController {
  var isLoading = false.obs;

  void setLoading(bool value) {
    isLoading.value = value;
  }
}
