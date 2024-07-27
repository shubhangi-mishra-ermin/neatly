import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meatly/globalvariables.dart';
import 'package:meatly/main.dart';
import 'package:meatly/screens/Map%20screens/Location.dart';
import 'package:meatly/utilities/colors.dart';
import 'package:meatly/utilities/textstyles.dart';

class AddressDetailsCard extends StatefulWidget {
  final String deliveryLocation;
  final String cartId;
  final String address;
  final String deliveryTime;

  AddressDetailsCard(
      {required this.deliveryLocation,
      required this.address,
      required this.deliveryTime,
      required this.cartId});

  @override
  _AddressDetailsCardState createState() => _AddressDetailsCardState();
}

class _AddressDetailsCardState extends State<AddressDetailsCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextPage(
            context,
            Location(
              cartId: widget.cartId,
              isAddressbook: false,
            ));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 6,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 3.0,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 24,
                            color: Color(0xffb43221),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(7, 0, 0, 0),
                            child: Text(
                              "Delivery at ",
                              style: AppTextStyle.labelText,
                            ),
                          ),
                          Text(
                            widget.deliveryLocation,
                            style: AppTextStyle.labelText
                                .copyWith(color: primaryColor),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 20,
                        color: Color(0xffb43121),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 2, 10, 0),
                  child: Text(
                    widget.address,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.textGreyMedium12,
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 10, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Estimated delivery time",
                    style: AppTextStyle.textgrey,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: Colors.green,
                          size: 20,
                        ),
                        Text(
                          " ${widget.deliveryTime}",
                          style: AppTextStyle.messageText,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
