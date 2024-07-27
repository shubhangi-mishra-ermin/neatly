import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customizable_counter/customizable_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meatly/globalvariables.dart';
import 'package:meatly/main.dart';
import 'package:meatly/utilities/colors.dart';
import 'package:meatly/utilities/textstyles.dart';

class FlashSaleCard extends StatefulWidget {
  final String discountText;
  final bool isFlashSale;
  final String id;
  final String itemName;
  final String imageUrl;
  final String weight;
  final double price;
  final String originalPrice;
  final String timeSlot;
  final String quantity;
  final Color primaryColor;

  FlashSaleCard({
    required this.discountText,
    this.id = '',
    this.isFlashSale = false,
    this.imageUrl = '',
    required this.itemName,
    required this.weight,
    required this.price,
    required this.originalPrice,
    required this.timeSlot,
    required this.quantity,
    required this.primaryColor,
  });

  @override
  _FlashSaleCardState createState() => _FlashSaleCardState();
}

class _FlashSaleCardState extends State<FlashSaleCard> {
  double itemCount = 0.0;

  @override
  void initState() {
    super.initState();
    // itemCount = widget.quantity;
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> addToCart() async {
    setState(() {
      isLoading(true);
    });
    if (currentUserCredential.isEmpty) {
      print("Current user credential is empty");
      showErrorMessage(context, 'User not logged in.');
      return;
    }

    if (widget.id.isEmpty) {
      print("Product ID is empty");
      showErrorMessage(context, 'Product ID is missing.');
      return;
    }

    try {
      final userRef = _firestore.collection('Users').doc(currentUserCredential);
      final cartRef = userRef.collection('Cart').doc(currentUserCredential);
      final productRef = cartRef.collection('product_details').doc(widget.id);

      print("UserRef: ${userRef.path}");
      print("CartRef: ${cartRef.path}");
      print("ProductRef: ${productRef.path}");

      final cartSnapshot = await userRef.collection('Cart').get();
      if (cartSnapshot.docs.isEmpty) {
        await cartRef.set({
          'address': '',
          'payment': '',
        });
      }

      final productSnapshot = await productRef.get();

      if (!productSnapshot.exists) {
        await productRef.set({
          'delivery': widget.timeSlot,
          'price': widget.price,
          'product_id': widget.id,
          'product_name': widget.itemName,
          'quantity': 1.0,
          'weight': widget.weight,
          'imageUrl': widget.imageUrl,
        });
      } else {
        final currentQuantity = productSnapshot['quantity'] ?? 0;
        await productRef.update({
          'quantity': currentQuantity + 1,
        });
      }
      setState(() {
        isLoading(false);
      });
      print('Item added to cart successfully!');
      showSucessMessage(context, 'Item added to cart successfully!');
    } catch (e) {
      setState(() {
        isLoading(false);
      });
      print("Failed to add item to cart: $e");
      showErrorMessage(context, 'Failed to add item to cart: $e');
    }
  }

  Future<void> removeFromCart() async {
    try {
      setState(() {
        isLoading(true);
      });
      final userRef = _firestore.collection('Users').doc(currentUserCredential);
      final cartRef = userRef.collection('Cart').doc(currentUserCredential);
      final productRef = cartRef.collection('product_details').doc(widget.id);

      if (itemCount == 0) {
        await cartRef.delete();
      } else {
        final productSnapshot = await productRef.get();
        if (productSnapshot.exists) {
          final currentQuantity = productSnapshot['quantity'] ?? 0;
          if (currentQuantity > itemCount) {
            await productRef.update({
              'quantity': currentQuantity - 1,
            });
            setState(() {});
          } else {
            await productRef.delete();
          }
        }
      }

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Item removed from cart successfully!'),
      //     backgroundColor: Colors.green,
      //   ),
      // );
      setState(() {
        isLoading(false);
      });
    } catch (e) {
      setState(() {
        isLoading(false);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to remove item from cart: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void incrementItemCount() {
    setState(() {
      itemCount++;
      addToCart();
    });
  }

  void decrementItemCount() {
    setState(() {
      if (itemCount > 0) {
        itemCount--;
        removeFromCart();
      }
    });
  }

  bool isFavorite = false;

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      if (isFavorite) {
        addToFavorites(
          productId: widget.id,
          delivery: widget.timeSlot,
          imageUrl: widget.imageUrl,
          pieces: widget.weight,
          price: widget.price,
          productName: widget.itemName,
          weight: widget.weight,
        );
      } else {
        removeFromFavorites(widget.id);
      }
    });
  }

  Future<void> addToFavorites({
    required String productId,
    required String delivery,
    required String imageUrl,
    required String pieces,
    required double price,
    required String productName,
    required String weight,
  }) async {
    try {
      setState(() {
        isLoading(true);
      });
      final userRef = _firestore.collection('Users').doc(currentUserCredential);
      final favouritesRef = userRef.collection('Favourites');

      final collectionSnapshot = await favouritesRef.get();

      final productDoc = await favouritesRef.doc(productId).get();

      if (productDoc.exists) {
        await favouritesRef.doc(productId).set({
          'delivery': delivery,
          'imageUrl': imageUrl,
          'pieces': pieces,
          'price': price,
          'product_name': productName,
          'weight': weight,
        }, SetOptions(merge: true));
      } else {
        await favouritesRef.doc(productId).set({
          'delivery': delivery,
          'imageUrl': imageUrl,
          'pieces': pieces,
          'price': price,
          'product_name': productName,
          'weight': weight,
        });
      }
      setState(() {
        isLoading(false);
      });
      print("Item added to favorites successfully!");
      showSucessMessage(context, 'Item added to favorites successfully!');
    } catch (e) {
      setState(() {
        isLoading(false);
      });
      print("Failed to add item to favorites: $e");
      showErrorMessage(context, 'Failed to add item to favorites: $e');
    }
  }

  Future<void> removeFromFavorites(String productId) async {
    try {
      setState(() {
        isLoading(true);
      });
      final userRef = _firestore.collection('Users').doc(currentUserCredential);
      final favouritesRef = userRef.collection('Favourites');
      await favouritesRef.doc(productId).delete();
      setState(() {
        isLoading(false);
      });
      showSucessMessage(context, 'Item removed to favorites successfully!');
    } catch (e) {
      setState(() {
        isLoading(false);
      });
      showErrorMessage(context, 'Failed to remove item to favorites: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        // color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                widget.imageUrl != ''
                    ? Image.network(
                        widget.imageUrl,
                        fit: BoxFit.fitWidth,
                        width: double.infinity,
                        height: 150,
                      )
                    : Image.asset(
                        'lib/assets/images/chicken.png',
                        width: double.infinity,
                      ),
                if (widget.isFlashSale)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        widget.discountText,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: toggleFavorite,
                    child: Container(
                      width: 40,
                      height: 40,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.white,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 0.0,
                            offset: Offset(0.0, 0.0),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: isFavorite
                              ? widget.primaryColor
                              : widget.primaryColor,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.itemName,
                    style: AppTextStyle.text,
                    overflow: TextOverflow.ellipsis,
                    // maxLines: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.weight} | ${widget.quantity} pieces',
                        style: AppTextStyle.textgrey.copyWith(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      Row(
                        // mainAxisAlignment:,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            color: sucessColor,
                            size: 15,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Flexible(
                            child: Text(
                              widget.timeSlot,
                              style: AppTextStyle.textgrey
                                  .copyWith(fontSize: 12, color: sucessColor),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.isFlashSale)
                            Text(
                              "\$${widget.originalPrice}  ",
                              style: AppTextStyle.hintText.copyWith(
                                  decoration: TextDecoration.lineThrough),
                            ),
                          Text(
                            "\$${widget.price}",
                            style: AppTextStyle.priceText,
                          ),
                        ],
                      ),
                      Container(
                        height: 30,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: CustomizableCounter(
                            borderWidth: 0,
                            borderRadius: 80,
                            backgroundColor: widget.primaryColor,
                            buttonText: "+",
                            textColor: Colors.white,
                            textSize: 12,
                            count: itemCount,
                            step: 1,
                            minCount: 0,
                            maxCount: 10,
                            incrementIcon: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 14,
                            ),
                            decrementIcon: const Icon(
                              Icons.remove,
                              color: Colors.white,
                              size: 14,
                            ),
                            onCountChange: (count) {
                              setState(() {
                                itemCount = count;
                              });
                            },
                            onIncrement: (count) {
                              incrementItemCount();
                            },
                            onDecrement: (count) {
                              decrementItemCount();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
