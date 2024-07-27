import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:meatly/Widget/custombutton.dart';
import 'package:meatly/Widget/textfield.dart';
import 'package:meatly/Widget/titlewidget.dart';
import 'package:meatly/utilities/colors.dart';
import 'package:meatly/utilities/constants.dart';
import 'package:meatly/utilities/textstyles.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool setobscureText = true;
  bool setobscureText2 = true;
  bool setobscureText3 = true;
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool notifOn = false;
  bool locationOn = false;
  bool get isPasswordLengthValid => _passwordController.text.length >= 6;
  bool get doPasswordsMatch =>
      _passwordController.text == _confirmPasswordController.text;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
        padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
        child: Column(
          children: [
            TitleCard(
              title: 'Settings',
              onBack: () {
                Navigator.pop(context);
              },
            ),
            2.ph,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Push Notification',
                  style: AppTextStyle.labelText,
                ),
                FlutterSwitch(
                  activeColor: primaryColor,
                  width: 45.0,
                  height: 20.0,
                  // toggleSize: 45.0,
                  value: notifOn,
                  borderRadius: 15.0,
                  padding: 1,
                  onToggle: (val) {
                    setState(() {
                      notifOn = val;
                    });
                  },
                ),
              ],
            ),
            2.ph,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Location',
                  style: AppTextStyle.labelText,
                ),
                FlutterSwitch(
                  activeColor: primaryColor,
                  width: 45.0,
                  height: 20.0,
                  // toggleSize: 45.0,
                  value: locationOn,
                  borderRadius: 15.0,
                  padding: 1,
                  onToggle: (val) {
                    setState(() {
                      locationOn = val;
                    });
                  },
                ),
              ],
            ),
            2.ph,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Language',
                  style: AppTextStyle.labelText,
                ),
                Text(
                  'English',
                  style: AppTextStyle.labelText.copyWith(color: greyColor),
                ),
              ],
            ),
            2.ph,
            Divider(),
            2.ph,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Change Password", style: AppTextStyle.text),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                  child: Text(
                    "Your new password must be different from the previously used password",
                    style: AppTextStyle.hintText,
                  ),
                ),
                2.ph,
                Text("Current password", style: AppTextStyle.labelText),
                SizedBox(height: 10),
                TextFeildStyle(
                  hintText: '●●●●●●●●●',
                  validation: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a  password.';
                    }
                    return null;
                  },
                  obscureText: setobscureText3,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        setobscureText3 = !setobscureText3;
                      });
                    },
                    icon: SvgPicture.asset(
                      setobscureText3
                          ? "lib/assets/icons/password.svg"
                          : "lib/assets/icons/closepasswordeye_icon.svg",
                      // color: headingOrange,
                    ),
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  controller: _currentPasswordController,
                  height: 50,
                  onChanged: (value) {
                    setState(() {});
                  },
                  border: InputBorder.none,
                ),
                SizedBox(height: 20),
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
                      color: isPasswordLengthValid ? Colors.green : Colors.red,
                      size: MediaQuery.of(context).size.width / 30,
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        "The minimum length of the password should be 6 characters",
                        style: AppTextStyle.messageText.copyWith(
                          color:
                              isPasswordLengthValid ? Colors.green : Colors.red,
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
                    setState(() {});
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
            10.ph
          ],
        ),
      ))),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height / 10,
        width: MediaQuery.of(context).size.width * 0.9,
        child: CustomButton(
          text: 'Update',
          onPressed: () => {},
        ),
      ),
    );
  }
}
