import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meatly/screens/Map%20screens/MapScreen.dart';
import 'package:meatly/utilities/colors.dart';
import 'package:meatly/utilities/textstyles.dart';

class CardDetailsCard extends StatefulWidget {
  final String title;
  final String expiredate;
  final IconData suffixIcon;
  final bool current;

  CardDetailsCard(
      {required this.title,
      required this.expiredate,
      this.suffixIcon = Icons.more_vert,
      this.current = false});

  @override
  _CardDetailsCardState createState() => _CardDetailsCardState();
}

class _CardDetailsCardState extends State<CardDetailsCard> {
  String location = "";
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // _openMapsScreen(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 2),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 7,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.white,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 2.0,
                offset: Offset(0.0, 0.0),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.title,
                          style: AppTextStyle.textSemibold20
                              .copyWith(color: primaryColor),
                        ),
                        Spacer(),
                        Icon(
                          widget.suffixIcon,
                          size: 20,
                          color: greyColor,
                        ),
                        // Positioned(
                        //     right: 0,
                        //     child: Icon(
                        //       widget.prefixIcon,
                        //       size: 24,
                        //       color: Colors.black,
                        //     )),
                        // Align(
                        //   alignment: Alignment.centerRight,
                        //   child: Icon(
                        //     widget.prefixIcon,
                        //     size: 24,
                        //     color: Colors.black,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                    child: Row(
                      children: [
                        Text(
                          widget.expiredate,
                          overflow: TextOverflow.visible,
                          style: AppTextStyle.textGreyMedium12,
                        ),
                        Spacer(),
                        Image.asset('lib/assets/icons/paypallogo.png')
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
