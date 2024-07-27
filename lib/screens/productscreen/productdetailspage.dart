import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customizable_counter/customizable_counter.dart';
import 'package:flutter/material.dart';
import 'package:meatly/globalvariables.dart';
import 'package:meatly/main.dart';
import 'package:meatly/screens/cart&checkout/Cartpage.dart';
import 'package:meatly/Widget/itemcardhomepage.dart';
import 'package:meatly/Widget/titlewidget.dart';
import 'package:meatly/utilities/colors.dart';
import 'package:meatly/utilities/textstyles.dart';
import 'package:share/share.dart';

class ProductDescription extends StatefulWidget {
  final String productTitle;
  final String id;
  final String weight;
  final String productImage;
  final String deliveryTime;
  final String productDescription;
  final List<Map<String, String>> productInfo;
  final List<Widget> recommendedItems;
  final double price;

  ProductDescription({
    required this.productTitle,
    this.weight = '',
    required this.id,
    required this.productImage,
    required this.deliveryTime,
    required this.productDescription,
    required this.productInfo,
    required this.recommendedItems,
    required this.price,
  });

  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  double itemCount = 0.0;
  bool showSnackBar = false;
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
          'product_name': widget.productTitle,
          'quantity': itemCount,
          'weight': widget.weight,
          'imageUrl': widget.productImage
        });
      } else {
        final currentQuantity = productSnapshot['quantity'] ?? 0;
        await productRef.update({
          'quantity': currentQuantity + 1,
        });
        setState(() {});
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
      itemCount--;
      final productSnapshot = await productRef.get();
      final currentQuantity = productSnapshot['quantity'] ?? 0;

      if (currentQuantity == 1.0) {
        await productRef.delete();
        // print("productRef deleted");
      } else {
        if (productSnapshot.exists) {
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
      addToCart();
    });
  }

  void decrementItemCount() {
    setState(() {
      removeFromCart();
    });
  }

  void showPersistentSnackBar() {
    setState(() {
      showSnackBar = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleCard(
                      title: '',
                      onBack: () {
                        Navigator.pop(context);
                      },
                      sizeWidget: GestureDetector(
                        onTap: () {
                          Share.share(
                              'Product: ${widget.productTitle}\nDescription: ${widget.productDescription}\nPrice: \$${widget.price}\nDelivery Time: ${widget.deliveryTime}');
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.white,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 2.0,
                                offset: Offset(0.0, 0.0),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.share,
                            size: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: widget.productImage != ""
                          ? Image.network(
                              widget.productImage,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 150,
                            )
                          : null,
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      widget.productTitle,
                      style: AppTextStyle.productHeading,
                    ),
                    SizedBox(height: 12.0),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: sucessColor,
                          size: 20,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Flexible(
                          child: Text(
                            widget.deliveryTime,
                            style: AppTextStyle.textgrey
                                .copyWith(fontSize: 14, color: sucessColor),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.0),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: lightGreyColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: widget.productInfo.map((info) {
                            return _buildInfoCard(info['icon']!, info['text']!);
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Description',
                      style: AppTextStyle.text,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      widget.productDescription,
                      style: AppTextStyle.hintText,
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'You may also like',
                      style: AppTextStyle.text,
                    ),
                    SizedBox(height: 8.0),
                    Container(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.recommendedItems.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: widget.recommendedItems[index],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (showSnackBar)
              Positioned(
                bottom: MediaQuery.of(context).size.height / 10 + 16,
                left: 16,
                right: 16,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 6.0, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Color(0xff0B0D24),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$itemCount items | \$${(widget.price) * itemCount}',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Inter'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Cart()),
                            );
                          },
                          child: Text(
                            'View Cart',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        ),
        height: MediaQuery.of(context).size.height / 10,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\$${widget.price}',
              style: AppTextStyle.productHeading
                  .copyWith(color: primaryColor, fontWeight: FontWeight.bold),
            ),
            Container(
              width: 120,
              height: 50,
              child: FittedBox(
                fit: BoxFit.fill,
                child: CustomizableCounter(
                  borderWidth: 0,
                  borderRadius: 80,
                  backgroundColor: primaryColor,
                  buttonText: " Add Cart ",
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
                    showPersistentSnackBar();
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
      ),
    );
  }

  Widget _buildInfoCard(String iconName, String text) {
    IconData iconData;
    switch (iconName) {
      case 'scale':
        iconData = Icons.scale;
        break;
      case 'pie_chart':
        iconData = Icons.pie_chart;
        break;
      case 'group':
        iconData = Icons.group;
        break;
      default:
        iconData = Icons.info; // default icon
    }

    return Row(
      children: [
        Icon(
          iconData,
          size: 20.0,
          color: primaryColor,
        ),
        SizedBox(height: 4.0),
        Text(
          text,
          style: AppTextStyle.messageText.copyWith(color: greyColor),
        ),
      ],
    );
  }
}
