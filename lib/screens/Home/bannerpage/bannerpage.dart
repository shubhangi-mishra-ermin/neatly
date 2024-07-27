import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meatly/Widget/progressHud.dart';
import 'package:meatly/screens/searchpage/searchpage.dart';
import 'package:meatly/Widget/flashsalecard.dart';
import 'package:meatly/Widget/titlewidget.dart';
import 'package:meatly/globalvariables.dart';
import 'package:meatly/utilities/colors.dart';
import 'package:meatly/utilities/textstyles.dart';

class BannerPage extends StatefulWidget {
  const BannerPage({super.key});

  @override
  State<BannerPage> createState() => _BannerPageState();
}

class _BannerPageState extends State<BannerPage> {
  int _current = 0;
  late Stream<List<Map<String, dynamic>>> _bannerscreenStream;

  @override
  void initState() {
    super.initState();
    _bannerscreenStream = _fetchData();
  }

  final List<String> imgList = [
    'https://firebasestorage.googleapis.com/v0/b/meatly-d190e.appspot.com/o/Banner%20images%2Fbanner3.svg?alt=media&token=bea10b3a-9e48-4acf-a187-0aded1fb1c23',
    'https://firebasestorage.googleapis.com/v0/b/meatly-d190e.appspot.com/o/Banner%20images%2Fbanner2.png?alt=media&token=2befefd7-0036-43d5-8a94-c541d0a5fea6',
  ];
  Stream<List<Map<String, dynamic>>> _fetchData() {
    return FirebaseFirestore.instance
        .collection('Banner')
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.map((doc) {
              var data = doc.data() as Map<String, dynamic>;
              data['id'] = doc.id;
              return data;
            }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ProgressHUD(
          isLoading: isLoading.value,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleCard(
                    title: "",
                    onBack: () {
                      Navigator.pop(context);
                    },
                    sizeWidget: GestureDetector(
                      onTap: () {
                        nextPage(context, Search());
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
                          Icons.search,
                          size: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 13.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          10.0), 
                      child: Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/meatly-d190e.appspot.com/o/Banner%20images%2Fbanner2.png?alt=media&token=2befefd7-0036-43d5-8a94-c541d0a5fea6',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Text(data)

                  RichText(
                    text: TextSpan(
                      style: AppTextStyle.text,
                      children: [
                        TextSpan(text: '9', style: AppTextStyle.priceText),
                        TextSpan(
                          text: ' items',
                        ),
                      ],
                    ),
                  ),
                  StreamBuilder<List<Map<String, dynamic>>>(
                    stream: _bannerscreenStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text("No data available"));
                      } else {
                        final data = snapshot.data!;
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final item = data[index];
                            return FlashSaleCard(
                                id: '${item['id']}',
                                discountText: '${item['discount']}% off',
                                itemName: '${item['product_name']}',
                                weight: '${item['weight']}',
                                price: item['discounted_price'],
                                originalPrice: '${item['original_price']}',
                                timeSlot: '${item['delivery']}',
                                quantity: '${item['pieces']}',
                                primaryColor: primaryColor);
                          },
                        );
                      }
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
