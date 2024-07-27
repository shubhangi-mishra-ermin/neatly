import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:meatly/Widget/itemcardhomepage.dart';
import 'package:meatly/Widget/progressHud.dart';
import 'package:meatly/globalvariables.dart';
import 'package:meatly/screens/Home/bannerpage/bannerpage.dart';
import 'package:meatly/screens/Home/tagscreens/Tagscreens.dart';
import 'package:meatly/screens/Home/tagscreens/foodcontroller.dart';
import 'package:meatly/screens/Map%20screens/Location.dart';
import 'package:meatly/Widget/customTag.dart';
import 'package:meatly/Widget/titlewidget.dart';
import 'package:meatly/utilities/colors.dart';
import 'package:meatly/utilities/constants.dart';
import 'package:meatly/utilities/textstyles.dart';
import '../Settings/Profile.dart';
import 'package:meatly/screens/productscreen/productdetailspage.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Stream<List<Map<String, dynamic>>> _besetsellerStream;

  @override
  void initState() {
    super.initState();
    _besetsellerStream = _fetchData();
  }

  int _current = 0;
  final List<String> imgList = [
    'https://firebasestorage.googleapis.com/v0/b/meatly-d190e.appspot.com/o/Banner%20images%2Fbanner2.png?alt=media&token=2befefd7-0036-43d5-8a94-c541d0a5fea6',
    'https://firebasestorage.googleapis.com/v0/b/meatly-d190e.appspot.com/o/Banner%20images%2Fbanner3.svg?alt=media&token=bea10b3a-9e48-4acf-a187-0aded1fb1c23',
  ];

  Stream<List<Map<String, dynamic>>> _fetchData() {
    return FirebaseFirestore.instance
        .collection('Best Sellers')
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.map((doc) {
              var data = doc.data() as Map<String, dynamic>;
              data['id'] = doc.id;
              return data;
            }).toList());
  }

  final FoodController _foodController = Get.put(FoodController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SafeArea(
        child: Scaffold(
          body: ProgressHUD(
            isLoading: isLoading.value,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Location()),
                                );
                              },
                              child: Row(
                                children: [
                                  Text(' Current Location',
                                      style: AppTextStyle.text),
                                  SizedBox(width: 3),
                                  Icon(Icons.keyboard_arrow_down, size: 22),
                                ],
                              ),
                            ),
                            SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(Icons.location_on_outlined,
                                    color: primaryColor, size: 24),
                                SizedBox(width: 2),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 50,
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Text(
                                      "1124, Parle court, New york, USA",
                                      style: AppTextStyle.textgrey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Profile()),
                            );
                          },
                          child: Image.asset('lib/assets/icons/profileicon.png',
                              height: 40),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                      child: Divider(color: Colors.grey),
                    ),
                    Text(
                      "Find by Category",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                        fontSize: 18,
                      ),
                    ),
                    _foodController.foodTags.isEmpty
                        ? Center(
                            child: CircularProgressIndicator(
                            color: primaryColor,
                          ))
                        :
                        // } else {
                        Padding(
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
                                          _foodController
                                              .fetchFoodItemsList(tag);

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
                                      child: Image.network(
                                        item,
                                        fit: BoxFit.cover,
                                        width:
                                            MediaQuery.of(context).size.width,
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
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
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
                    Text(
                      "Best Sellers",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                        fontSize: 20,
                      ),
                    ),
                    StreamBuilder<List<Map<String, dynamic>>>(
                      stream: _besetsellerStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: CircularProgressIndicator(
                            color: primaryColor,
                          ));
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
                              return GestureDetector(
                                onTap: () {
                                  List<Widget> recommendedItems =
                                      data.map((recItem) {
                                    return Row(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.2,
                                          child: ItemCard(
                                            id: recItem['id'],
                                            imageUrl: recItem['descImg'] ??
                                                "lib/assets/images/chicken1.png",
                                            title: recItem['product_name'] ??
                                                'No Name',
                                            weight:
                                                '${recItem['weight'] ?? 'No Weight'}',
                                            pieces:
                                                '${recItem['pieces'] ?? 'No Pieces'} pieces',
                                            deliveryTime:
                                                recItem['Delivery time'] ??
                                                    'No Delivery Time',
                                            price: recItem['price'] ?? 0.0,
                                            
                                          ),
                                        ),
                                        2.pw,
                                      ],
                                    );
                                  }).toList();
                                  nextPage(
                                    context,
                                    ProductDescription(
                                      weight:
                                          '${item['weight'] ?? 'No Weight'}',
                                      id: item['id'],
                                      productTitle:
                                          item['product_name'] ?? 'No Name',
                                      productImage:
                                          item['descImg'] ?? 'No Name',
                                      deliveryTime: item['Delivery time'] ??
                                          'No Delivery Time',
                                      productDescription: item['description'] ??
                                          'No product description',
                                      productInfo: [
                                        {
                                          'icon': 'scale',
                                          'text':
                                              '${item['weight'] ?? 'No Weight'}'
                                        },
                                        {
                                          'icon': 'pie_chart',
                                          'text':
                                              '${item['pieces'] ?? 'No Pieces'} pieces'
                                        },
                                        {
                                          'icon': 'group',
                                          'text':
                                              'Serves ${item['serves'] ?? '0'}'
                                        },
                                      ],
                                      recommendedItems: recommendedItems,
                                      price: item['price'] ?? 0.0,
                                    ),
                                  );
                                },
                                child: ItemCard(
                                  id: item['id'],
                                  imageUrl: item['imageUrl']??'',
                                  title: item['product_name'] ?? 'No Name',
                                  weight: '${item['weight'] ?? 'No Weight'}',
                                  pieces:
                                      '${item['pieces'] ?? 'No Pieces'} pieces',
                                  deliveryTime: item['Delivery time'] ??
                                      'No Delivery Time',
                                  price: item['price'] ?? 0.0,
                                ),
                              );
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
    });
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
