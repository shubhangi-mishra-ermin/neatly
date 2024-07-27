import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:meatly/Widget/customTag.dart';
import 'package:meatly/Widget/flashsalecard.dart';
import 'package:meatly/Widget/titlewidget.dart';
import 'package:meatly/globalvariables.dart';
import 'package:meatly/navigationscreen.dart';
import 'package:meatly/screens/Home/bannerpage/bannerpage.dart';
import 'package:meatly/screens/Home/tagscreens/foodcontroller.dart';
import 'package:meatly/utilities/colors.dart';

class TagScreen extends StatefulWidget {
  final String tagName; // Add a parameter to accept the tag name

  const TagScreen({super.key, required this.tagName});

  @override
  State<TagScreen> createState() => _TagScreenState();
}

class _TagScreenState extends State<TagScreen> {
  final FoodController _foodController = Get.put(FoodController());

  int _current = 0;
  late Stream<List<Map<String, dynamic>>> _tagscreenStream;

  @override
  void initState() {
    super.initState();
    if (widget.tagName == 'Flash sale') {
      _tagscreenStream = _fetchData();
    } else {
      _foodController.fetchFoodItemsList(widget.tagName);
    }
  }

  final List<String> imgList = [
    'lib/assets/images/banner1.png',
    'lib/assets/images/bannerImage.png',
  ];

  Stream<List<Map<String, dynamic>>> _fetchData() {
    return FirebaseFirestore.instance
        .collection(widget.tagName)
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
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleCard(
                  title: widget.tagName,
                  onBack: () {
                    nextPage(context, HomeScreen());
                  },
                  sizeWidget: GestureDetector(
                    onTap: () {},
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
                _foodController.foodTags.isEmpty
                    ? Center(
                        child: CircularProgressIndicator(
                        color: primaryColor,
                      ))
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                        child: Container(
                          height: MediaQuery.of(context).size.height / 23,
                          width: MediaQuery.of(context).size.width,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    nextPage(
                                        context,
                                        TagScreen(
                                          tagName: 'Flash sale',
                                        ));
                                  },
                                  child: CustomTag(
                                      imagePath:
                                          'lib/assets/icons/flashsale.svg',
                                      text: 'Flash Sale'),
                                ),
                                ..._foodController.foodTags.map((tag) {
                                  return GestureDetector(
                                    onTap: () {
                                      nextPage(
                                          context,
                                          TagScreen(
                                            tagName: tag,
                                          ));
                                    },
                                    child: CustomTag(
                                      imagePath: getImagePathForTag(tag),
                                      text: tag,
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ),
                      ),
                Column(
                  children: [
                    CarouselSlider(
                      items: imgList
                          .map((item) => GestureDetector(
                                onTap: () {
                                  nextPage(context, BannerPage());
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 18.0),
                                  child: Image.asset(
                                    item,
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                ),
                              ))
                          .toList(),
                      options: CarouselOptions(
                        height: MediaQuery.of(context).size.height / 4,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        aspectRatio: 16 / 9,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        viewportFraction: 1,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: imgList.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () => _current = entry.key,
                          child: Container(
                            width: 8.0,
                            height: 8.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : primaryColor)
                                  .withOpacity(
                                      _current == entry.key ? 0.9 : 0.4),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                widget.tagName == 'Flash sale'
                    ? StreamBuilder<List<Map<String, dynamic>>>(
                        stream: _tagscreenStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text("Error: ${snapshot.error}"));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
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
                                    isFlashSale: true,
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
                      )
                    : Obx(() {
                        if (_foodController.foodItemsMap[widget.tagName] ==
                            null) {
                          return Center(child: CircularProgressIndicator());
                        } else if (_foodController
                            .foodItemsMap[widget.tagName]!.isEmpty) {
                          return Center(child: Text("No data available"));
                        } else {
                          final data =
                              _foodController.foodItemsMap[widget.tagName]!;
                          return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final item = data[index];
                              return FlashSaleCard(
                                imageUrl: item['imageUrl'] ?? '',
                                id: '${item['id']}',
                                discountText: '',
                                itemName: '${item['product_name']}',
                                weight: '${item['weight']}',
                                price: item['price'],
                                originalPrice: '',
                                timeSlot: '${item['delivery']}',
                                quantity: '${item['pieces']}',
                                primaryColor: primaryColor,
                              );
                            },
                          );
                        }
                      }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getImagePathForTag(String tag) {
    switch (tag.toLowerCase()) {
      case 'chicken':
        return 'lib/assets/icons/drumstick (1).svg';
      case 'mutton':
        return 'lib/assets/icons/drumstick (1).svg';
      case 'lamb':
        return 'lib/assets/icons/fish.svg';
      case 'fish':
        return 'lib/assets/icons/fish.svg';
      case 'shrimp':
        return 'lib/assets/icons/flashsale.svg';
      case 'beef':
        return 'lib/assets/icons/flashsale.svg';
      default:
        return 'lib/assets/icons/default.svg';
    }
  }
}
