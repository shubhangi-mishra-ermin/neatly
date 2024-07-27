import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meatly/Widget/confirmationtext.dart';
import 'package:meatly/Widget/titlewidget.dart';
import 'package:meatly/globalvariables.dart';
import 'package:meatly/main.dart';
import 'package:meatly/navigationscreen.dart';
import 'package:meatly/screens/Settings/widget/ordercart.dart';
import 'package:meatly/utilities/colors.dart';
import 'package:meatly/utilities/constants.dart';
import 'package:meatly/utilities/textstyles.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  String? _selectedOrderDocId;

  Stream<List<Map<String, dynamic>>> _fetchOrders() {
    String userId = currentUserCredential;
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Orders')
        .where('status', isEqualTo: 'In delivery')
        .snapshots()
        .asyncMap((querySnapshot) async {
      List<Map<String, dynamic>> orders = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> orderData = doc.data();
        List<Map<String, dynamic>> productDetails = [];

        QuerySnapshot<Map<String, dynamic>> productDetailsSnapshot =
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(userId)
                .collection('Orders')
                .doc(doc.id)
                .collection('product_details')
                .get();
        _selectedOrderDocId = doc.id;

        for (var productDoc in productDetailsSnapshot.docs) {
          productDetails.add(productDoc.data());
        }

        orderData['product_details'] = productDetails;
        orders.add(orderData);
      }
      return orders;
    });
  }

  List<Map<String, String>> _convertProductDetails(
      List<Map<String, dynamic>> productDetails) {
    return productDetails.map((product) {
      return {
        'name': product['product_name']?.toString() ?? '',
        'quantity':
            '${product['weight']?.toString()} x ${product['quantity']?.toString()} qty',
        'price': product['price']?.toString() ?? '',
        'image': product['image']?.toString() ?? '',
      };
    }).toList();
  }

  Future<void> _cancelOrder(String orderId) async {
    String userId = currentUserCredential;
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Orders')
          .doc(orderId)
          .update({'status': 'Order cancelled'}).then((value) => {
                print("Order Cancelled!")
                // showSucessM
              });
      Navigator.pop(context);
    } catch (e) {
      print('Failed to cancel order: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleCard(
                title: "Track your order",
                onBack: () {
                nextPage(context, HomeScreen());
                  // nextPage();
                  Navigator.pop(context);
                },
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey[300],
                      child: Icon(Icons.person, size: 30, color: Colors.white),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Yoshith Tbag',
                            style: AppTextStyle.labelText,
                          ),
                          SizedBox(height: 4),
                          Text(
                            '+1 469 512 6569',
                            style: AppTextStyle.messageText
                                .copyWith(color: greyColor),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: CircleAvatar(
                        backgroundColor: primaryColor,
                        child: Icon(Icons.call, color: Colors.white),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Estimated delivery time',
                    style: AppTextStyle.text,
                  ),
                  Text(
                    'Need Help?',
                    style: AppTextStyle.labelText.copyWith(color: primaryColor),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    color: sucessColor,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Today 6AM - 9AM',
                      style: AppTextStyle.textgrey
                          .copyWith(fontSize: 14, color: sucessColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              SvgPicture.asset('lib/assets/images/Progress.svg'),
              SizedBox(height: 16),
              Text(
                'Order Details',
                style: AppTextStyle.text.copyWith(fontWeight: FontWeight.w600),
              ),
              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _fetchOrders(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Something went wrong'));
                    }

                    if (snapshot.data == null || snapshot.data!.isEmpty) {
                      return Center(
                          child: Text(
                        'No orders in delivery',
                        style: AppTextStyle.textSemibold20
                            .copyWith(color: primaryColor, fontSize: 16),
                      ));
                    }

                    return ListView(
                      children: snapshot.data!.map((order) {
                        //  Map<String, dynamic> orderData = order.;
                        // String orderId = order.id; // Firestore document ID

                        return MyOrder(
                          isTrackOrder: true,
                          orderId: order['order_id'] as String,
                          status: order['status'] as String,
                          dateTime:
                              (order['time'] as Timestamp).toDate().toString(),
                          totalPrice: order['total_price'].toString(),
                          items: _convertProductDetails(order['product_details']
                              as List<Map<String, dynamic>>),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 10),
        height: MediaQuery.of(context).size.height / 13,
        width: MediaQuery.of(context).size.width * 0.95,
        child: OutlinedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomConfirmationDialog(
                  title: 'Confirm Cancellation',
                  message: 'Are you sure to cancel this order?',
                  cancelText: 'cancel',
                  confirmText: 'confirm',
                  onCancelPressed: () {
                    Navigator.pop(context);
                  },
                  onConfirmPressed: () {
                    _cancelOrder(_selectedOrderDocId ?? "")
                        .then((value) => {Navigator.pop(context)});
                  },
                );
              },
            );
          },
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: lightGreyColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(80),
            ),
          ),
          child: Text('Cancel Order',
              style: TextStyle(color: primaryColor, fontFamily: 'Inter')),
        ),
      ),
    );
  }
}
