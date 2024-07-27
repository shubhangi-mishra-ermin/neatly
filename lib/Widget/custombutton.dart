import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meatly/utilities/colors.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final String iconSvgPath;
  final double width;
  final double textSize;
  final Color color;
  final bool isPopup;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.iconSvgPath = '',
    this.width = double.infinity,
    this.textSize = 18,
    this.color = Colors.white,
    this.isPopup = false,
  }) : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Center(
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
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed,
            onHover: (isHovered) {
              setState(() {
                _isHovered = isHovered;
              });
            },
            borderRadius: BorderRadius.circular(30),
            child: Center(
              child: Text(
                widget.text,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: widget.textSize,
                  color: Colors.white,
                  // letterSpacing: 1,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
