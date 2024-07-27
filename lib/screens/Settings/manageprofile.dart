import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:meatly/Widget/progressHud.dart';
import 'package:meatly/Widget/textfield.dart';
import 'package:meatly/Widget/titlewidget.dart';
import 'package:meatly/globalvariables.dart';
import 'package:meatly/main.dart';
import 'package:meatly/utilities/colors.dart';
import 'package:meatly/utilities/constants.dart';
import 'package:meatly/utilities/textstyles.dart';
import 'package:meatly/utilities/validatorts.dart';

import '../../Widget/custombutton.dart';

class ManageProfile extends StatefulWidget {
  const ManageProfile({super.key});

  @override
  State<ManageProfile> createState() => _ManageProfileState();
}

class _ManageProfileState extends State<ManageProfile> {
  final _formKey = GlobalKey<FormState>();

  bool _isChecked = false;
  bool setobscureText = true;
  bool _isLoading = false;
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _phonenumberController = TextEditingController();

  File? _image;
  String profilepic = '';
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  final _auth = FirebaseAuth.instance;
  User? _loggedInUser;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() {
    final user = _auth.currentUser;
    print("user :: $user");
    if (user != null) {
      setState(() {
        _loggedInUser = user;
      });
      _fetchUserData();
    }
  }

  void _fetchUserData() async {
    try {
      setState(() {
        _isLoading = true;
      });
      String userId = currentUserCredential;

      print("userId :: $userId");
      print("_loggedInUser!.uid :: ${_loggedInUser!.uid}");
      final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(userId)
              .get();

      if (userSnapshot.exists) {
        setState(() {
          _firstnameController =
              TextEditingController(text: userSnapshot.get('first name'));
          _lastnameController =
              TextEditingController(text: userSnapshot.get('last name'));
          _emailController =
              TextEditingController(text: userSnapshot.get('email'));
          _phonenumberController =
              TextEditingController(text: userSnapshot.get('phone'));
          _dobController =
              TextEditingController(text: userSnapshot.get('date of birth'));
          profilepic = userSnapshot.get('profile pic url');
        });
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _uploadImageToFirebase() async {
    if (_image == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      String fileName = 'profile_${_loggedInUser!.uid}.jpg';
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('Profile images/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(_image!);
      TaskSnapshot taskSnapshot = await uploadTask;

      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      String userId = currentUserCredential;
      await FirebaseFirestore.instance.collection('Users').doc(userId).update({
        'profile pic url': downloadURL,
      });

      print('Profile image updated successfully');
      showSucessMessage(context, 'Profile image updated successfully');
    } catch (e) {
      print('Error uploading image: $e');
      showErrorMessage(context, 'Failed to upload image');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
                          TitleCard(
                            title: 'Manage Profile',
                            onBack: () {
                              Navigator.pop(context);
                            },
                          ),
                          2.ph,
                          Center(
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage: _image != null
                                      ? FileImage(_image!)
                                      : profilepic.isNotEmpty
                                          ? NetworkImage(profilepic)
                                              as ImageProvider<Object>?
                                          : null,
                                  child: _image == null && profilepic.isEmpty
                                      ? Icon(
                                          Icons.person,
                                          size: 50,
                                        )
                                      : null,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: InkWell(
                                    onTap: _pickImage,
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor: primaryColor,
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
                          SizedBox(height: 12),
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
                          SizedBox(height: 12),
                          Text("Date of Birth", style: AppTextStyle.labelText),
                          SizedBox(height: 10),
                          TextFeildStyle(
                            hintText: '09/09/2002',
                            // validation: FormValidators.validateEmail,
                            textAlignVertical: TextAlignVertical.center,
                            controller: _dobController,
                            keyboardType: TextInputType.emailAddress,
                            height: 50,
                            onChanged: (value) {
                              setState(() {});
                            },
                            border: InputBorder.none,
                          ),
                          SizedBox(height: 12),
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
                          SizedBox(height: 12),
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
                          SizedBox(height: 12),
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
            text: 'Update',
            onPressed: () async {
              await _uploadImageToFirebase();
              _updateUserData();
            },
          ),
        ),
      ),
    );
  }

  Future<void> _updateUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String userId = currentUserCredential;

      await FirebaseFirestore.instance.collection('Users').doc(userId).update({
        'first name': _firstnameController.text,
        'last name': _lastnameController.text,
        'email': _emailController.text,
        'phone': _phonenumberController.text,
        'date of birth': _dobController.text,
      });

      print('User data updated successfully');
      showSucessMessage(context, 'User data updated successfully');
    } catch (e) {
      print('Error updating user data: $e');
      showErrorMessage(context, 'Failed to update user data');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
