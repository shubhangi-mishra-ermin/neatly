import 'package:flutter/material.dart';

class CustomImageButton extends StatelessWidget {
  final double size;
  final String imageAsset;
  final VoidCallback onPressed;

  const CustomImageButton({
    Key? key,
    required this.size,
    required this.imageAsset,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.white,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(size / 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4.0,
              offset: Offset(0.0, 2.0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset(
            imageAsset,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
