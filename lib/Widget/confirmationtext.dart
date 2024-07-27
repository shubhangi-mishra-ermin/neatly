import 'package:flutter/material.dart';
import 'package:meatly/Widget/custombutton.dart';
import 'package:meatly/utilities/colors.dart';
import 'package:meatly/utilities/constants.dart';

class CustomConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onCancelPressed;
  final VoidCallback onConfirmPressed;

  const CustomConfirmationDialog(
      {Key? key,
      required this.title,
      required this.message,
      required this.onCancelPressed,
      required this.onConfirmPressed,
      required this.confirmText,
      required this.cancelText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Stack(children: [
        Positioned(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Icon(
                Icons.close,
                size: 15,
              ),
            ),
          ),
          top: 0,
          right: 0,
        ),
        Padding(
          padding:
              const EdgeInsets.only(bottom: 20, left: 10, right: 10, top: 20),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: blackColor,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  message,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: greyColor,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onCancelPressed,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: lightGreyColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80),
                          ),
                        ),
                        child: Text(cancelText,
                            style: TextStyle(
                                color: primaryColor, fontFamily: 'Inter')),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: CustomButton(
                        // isPopup: true,
                        textSize: 14,
                        // width: MediaQuery.of(context).size.width / 5,
                        text: confirmText,
                        onPressed: onConfirmPressed,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
