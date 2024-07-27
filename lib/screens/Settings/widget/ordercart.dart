import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:meatly/Widget/custombutton.dart';
import 'package:meatly/globalvariables.dart';
import 'package:meatly/main.dart';
import 'package:meatly/screens/order&tracking/trackingpage.dart';
import 'package:meatly/utilities/colors.dart';
import 'package:meatly/utilities/textstyles.dart';

class MyOrder extends StatefulWidget {
  final String orderId;
  final String status;
  final String dateTime;
  final String totalPrice;
  final bool isCurrentOrder;
  final bool isTrackOrder;
  final List<Map<String, String>> items;

  MyOrder({
    required this.orderId,
    required this.status,
    required this.dateTime,
    required this.totalPrice,
    required this.items,
    this.isTrackOrder = false,
    this.isCurrentOrder = true,
  });

  @override
  _MyOrderState createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  Future<void> reorder(
      Map<String, String> orderDetails, List<Map<String, String>> items) async {
    try {
      setState(() {
        isLoading(true);
      });
      DocumentReference newOrderRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUserCredential)
          .collection('Orders')
          .doc();
      String orderId = _generateOrderID();

      await newOrderRef.set({
        'order_id': orderId,
        'status': 'In delivery',
        'total_price': orderDetails['totalPrice'],
        'time': Timestamp.now(),
      });

      for (var item in items) {
        await newOrderRef.collection('product_details').doc().set({
          'product_name': item['name'],
          'quantity': item['quantity'],
          'price': item['price'],
          'image': item['image'],
        });
      }
      setState(() {
        isLoading(false);
      });

      print("Order reordered successfully!");
      showSucessMessage(context, 'Order reordered successfully!');
    } catch (e) {
      setState(() {
        isLoading(false);
      });
      print("Failed to reorder: $e");
      showErrorMessage(context, 'Failed to reorder: $e');
    }
  }

  String _generateOrderID() {
    Random random = Random();
    int orderID = random.nextInt(900000000) + 100000000;
    return orderID.toString();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
          child: Container(
            width: constraints.maxWidth,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black12,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 2.0,
                  offset: Offset(2.0, 2.0),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  if (!widget.isTrackOrder)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                            children: [
                              Text(
                                "Order ID: ",
                                style: AppTextStyle.textgrey,
                              ),
                              Flexible(
                                child: Text(
                                  widget.orderId,
                                  style: AppTextStyle.textgrey
                                      .copyWith(color: blackColor),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            widget.isCurrentOrder
                                ? Icon(
                                    Icons.access_time_rounded,
                                    color: sucessColor,
                                  )
                                : Icon(
                                    Icons.check_circle_outlined,
                                    color: sucessColor,
                                  ),
                            Text(
                              " ${widget.status}",
                              style: AppTextStyle.textGreyMedium12.copyWith(
                                  color: !widget.isCurrentOrder
                                      ? sucessColor
                                      : null),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  if (!widget.isTrackOrder)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.dateTime,
                          style: AppTextStyle.textGreyMedium12,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "\$${widget.totalPrice}",
                          style: AppTextStyle.textgrey
                              .copyWith(color: primaryColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  if (!widget.isTrackOrder)
                    Divider(
                      thickness: 1,
                    ),
                  ...widget.items.map((item) => Row(
                        children: [
                          Container(
                            width: constraints.maxWidth / 5,
                            height: constraints.maxWidth / 5,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 0.0,
                                  offset: Offset(0.0, 0.0),
                                ),
                              ],
                            ),
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: item['image']!.isNotEmpty
                                  ? Image(
                                      image: AssetImage(item['image'] ?? ""),
                                    )
                                  : null,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 2, 0),
                            child: Container(
                              width: constraints.maxWidth -
                                  (constraints.maxWidth / 5) -
                                  50,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name']!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: AppTextStyle.textGreyMedium12
                                        .copyWith(
                                            color: blackColor,
                                            fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    item['quantity']!,
                                    style: AppTextStyle.textGreyMedium12
                                        .copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "\$${item['price']!}",
                                    style: AppTextStyle.priceText,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                  Divider(
                    thickness: 1,
                  ),
                  widget.isTrackOrder
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: AppTextStyle.text,
                            ),
                            Text(
                              '\$${widget.totalPrice}',
                              style: AppTextStyle.text,
                            ),
                          ],
                        )
                      : widget.isCurrentOrder
                          ? Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    height: 50,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        // showBottomDrawer(context);
                                      },
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(color: lightGreyColor),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(80),
                                        ),
                                      ),
                                      child: Text('Cancel',
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontFamily: 'Inter')),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: CustomButton(
                                        textSize: 12,
                                        text: 'Track Orders',
                                        onPressed: () {
                                          nextPage(context, TrackingPage());
                                        }))
                              ],
                            )
                          : OutlinedButton(
                              onPressed: () {
                                reorder({
                                  'totalPrice': widget.totalPrice,
                                }, widget.items);
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: lightGreyColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(80),
                                ),
                              ),
                              child: Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: Text(
                                  'Reorder',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                            ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
