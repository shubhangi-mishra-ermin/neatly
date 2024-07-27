import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customizable_counter/customizable_counter.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:meatly/globalvariables.dart';
import 'package:meatly/main.dart';
import 'package:meatly/screens/Home/tagscreens/Tagscreens.dart';
import 'package:meatly/screens/Home/tagscreens/foodcontroller.dart';
import 'package:meatly/screens/Map%20screens/Location.dart';
import 'package:meatly/Widget/customTag.dart';
import 'package:meatly/Widget/itemcardhomepage.dart';
import 'package:meatly/Widget/searchbar.dart';
import 'package:meatly/Widget/searchcard.dart';
import 'package:meatly/Widget/titlewidget.dart';
import 'package:meatly/utilities/colors.dart';
import 'package:meatly/utilities/textstyles.dart';

import '../Settings/Profile.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late Stream<List<Map<String, dynamic>>> _recentSearchStream;

  @override
  void initState() {
    super.initState();
    _recentSearchStream = _fetchFavourites();
  }

  Stream<List<Map<String, dynamic>>> _fetchFavourites() {
    String userId = currentUserCredential;
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Recent Searches')
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList());
  }
  final FoodController _foodController = Get.put(FoodController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleCard(
                  title: "Search",
                  showBackButton: false,
                ),
                SizedBox(
                  height: 20,
                ),
                CustomSearchBar(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Text(
                    "Shop by Category",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                      fontSize: 18,
                    ),
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
                     Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 15),
                  child: Divider(
                    color: Colors.grey,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 10, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Recent searches",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "Delete",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _recentSearchStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height / 8),
                        child: Center(
                            child: Text(
                          "No recent searches available",
                          style: AppTextStyle.textSemibold20
                              .copyWith(color: primaryColor, fontSize: 16),
                        )),
                      );
                    } else {
                      final favourites = snapshot.data!;
                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: favourites.length,
                        itemBuilder: (context, index) {
                          final item = favourites[index];
                          return CustomSearchCard(
                            imageUrl: "lib/assets/images/chicken1.png",
                            title: item['product_name'] ?? 'No Title',
                            description: item['weight'] ?? 'Unavailabe',
                            price: item['price'] ?? 0.0,
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
