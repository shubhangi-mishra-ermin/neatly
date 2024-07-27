import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meatly/Widget/custombutton.dart';
import 'package:meatly/Widget/progressHud.dart';
import 'package:meatly/Widget/textfield.dart';
import 'package:meatly/api/localstorage.dart';
import 'package:meatly/main.dart';
import 'package:meatly/navigationscreen.dart';
import 'package:meatly/utilities/colors.dart';
import 'package:meatly/utilities/textstyles.dart';
import 'package:meatly/utilities/validatorts.dart';
import 'package:meatly/screens/Home/homepage.dart';

class CreateAccount extends StatefulWidget {
  final String phonenumber;
  const CreateAccount({Key? key, required this.phonenumber}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();

  bool _isChecked = false;
  bool setobscureText = true;
  bool _isLoading = false;
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phonenumberController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;

  void _signUp(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        String? userCredential = user.uid;
        print("userCredential :: $userCredential");
        if (userCredential.isEmpty) {
          throw Exception('User ID is empty. Cannot create user document.');
        }

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userCredential)
            .set({
          'first name': _firstnameController.text,
          'last name': _lastnameController.text,
          'email': _emailController.text,
          'phone': widget.phonenumber,
          'password': _passwordController.text,
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create account: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    _phonenumberController = TextEditingController(text: widget.phonenumber);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      isLoading: _isLoading,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 80),
              child: Form(
                key: _formKey,
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
                          Text("Create your account",
                              style: AppTextStyle.pageHeadingSemiBold),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                            child: Text(
                              "Create an account to start looking for the meat you like",
                              style: AppTextStyle.hintText,
                            ),
                          ),
                          SizedBox(height: 30),
                          Text("First Name", style: AppTextStyle.labelText),
                          SizedBox(height: 10),
                          TextFeildStyle(
                            hintText: 'Enter First Name',
                            validation: FormValidators.validateFirstName,
                            textAlignVertical: TextAlignVertical.center,
                            controller: _firstnameController,
                            height: 50,
                            onChanged: (value) {
                              setState(() {});
                            },
                            border: InputBorder.none,
                          ),
                          SizedBox(height: 6),
                          Text("Last Name", style: AppTextStyle.labelText),
                          SizedBox(height: 10),
                          TextFeildStyle(
                            hintText: 'Enter last Name',
                            validation: FormValidators.validateLastName,
                            textAlignVertical: TextAlignVertical.center,
                            controller: _lastnameController,
                            height: 50,
                            onChanged: (value) {
                              setState(() {});
                            },
                            border: InputBorder.none,
                          ),
                          SizedBox(height: 6),
                          Text("Email Address", style: AppTextStyle.labelText),
                          SizedBox(height: 10),
                          TextFeildStyle(
                            hintText: 'Enter email address',
                            validation: FormValidators.validateEmail,
                            textAlignVertical: TextAlignVertical.center,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            height: 50,
                            onChanged: (value) {
                              setState(() {});
                            },
                            border: InputBorder.none,
                          ),
                          SizedBox(height: 6),
                          Text("Phone Number", style: AppTextStyle.labelText),
                          SizedBox(height: 10),
                          Container(
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: IntlPhoneField(
                              enabled: false,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(
                                    left: 12, right: 10, top: 10, bottom: 10),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: primaryColor),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: errorColor),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                counter: SizedBox(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: lightGreyColor),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                hintText: '',
                                hintStyle: AppTextStyle.hintText,
                                labelStyle: AppTextStyle.labelText,
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: lightGreyColor),
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              controller: _phonenumberController,
                              initialCountryCode: 'IN',
                              onChanged: (phone) {
                                print(phone.completeNumber);
                              },
                            ),
                          ),
                          SizedBox(height: 6),
                          Text("Password", style: AppTextStyle.labelText),
                          SizedBox(height: 10),
                          TextFeildStyle(
                            hintText: '●●●●●●●●●',
                            validation: FormValidators.validatePassword,
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
                              ),
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            controller: _passwordController,
                            height: 50,
                            onChanged: (value) {
                              setState(() {});
                            },
                            border: InputBorder.none,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _isChecked,
                            activeColor: primaryColor,
                            onChanged: (bool? value) {
                              setState(() {
                                _isChecked = value ?? false;
                              });
                            },
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: 'I Agree with ',
                                style: TextStyle(
                                  color: blackColor,
                                  fontFamily: 'Inter',
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Terms of Service',
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontFamily: 'Inter',
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {},
                                  ),
                                  TextSpan(
                                    text: ' and ',
                                    style: TextStyle(
                                      color: blackColor,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontFamily: 'Inter',
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {},
                                  ),
                                ],
                              ),
                            ),
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height / 10,
          width: MediaQuery.of(context).size.width * 0.9,
          child: CustomButton(
            text: 'Sign Up',
            onPressed: () => _signUp(context),
          ),
        ),
      ),
    );
  }
}
