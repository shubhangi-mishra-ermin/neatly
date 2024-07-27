import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meatly/main.dart';

class CartController extends GetxController {
  var cartItems = <Map<String, dynamic>>[].obs;
  var cartTotalAmount = 0.0.obs;
  var deliveryLocation = "Fetching location...".obs;
  var isLoading = false.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static String cartId = '';

  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
  }

  Future<void> _fetchLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        deliveryLocation.value = "Location permission denied";
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      deliveryLocation.value = "Location permissions are permanently denied";
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      deliveryLocation.value = "${position.latitude}, ${position.longitude}";
    } catch (e) {
      deliveryLocation.value = "Error fetching location";
    }
  }

  Future<void> fetchCartItems() async {
    isLoading.value = true;

    try {
      final userRef = _firestore.collection('Users').doc(currentUserCredential);
      final cartSnapshot = await userRef.collection('Cart').get();

      List<Map<String, dynamic>> fetchedCartItems = [];
      double totalAmount = 0.0;

      for (var cartDoc in cartSnapshot.docs) {
        cartId = cartDoc.id;

        if (cartDoc['address'] != "") {
          deliveryLocation.value = cartDoc['address'];
        } else {
          await _fetchLocation();
        }

        final productRef = cartDoc.reference.collection('product_details');
        final productSnapshot = await productRef.get();

        if (productSnapshot.docs.isNotEmpty) {
          for (var doc in productSnapshot.docs) {
            final quantity = doc['quantity'];
            final price = doc['price'];

            fetchedCartItems.add({
              'quantity': doc['quantity'],
              'id': doc['product_id'],
              'imageUrl': '',
              'title': doc['product_name'],
              'pieces': '',
              'weight': doc['weight'],
              'deliveryTime': doc['delivery'],
              'price': doc['price'],
            });
            totalAmount += quantity * price;
          }
        }
      }

      cartItems.value = fetchedCartItems;
      cartTotalAmount.value = totalAmount;
    } catch (e) {
      print('Error fetching cart items: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void onQuantityChange(String productId, int newQuantity) {
    final itemIndex = cartItems.indexWhere((item) => item['id'] == productId);
    if (itemIndex != -1) {
      if (newQuantity == 0) {
        cartItems.removeAt(itemIndex);
      } else {
        cartItems[itemIndex]['quantity'] = newQuantity;
      }
      updateCartTotalAmount();
    }
  }

  void updateCartTotalAmount() {
    double totalAmount = 0.0;
    for (var item in cartItems) {
      totalAmount += item['quantity'] * item['price'];
    }
    cartTotalAmount.value = totalAmount;
  }
}
