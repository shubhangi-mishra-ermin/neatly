import 'package:flutter/material.dart';

class TitleCard extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final Widget sizeWidget;
  final bool showBackButton;

  const TitleCard({
    Key? key,
    required this.title,
    this.onBack,
    this.showBackButton = true,
    this.sizeWidget = const SizedBox(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showBackButton)
                GestureDetector(
                  onTap: onBack,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 2.0,
                          offset: Offset(0.0, 0.0),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 25,
              ),
              Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  fontFamily: 'Inter',
                  fontSize: 16,
                ),
              ),
            ],
          ),
          sizeWidget
        ],
      ),
    );
  }
}
