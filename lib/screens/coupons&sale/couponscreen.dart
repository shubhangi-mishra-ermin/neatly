import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:meatly/Widget/titlewidget.dart';
import 'package:meatly/utilities/colors.dart';
import 'package:meatly/utilities/textstyles.dart';

class CouponsScreen extends StatefulWidget {
  @override
  _CouponsScreenState createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen> {
  late Stream<List<Map<String, dynamic>>> _couponStream;

  @override
  void initState() {
    super.initState();
    _couponStream = _fetchData();
  }

  Stream<List<Map<String, dynamic>>> _fetchData() {
    return FirebaseFirestore.instance.collection('Coupons').snapshots().map(
        (querySnapshot) => querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: TitleCard(
                    title: 'Coupons',
                    onBack: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon:
                          Icon(Icons.local_offer_outlined, color: Colors.green),
                      hintText: 'Enter coupon code',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      suffixIcon: Container(
                        margin: EdgeInsets.all(4),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text('Apply',
                              style: AppTextStyle.labelText
                                  .copyWith(color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Text(
                    'Best offers',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _couponStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                          child: Text("No recent searches available"));
                    } else {
                      final favourites = snapshot.data!;
                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: favourites.length,
                        itemBuilder: (context, index) {
                          final item = favourites[index];
                          print("item :: $item");
                          return CouponCard(
                            discountText:
                                '${item['discount']}% OFF - “${item['coupon_code']}”',
                            savingsText: 'Save \$4.55 using this coupon',
                            descriptionText: '${item['description']}',
                            validityText:
                                'Valid until ${formatTimestamp(item['validity'])}',
                            onApply: () {},
                          );
                        },
                      );
                    }
                  },
                ),
                // CouponCard(
                //   discountText: '10% OFF - “WELCOME”',
                //   savingsText: 'Save \$4.55 using this coupon',
                //   descriptionText:
                //       'Use code “WELCOME” and get 10% off on your first order.',
                //   validityText: 'Valid until Apr 08, 2024',
                //   onApply: () {
                //     // Apply coupon logic
                //   },
                // ),
                // CouponCard(
                //   discountText: '5% OFF - “NEW”',
                //   savingsText: 'Save \$2.25 using this coupon',
                //   descriptionText:
                //       'Use code “NEW” and get 5% off on this first order.',
                //   validityText: 'Valid until Apr 04, 2024',
                //   onApply: () {
                //     // Apply coupon logic
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();

    String formattedDate = DateFormat.yMMMMd().format(dateTime);
    return formattedDate;
  }
}

class CouponCard extends StatelessWidget {
  final String discountText;
  final String savingsText;
  final String descriptionText;
  final String validityText;
  final VoidCallback onApply;

  CouponCard({
    required this.discountText,
    required this.savingsText,
    required this.descriptionText,
    required this.validityText,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset(
          'lib/assets/images/card.svg',
          width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height / ,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(40, 10, 40, 15),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          discountText,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        TextButton(
                          onPressed: onApply,
                          child: Text(
                            'Apply',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      savingsText,
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      descriptionText,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      validityText,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
