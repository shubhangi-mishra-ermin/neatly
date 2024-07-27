import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meatly/screens/Map%20screens/MapScreen.dart';
import 'package:meatly/utilities/colors.dart';
import 'package:meatly/utilities/textstyles.dart';

class CustomAddressCard extends StatefulWidget {
  final String title;
  final String address;
  final IconData prefixIcon;
  final IconData suffixIcon;
  final bool current;
  final Function? onTap;

  CustomAddressCard({
    required this.title,
    required this.address,
    required this.prefixIcon,
    this.suffixIcon = Icons.more_vert,
    this.current = false,
    this.onTap,
  });

  @override
  _CustomAddressCardState createState() => _CustomAddressCardState();
}

class _CustomAddressCardState extends State<CustomAddressCard> {
  String location = "";
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        (widget.current) ? _openMapsScreen(context) : widget.onTap;
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 9,
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
                        Icon(
                          widget.prefixIcon,
                          size: 26,
                          color: Color(0xffb43221),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.current)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(7, 0, 0, 0),
                                child: Text(
                                  " Use your ",
                                  style: AppTextStyle.labelText,
                                ),
                              ),
                            if (!widget.current)
                              SizedBox(
                                width: 5,
                              ),
                            Text(
                              widget.title,
                              style: AppTextStyle.labelText
                                  .copyWith(color: primaryColor),
                            ),
                          ],
                        ),
                        Spacer(),
                        if (!widget.current)
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
                    padding: const EdgeInsets.fromLTRB(45, 2, 10, 0),
                    child: Text(
                      location.isEmpty ? widget.address : location,
                      overflow: TextOverflow.visible,
                      style: AppTextStyle.textGreyMedium12,
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

  void _openMapsScreen(BuildContext context) async {
    final selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapScreen()),
    );

    if (selectedLocation != null) {
      setState(() {
        location = selectedLocation;
      });
    }
  }
}
