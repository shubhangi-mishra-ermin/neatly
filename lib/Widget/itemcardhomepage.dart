import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meatly/Widget/customcounter.dart';
import 'package:meatly/globalvariables.dart';
import 'package:meatly/utilities/colors.dart';
import 'package:meatly/utilities/textstyles.dart';
import 'package:meatly/main.dart';

class ItemCard extends StatefulWidget {
  final String imageUrl;
  final String id;
  final double widthFactor;
  final String title;
  final String weight;
  final String pieces;
  final String deliveryTime;
  final double price;
  final double itemcount;
  final Color primaryColor;
  final Color successColor;
  final bool isFav;

  ItemCard({
    required this.imageUrl,
    required this.id,
    required this.title,
    required this.weight,
    required this.pieces,
    required this.deliveryTime,
    required this.price,
    this.isFav = false,
    this.itemcount = 0.0,
    this.widthFactor = 1,
    this.successColor = sucessColor,
    this.primaryColor = const Color(0xffb42132),
  });

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  double itemCount = 0.0;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    itemCount = widget.itemcount;
    isFavorite = widget.isFav;
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addToCart() async {
    try {
      setState(() {
        isLoading(true);
      });

      final userRef = _firestore.collection('Users').doc(currentUserCredential);
      final cartRef = userRef.collection('Cart').doc(currentUserCredential);
      final productRef = cartRef.collection('product_details').doc(widget.id);

      final cartSnapshot = await userRef.collection('Cart').get();
      if (cartSnapshot.docs.isEmpty) {
        await cartRef.set({
          'address': '',
          'payment': '',
        });
      }

      final productSnapshot = await productRef.get();
      itemCount++;

      if (!productSnapshot.exists) {
        await productRef.set({
          'delivery': widget.deliveryTime,
          'price': widget.price,
          'product_id': widget.id,
          'product_name': widget.title,
          'quantity': 1.0,
          'imageUrl': widget.imageUrl,
          'weight': widget.weight,
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
      showSucessMessage(context, 'Item added to cart successfully!');
    } catch (e) {
      setState(() {
        isLoading(false);
      });
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

      final productSnapshot = await productRef.get();
      final currentQuantity = productSnapshot['quantity'] ?? 0;

      if (currentQuantity == 1.0) {
        await productRef.delete();
      } else {
        if (productSnapshot.exists) {
          if (currentQuantity > itemCount) {
            await productRef.update({
              'quantity': currentQuantity - 1,
            });
          } else {
            await productRef.delete();
          }
        }
      }
      setState(() {
        itemCount--;
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
    addToCart();
  }

  void decrementItemCount() {
    removeFromCart();
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      if (isFavorite) {
        addToFavorites(
          productId: widget.id,
          delivery: widget.deliveryTime,
          imageUrl: widget.imageUrl,
          pieces: widget.weight,
          price: widget.price,
          productName: widget.title,
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

      await favouritesRef.doc(productId).set({
        'delivery': delivery,
        'imageUrl': imageUrl,
        'pieces': pieces,
        'price': price,
        'product_name': productName,
        'weight': weight,
      }, SetOptions(merge: true));

      setState(() {
        isLoading(false);
      });
      showSucessMessage(context, 'Item added to favorites successfully!');
    } catch (e) {
      setState(() {
        isLoading(false);
      });
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
      showSucessMessage(context, 'Item removed from favorites successfully!');
    } catch (e) {
      setState(() {
        isLoading(false);
      });
      showErrorMessage(context, 'Failed to remove item from favorites: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Container(
        width: screenWidth / (widget.widthFactor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
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
                    blurRadius: 2.0,
                    offset: Offset(0.0, 0.0),
                  )
                ],
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: screenWidth / 2.8,
                          height: screenHeight / 5.5,
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
                              )
                            ],
                          ),
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: widget.imageUrl != ""
                                ? Image.network(
                                    widget.imageUrl,
                                    fit: BoxFit.cover,
                                    height: 150,
                                  )
                                : null,
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
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                widget.title,
                                style: AppTextStyle.text,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              Text(
                                '${widget.weight} | ${widget.pieces}',
                                style: AppTextStyle.textgrey
                                    .copyWith(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time_rounded,
                                    color: widget.successColor,
                                    size: widget.widthFactor == 1 ? 20 : 10,
                                  ),
                                  if (widget.widthFactor == 1)
                                    SizedBox(
                                      width: 2,
                                    ),
                                  Flexible(
                                    child: Text(
                                      widget.deliveryTime,
                                      style: AppTextStyle.textgrey.copyWith(
                                          fontSize: 10,
                                          color: widget.successColor),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "\$${widget.price}",
                                style: AppTextStyle.priceText,
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
