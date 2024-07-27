import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meatly/main.dart';

class ProfileApi {
  static String? selectedOrderDocId;

  static Stream<List<Map<String, dynamic>>> fetchCurrentOrders() {
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
        selectedOrderDocId = doc.id;

        for (var productDoc in productDetailsSnapshot.docs) {
          productDetails.add(productDoc.data());
        }

        orderData['product_details'] = productDetails;
        orders.add(orderData);
        print("orders :: $orders");
      }

      return orders;
    });
  }

  static List<Map<String, String>> convertProductDetails(
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

  static Future<void> cancelCurrentOrder(String orderId) async {
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
    } catch (e) {
      print('Failed to cancel order: $e');
    }
  }
}
