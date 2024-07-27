import 'package:flutter/material.dart';
import 'package:meatly/Widget/titlewidget.dart';
import 'package:meatly/screens/Settings/widget/settingspage.dart';
import 'package:meatly/utilities/colors.dart';
import 'package:meatly/utilities/constants.dart';
import 'package:meatly/utilities/textstyles.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
        child: Column(
          children: [
            TitleCard(
              title: 'About',
              onBack: () {
                Navigator.pop(context);
              },
            ),
            2.ph,
            Image.asset(
              'lib/assets/images/aboutpage_logo.png',
              width: MediaQuery.of(context).size.width / 2,
            ),
            2.ph,
            Text(
              'App version: 1.0',
              style: AppTextStyle.textSemibold20.copyWith(color: greyColor),
            ),
            Text(
              'Copyrights Meatly 2024',
              style: TextStyle(
                  color: greyColor, fontFamily: 'Inter', fontSize: 15),
            ),
            3.ph,
            Divider(),
            3.ph,
            SettingPageOptions(
              // icon: Icons.info_outline_rounded,
              text: "What’s new",
              onPressed: () {
                // nextPage(context, AboutPage());
                print('About pressed');
              },
            ),
            SettingPageOptions(
              // icon: Icons.info_outline_rounded,
              text: "Software license",
              onPressed: () {
                // nextPage(context, AboutPage());
                print('About pressed');
              },
            ),
            SettingPageOptions(
              // icon: Icons.info_outline_rounded,
              text: "Terms and Conditions",
              onPressed: () {
                // nextPage(context, AboutPage());
                print('About pressed');
              },
            ),
          ],
        ),
      )),
    );
  }
}
