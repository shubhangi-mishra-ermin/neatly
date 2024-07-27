import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:meatly/Auth/login_signup.dart';
import 'package:meatly/Widget/confirmationtext.dart';
import 'package:meatly/Widget/progressHud.dart';
import 'package:meatly/api/localstorage.dart';
import 'package:meatly/globalvariables.dart';
import 'package:meatly/main.dart';
import 'package:meatly/screens/Map%20screens/Location.dart';
import 'package:meatly/screens/Payment/paymentscreen.dart';
import 'package:meatly/screens/Settings/aboupage.dart';
import 'package:meatly/screens/Settings/allorderscreen.dart';
import 'package:meatly/screens/Settings/api.dart';
import 'package:meatly/screens/Settings/manageprofile.dart';
import 'package:meatly/screens/Settings/paymentmethods.dart';
import 'package:meatly/screens/Settings/settings.dart';
import 'package:meatly/screens/Settings/widget/ordercart.dart';
import 'package:meatly/screens/Settings/widget/settingspage.dart';
import 'package:meatly/Widget/titlewidget.dart';
import 'package:meatly/utilities/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meatly/utilities/constants.dart';
import 'package:meatly/utilities/textstyles.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _auth = FirebaseAuth.instance;
  User? _loggedInUser;
  String _displayName = '';
  String _email = '';
  String profilepic = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    ProfileApi.fetchCurrentOrders();
  }

  void _getCurrentUser() {
    final user = _auth.currentUser;
    print("user :: $user");
    if (user != null) {
      setState(() {
        _loggedInUser = user;
      });
      _fetchUserData();
    }
  }

  void _fetchUserData() async {
    try {
      setState(() {
        _isLoading = true;
      });
      String userId = currentUserCredential;

      print("userId :: $userId");
      print("_loggedInUser!.uid :: ${_loggedInUser!.uid}");
      final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(userId)
              .get();

      if (userSnapshot.exists) {
        setState(() {
          _displayName =
              '${userSnapshot.get('first name')} ${userSnapshot.get('last name')}';
          _email = userSnapshot.get('email');
          profilepic = userSnapshot.get('profile pic url');
        });
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      isLoading: _isLoading,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
            child: Column(
              children: [
                TitleCard(
                  title: "Profile",
                  onBack: () {
                    Navigator.pop(context);
                  },
                  sizeWidget: Text(
                    "Need help?",
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1,
                      fontSize: 14,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: profilepic.isNotEmpty
                            ? NetworkImage(profilepic)
                            : null,
                        child: profilepic.isEmpty
                            ? Icon(Icons.person, size: 50)
                            : null,
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _displayName,
                              style: AppTextStyle.textSemibold20,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child: Text(
                                _email,
                                style: AppTextStyle.textgrey
                                    .copyWith(fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 24,
                      ),
                    ],
                  ),
                ),
                Divider(thickness: 1),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "My orders",
                        style: AppTextStyle.text,
                      ),
                      GestureDetector(
                        onTap: () {
                          nextPage(context, MyOrdersScreen());
                        },
                        child: Text(
                          "See All",
                          style: AppTextStyle.labelText
                              .copyWith(color: primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: ProfileApi.fetchCurrentOrders(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        print('Error in stream: ${snapshot.error}');
                        return Center(child: Text('Something went wrong'));
                      }

                      if (snapshot.data == null || snapshot.data!.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'No orders in delivery',
                              style: AppTextStyle.textSemibold20
                                  .copyWith(color: primaryColor, fontSize: 16),
                            ),
                          ),
                        );
                      }

                      return ListView(
                        children: snapshot.data!.map((order) {
                          print("order profile page:: $order");

                          String orderId = order['order_id'].toString();
                          String status = order['status'];
                          String dateTime =
                              (order['time'] as Timestamp).toDate().toString();
                          String totalPrice = order['total_price'].toString();

                          return MyOrder(
                            isCurrentOrder: true,
                            orderId: orderId,
                            status: status,
                            dateTime: dateTime,
                            totalPrice: totalPrice,
                            items: ProfileApi.convertProductDetails(
                              List<Map<String, dynamic>>.from(
                                  order['product_details']),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
                Divider(thickness: 1),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 60,
                ),
                SettingPageOptions(
                  icon: Icons.person_outline_rounded,
                  text: "Manage profile",
                  onPressed: () {
                    nextPage(context, ManageProfile());
                    print('Manage profile pressed');
                  },
                ),
                SettingPageOptions(
                  icon: Icons.map_rounded,
                  text: "Address book",
                  onPressed: () {
                    nextPage(
                        context,
                        Location(
                          isAddressbook: true,
                        ));
                    print('Address book pressed');
                  },
                ),
                SettingPageOptions(
                  icon: Icons.payment_rounded,
                  text: "Payment methods",
                  onPressed: () {
                    nextPage(context, PaymentMethods());
                    print('Payment methods pressed');
                  },
                ),
                SettingPageOptions(
                  icon: Icons.settings_outlined,
                  text: "Settings",
                  onPressed: () {
                    nextPage(context, SettingsPage());
                    print('Settimns pressed');
                  },
                ),
                SettingPageOptions(
                  icon: Icons.info_outline_rounded,
                  text: "About",
                  onPressed: () {
                    nextPage(context, AboutPage());
                    print('About pressed');
                  },
                ),
                SettingPageOptions(
                  icon: Icons.delete_rounded,
                  text: "Delete account",
                  onPressed: () {
                    print('delete account pressed');
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomConfirmationDialog(
                          title: 'Confirm Delete',
                          message: 'Are you sure to delete this account?',
                          cancelText: 'cancel',
                          confirmText: 'confirm',
                          onCancelPressed: () {
                            Navigator.pop(context);
                          },
                          onConfirmPressed: () {
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  },
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _auth.signOut();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => LoginSignup()),
                          (Route<dynamic> route) => false);
                    },
                    icon: Icon(Icons.logout_rounded, color: primaryColor),
                    label:
                        Text('Sign Out', style: TextStyle(color: primaryColor)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: lightGreyColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
