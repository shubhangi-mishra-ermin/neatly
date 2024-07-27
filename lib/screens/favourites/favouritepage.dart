import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meatly/Widget/itemcardhomepage.dart';
import 'package:meatly/Widget/titlewidget.dart';
import 'package:meatly/main.dart';
import 'package:meatly/utilities/colors.dart';
import 'package:meatly/utilities/textstyles.dart';

class Favourites extends StatefulWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  late Stream<List<Map<String, dynamic>>> _favouritesStream;

  @override
  void initState() {
    super.initState();
    _favouritesStream = _fetchFavourites();
  }

  Stream<List<Map<String, dynamic>>> _fetchFavourites() {
    String userId = currentUserCredential;
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Favourites')
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.map((doc) {
              var data = doc.data() as Map<String, dynamic>;
              data['id'] = doc.id;
              return data;
            }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleCard(
                title: "Favorites",
                showBackButton: false,
              ),
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: _favouritesStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                        child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height / 8),
                      child: Text(
                        "No favorites available",
                        style: AppTextStyle.textSemibold20
                            .copyWith(color: primaryColor, fontSize: 16),
                      ),
                    ));
                  } else {
                    final favourites = snapshot.data!;
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: favourites.length,
                      itemBuilder: (context, index) {
                        final item = favourites[index];
                        return ItemCard(
                          isFav: true,
                          id: item['id'],
                          imageUrl: item['imageUrl'] ??
                              'lib/assets/images/chicken1.png',
                          title: item['product_name'] ?? 'No Name',
                          weight: '${item['weight'] ?? 'No Weight'}',
                          pieces: '${item['pieces'] ?? 'No Pieces'} pieces',
                          deliveryTime:
                              item['delivery_time'] ?? 'No Delivery Time',
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
    );
  }
}
