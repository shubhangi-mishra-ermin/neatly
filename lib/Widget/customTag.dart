import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTag extends StatelessWidget {
  final String imagePath;
  final String text;

  const CustomTag({
    Key? key,
    required this.imagePath,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 1, 8, 1),
      child: Container(
        height: MediaQuery.of(context).size.height / 25,
        // width: MediaQuery.of(context).size.width / 3.5,
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
              blurRadius: 2.0,
              offset: Offset(0.0, 0.0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 30,
                width: MediaQuery.of(context).size.height / 30,
                decoration: BoxDecoration(
                  color: Color(0xffF8E8EB),
                  border: Border.all(
                    color: Color(0xffF8E8EB),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 0.0,
                      offset: Offset(0.0, 0.0),
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  imagePath,
                  // height: 10,
                  // width: 10,
                  // fit: BoxFit.contain,
                ),
              ),
              Text(
                text,
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                  fontSize: 13,
                ),
              ),
              SizedBox(width: 1),
            ],
          ),
        ),
      ),
    );
  }
}
