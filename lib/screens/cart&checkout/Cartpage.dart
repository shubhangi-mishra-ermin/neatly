import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meatly/Widget/progressHud.dart';
import 'package:meatly/main.dart';
import 'package:meatly/screens/cart&checkout/widget/addressdetails.dart';
import 'package:meatly/screens/cart&checkout/widget/paymentSummary.dart';
import 'package:meatly/screens/coupons&sale/couponscreen.dart';
import 'package:meatly/screens/Payment/paymentscreen.dart';
import 'package:meatly/Widget/titlewidget.dart';
import 'package:meatly/Widget/itemcardhomepage.dart';
import 'package:meatly/utilities/colors.dart';
import 'package:meatly/utilities/textstyles.dart';
import 'package:meatly/globalvariables.dart';
import '../../Widget/custombutton.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  String _deliveryLocation = "Fetching location...";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }


Future<void> _fetchLocation() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      setState(() {
        _deliveryLocation = "Location permission denied";
      });
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    setState(() {
      _deliveryLocation = "Location permissions are permanently denied";
    });
    return;
  }

  try {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude);
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      setState(() {
        _deliveryLocation =
            "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      });
    } else {
      setState(() {
        _deliveryLocation = "Address not found";
      });
    }
  } catch (e) {
    setState(() {
      _deliveryLocation = "Error fetching location";
    });
  }
}
  double cartTotalAmount = 0.0;
  double taxes = 2.04;
  double delivery = 0.0;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> cartItems = [];
  static String cartId = '';

  Future<void> fetchCartItems() async {
    setState(() {
      isLoading = true;
    });

    try {
      final userRef = _firestore.collection('Users').doc(currentUserCredential);
      final cartSnapshot = await userRef.collection('Cart').get();

      List<Map<String, dynamic>> fetchedCartItems = [];
      double totalAmount = 0.0;

      for (var cartDoc in cartSnapshot.docs) {
        cartId = cartDoc.id;
        print("cartId :: $cartId");
        print("_deliveryLocation firestore :: ${cartDoc['address']}");

        if (cartDoc['address'] != "") {
          setState(() {
            _deliveryLocation = cartDoc['address'];
          });
          print("_deliveryLocation firestore 2:: $_deliveryLocation");
        } else {
          await _fetchLocation();
        }

        final productRef = cartDoc.reference.collection('product_details');
        final productSnapshot = await productRef.get();

        print(
            "Cart ID: ${cartDoc.id}, Product Details Count: ${productSnapshot.docs.length}");

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

            print(
                "Added product: ${doc['product_id']} - ${doc['product_name']}");
          }
        }
      }

      print("Total fetched items: ${fetchedCartItems.length}");

      setState(() {
        cartItems = fetchedCartItems;
        cartTotalAmount = totalAmount;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching cart items: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void updateCartTotalAmount() {
    double totalAmount = 0.0;
    for (var item in cartItems) {
      totalAmount += item['quantity'] * item['price'];
    }
    setState(() {
      cartTotalAmount = totalAmount;
    });
  }

  void onQuantityChange(String productId, int newQuantity) {
    setState(() {
      final itemIndex = cartItems.indexWhere((item) => item['id'] == productId);
      if (itemIndex != -1) {
        if (newQuantity == 0) {
          cartItems.removeAt(itemIndex);
        } else {
          cartItems[itemIndex]['quantity'] = newQuantity;
        }
        updateCartTotalAmount();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      isLoading: isLoading,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 30, 15, 100),
            child: cartItems.isEmpty
                ? Column(
                    children: [
                      TitleCard(
                        title: "Cart",
                        showBackButton: false,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height / 5),
                        child: Center(
                          child: Text(
                            'Cart Empty',
                            style: AppTextStyle.pageHeadingSemiBold
                                .copyWith(color: primaryColor),
                          ),
                        ),
                      ),
                    ],
                  )
                : Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleCard(
                              title: "Cart",
                              showBackButton: false,
                            ),
                            Text(
                              "Review Items",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1,
                                fontSize: 16,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(2, 10, 2, 10),
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: cartItems.length,
                                itemBuilder: (context, index) {
                                  final item = cartItems[index];
                                  print("item :: $item");
                                  return ItemCard(
                                    itemcount: item['quantity'] ?? 1.0,
                                    id: item['id'],
                                    imageUrl: item['imageUrl'],
                                    title: item['title'],
                                    pieces: item['pieces'],
                                    weight: item['weight'],
                                    deliveryTime: item['deliveryTime'],
                                    price: item['price'],
                                    // onQuantityChange: onQuantityChange,
                                  );
                                },
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                nextPage(context, CouponsScreen());
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(2, 10, 2, 10),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.08,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50),
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 2.0,
                                        offset: Offset(0.0, 0.0),
                                      )
                                    ],
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.local_offer_rounded,
                                              size: 20,
                                              color: sucessColor,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      7, 8, 0, 8),
                                              child: Text(
                                                "Apply Coupon",
                                                style: AppTextStyle.textgrey,
                                              ),
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
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Text(
                                "Address details",
                                style: AppTextStyle.text,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(2, 10, 2, 10),
                              child: AddressDetailsCard(
                                deliveryLocation: "Home",
                                cartId: cartId,
                                address: _deliveryLocation,
                                deliveryTime: "Today 6AM - 9AM",
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(2, 10, 2, 10),
                              child: Text(
                                "Payment Summary",
                                style: AppTextStyle.text,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(2, 10, 2, 10),
                              child: PaymentSummaryCard(
                                itemTotal: 25.00,
                                deliveryCharges: 0.0,
                                taxes: 2.04,
                                total: cartTotalAmount,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        floatingActionButton: cartItems.isEmpty
            ? SizedBox()
            : Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                ),
                height: MediaQuery.of(context).size.height / 13,
                width: MediaQuery.of(context).size.width * 0.9,
                child: CustomButton(
                  text:
                      "Pay \$${(cartTotalAmount + taxes + delivery).toStringAsFixed(2)}",
                  onPressed: () {
                    nextPage(
                        context,
                        PaymentScreen(
                            cartId: cartId,
                            paymentAmount: cartTotalAmount + taxes + delivery));
                  },
                ),
              ),
      ),
    );
  }
}
