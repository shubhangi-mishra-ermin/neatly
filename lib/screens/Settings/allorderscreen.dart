import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meatly/Widget/progressHud.dart';
import 'package:meatly/Widget/titlewidget.dart';
import 'package:meatly/globalvariables.dart';
import 'package:meatly/main.dart';
import 'package:meatly/screens/Settings/widget/ordercart.dart';
import 'package:meatly/utilities/colors.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  late Stream<List<Map<String, dynamic>>> _allOrderStream;

  @override
  void initState() {
    super.initState();
    _allOrderStream = _fetchOrders();
  }

  Stream<List<Map<String, dynamic>>> _fetchOrders() {
    String userId = currentUserCredential;
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Orders')
        .orderBy('time', descending: true) // Order by time in descending order

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ProgressHUD(
          isLoading: isLoading.value,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TitleCard(
                    title: "My Orders",
                    onBack: () {
                      Navigator.pop(context);
                    },
                    sizeWidget: Text(
                      "Need help?",
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  StreamBuilder<List<Map<String, dynamic>>>(
                    stream: _allOrderStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text('No orders found');
                      }
                      List<Map<String, dynamic>> orders = snapshot.data!;
          
                      return Column(
                        children: orders.map((order) {
                          String formattedDateTime = order['time'] != null
                              ? DateFormat('dd MMM yyyy, h:mma')
                                  .format((order['time'] as Timestamp).toDate())
                              : 'No date available';
                          return MyOrder(
                            isCurrentOrder: order['status'] == 'In delivery',
                            orderId: order['order_id'] ?? 'Unknown ID',
                            status: order['status'] ?? 'Unknown status',
                            dateTime: formattedDateTime,
                            totalPrice:
                                order['total_price']?.toString() ?? '0.00',
                            items: _convertProductDetails(
                                List<Map<String, dynamic>>.from(
                                    order['product_details'] ?? [])),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
