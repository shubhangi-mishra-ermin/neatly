import 'package:flutter/material.dart';
import 'package:meatly/utilities/textstyles.dart';

class SettingPageOptions extends StatelessWidget {
  final IconData? icon;
  final String text;
  final VoidCallback onPressed;

  const SettingPageOptions({
    Key? key,
    this.icon,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (icon != null)
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(0xfff2f2f2),
                      border: Border.all(
                        color: Color(0xfff2f2f2),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 0.0,
                          offset: Offset(0.0, 0.0),
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      size: 24,
                      color: Colors.black,
                    ),
                  ),
                Padding(
                  padding: icon != null
                      ? EdgeInsets.fromLTRB(20, 0, 10, 0)
                      : EdgeInsets.fromLTRB(20, 10, 10, 10),
                  child: Text(
                    text,
                    style: AppTextStyle.labelText,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
