import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meatly/Widget/searchbar.dart';
import 'package:meatly/Widget/titlewidget.dart';
import 'package:meatly/globalvariables.dart';
import 'package:meatly/main.dart';
import 'package:meatly/screens/Map%20screens/MapScreen.dart';
import 'package:meatly/screens/Map%20screens/widget/addresscard.dart';
import 'package:meatly/utilities/textstyles.dart';
import '../../utilities/colors.dart';

class Location extends StatefulWidget {
  final bool isAddressbook;
  final bool selectAddress;
  final String cartId;
  const Location(
      {Key? key,
      this.isAddressbook = false,
      this.selectAddress = false,
      this.cartId = ''})
      : super(key: key);

  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  late Stream<List<Map<String, dynamic>>> _locatonStream;
  Map<String, dynamic>? _selectedAddress;

  Future<void> _updateAddressInFirestore(
      String cartId, Map<String, dynamic> address) async {
    String userId = currentUserCredential;
    print('Updating address for userId: $userId and cartId: $cartId');
    
    if (cartId.isEmpty || userId.isEmpty) {
      showErrorMessage(context, 'Cart ID or User ID is missing.');
      return;
    }

    try {
      print('Address to update: ${address['address line 1']} ${address['address line 2']}');
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Cart')
          .doc(cartId)
          .update({
        'address': '${address['address line 1']} ${address['address line 2']}',
      });
      showSucessMessage(context, 'Address updated successfully!');
    } catch (e) {
      print('Error updating address: $e');
      showErrorMessage(context, 'Error updating address: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _locatonStream = _fetchLocation();
  }

  Stream<List<Map<String, dynamic>>> _fetchLocation() {
    String userId = currentUserCredential;
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Locations')
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleCard(
                  title: widget.isAddressbook ? "Address Book" : "Location",
                  onBack: () {
                    Navigator.pop(context, _selectedAddress);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                CustomSearchBar(
                  hintText: "Search for area, street..",
                ),
                SizedBox(
                  height: 20,
                ),
                if (!widget.isAddressbook)
                  CustomAddressCard(
                    current: true,
                    title: "Current location",
                    address:
                        "132 Fair Grounds Road west Kingston, United states.",
                    prefixIcon: Icons.my_location,
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        nextPage(context, MapScreen());
                      },
                      icon: Icon(Icons.add, color: primaryColor),
                      label: Text('Add Address',
                          style: TextStyle(color: primaryColor)),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: lightGreyColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80),
                        ),
                      ),
                    ),
                  ),
                ),
                Text("Saved addresses", style: AppTextStyle.text),
                SizedBox(height: 18),
                StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _locatonStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text("No address available"));
                    } else {
                      final locations = snapshot.data!;
                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: locations.length,
                        itemBuilder: (context, index) {
                          final item = locations[index];
                          return GestureDetector(
                            onTap: () async {
                              print("Tapped address: $item");
                              await _updateAddressInFirestore(widget.cartId, item);
                              setState(() {});
                              Navigator.pop(context);
                            },
                            child: CustomAddressCard(
                              title: item['label'],
                              address:
                                  '${item['address line 1']} ${item['address line 2']}',
                              prefixIcon: Icons.location_on_outlined,
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
    );
  }
}
