import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:meatly/Widget/custombutton.dart';
import 'package:meatly/Widget/textfield.dart';
import 'package:meatly/Widget/titlewidget.dart';
import 'package:meatly/globalvariables.dart';
import 'package:meatly/main.dart';
import 'package:meatly/screens/Settings/widget/carddetails.dart';
import 'package:meatly/screens/order&tracking/trackingpage.dart';
import 'package:meatly/utilities/colors.dart';
import 'package:meatly/utilities/constants.dart';
import 'package:meatly/utilities/textstyles.dart';

class PaymentMethods extends StatefulWidget {
  const PaymentMethods({Key? key}) : super(key: key);

  @override
  _PaymentMethodsState createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  int selectedPaymentMethodIndex = 2;
  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _cardnumbercontroller = TextEditingController();
  TextEditingController _expiredateController = TextEditingController();
  TextEditingController _cvvController = TextEditingController();
  bool card = false;
  List<Map<String, String>> cards = [];
  int? selectedCardIndex;
  @override
  void initState() {
    _fetchPaymentMethods();
    super.initState();
  }

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Users');
  final String userId = currentUserCredential;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleCard(
                title: "Payment Methods",
                onBack: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 10),
              Text(
                'Credit/Debit cards',
                style: AppTextStyle.text,
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {
                    showBottomDrawer(context);
                  },
                  icon: Icon(Icons.add, color: primaryColor),
                  label: Text('Add new', style: TextStyle(color: primaryColor)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: lightGreyColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80),
                    ),
                  ),
                ),
              ),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : cards.isEmpty
                      ? Center(child: Text('No payment methods found'))
                      : Expanded(
                          child: ListView.builder(
                            itemCount: cards.length,
                            itemBuilder: (context, index) {
                              return CardDetailsCard(
                                current: true,
                                suffixIcon: Icons.more_vert,
                                title: cards[index]['cardNumber']!,
                                expiredate:
                                    'Expire Date\n${cards[index]['expiryDate']}',
                              );
                            },
                          ),
                        ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // final List<Map<String, String>> cards = [
  //   {
  //     'cardNumber': '**** **** **** 1234',
  //     'expiryDate': '12/24',
  //   },
  //   {
  //     'cardNumber': '**** **** **** 5678',
  //     'expiryDate': '11/23',
  //   },
  // ];

  // int? selectedCardIndex;

  Future<void> _fetchPaymentMethods() async {
    setState(() {
      isLoading = true;
    });
    try {
      final snapshot =
          await usersCollection.doc(userId).collection('Payment Methods').get();

      if (snapshot.docs.isEmpty) {
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          cards = snapshot.docs.map((doc) {
            String expiryDate = doc['expiryDate'];
            DateTime date = DateFormat('MM/yyyy').parse(expiryDate);
            String formattedDate = DateFormat('MM/yy').format(date);

            return {
              'cardNumber':
                  '**** **** **** ${doc['cardNumber'].substring(doc['cardNumber'].length - 4)}',
              'expiryDate': formattedDate,
            };
          }).toList();
          isLoading = false;
        });
      }
    } catch (e) {
      showErrorMessage(context, "Failed to fetch payment methods: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Widget _buildCardDetails() {
  //   return Column(
  //     children: cards.map((card) {
  //       int index = cards.indexOf(card);
  //       return Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 8.0),
  //         child: Container(
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(12),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.grey.withOpacity(0.5),
  //                 spreadRadius: 1,
  //                 blurRadius: 2,
  //               ),
  //             ],
  //           ),
  //           child: Padding(
  //             padding:
  //                 const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 RadioListTile(
  //                   contentPadding: EdgeInsets.zero,
  //                   splashRadius: 20,
  //                   activeColor: primaryColor,
  //                   value: index,
  //                   groupValue: selectedCardIndex,
  //                   onChanged: (int? value) {
  //                     setState(() {
  //                       selectedCardIndex = value;
  //                     });
  //                   },
  //                   title: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Text(
  //                         card['cardNumber']!,
  //                         style: AppTextStyle.textSemibold20.copyWith(
  //                             color: primaryColor,
  //                             fontWeight: selectedCardIndex == index
  //                                 ? FontWeight.w700
  //                                 : FontWeight.w400),
  //                       ),
  //                       Icon(Icons.expand_more_outlined)
  //                     ],
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.only(left: 40.0, right: 20),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(
  //                             'Expire Date',
  //                             style: AppTextStyle.textGreyMedium12,
  //                           ),
  //                           Text(
  //                             '${card['expiryDate']}',
  //                             style: AppTextStyle.textGreyMedium12,
  //                           ),
  //                         ],
  //                       ),
  //                       SvgPicture.asset('lib/assets/icons/mastercard_logo.svg')
  //                     ],
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     }).toList(),
  //   );
  // }

  Widget _buildPaymentMethod(String name, String icon, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethodIndex = index;
        });
      },
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: selectedPaymentMethodIndex == index
                        ? primaryColor
                        : Colors.grey,
                    width: 2,
                  ),
                ),
                child: SvgPicture.asset(
                  icon,
                  height: 25,
                  width: 25,
                ),
              ),
              Positioned(
                  top: 0,
                  right: 0,
                  child: Icon(
                    Icons.check_circle_sharp,
                    color: selectedPaymentMethodIndex == index
                        ? primaryColor
                        : Colors.transparent,
                  ))
            ],
          ),
          SizedBox(height: 5),
          Text(name,
              style: AppTextStyle.textGreySemi12.copyWith(
                  color: selectedPaymentMethodIndex == index
                      ? primaryColor
                      : null)),
        ],
      ),
    );
  }

  Widget _buildNoCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('lib/assets/images/mastercard.svg'),
          SizedBox(height: 10),
          Text(
            'No mastercard added',
            style: AppTextStyle.textSemibold20,
          ),
          SizedBox(height: 5),
          Text(
            'You can add a mastercard and save it for later',
            textAlign: TextAlign.center,
            style: AppTextStyle.hintText,
          ),
        ],
      ),
    );
  }

  void showBottomDrawer(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => Container(
        color: Colors.white,
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                height: 5,
                width: screenWidth * 0.15,
                decoration: BoxDecoration(
                  color: Color(0xffC4C4C4),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Center(
              child: Text(
                'Add Card',
                style: AppTextStyle.textSemibold20,
              ),
            ),
            // SizedBox(height: 5),
            SizedBox(height: screenHeight * 0.02),
            Text("Card Holder Name", style: AppTextStyle.labelText),
            SizedBox(height: 5),
            TextFeildStyle(
              hintText: 'Shubhangi Mishra',
              textAlignVertical: TextAlignVertical.center,
              controller: _namecontroller,
              height: 50,
              onChanged: (value) {
                setState(() {});
              },
              border: InputBorder.none,
            ),
            SizedBox(height: screenHeight * 0.02),
            Text("Card Number", style: AppTextStyle.labelText),
            SizedBox(height: 5),
            TextFeildStyle(
              hintText: '2134   _ _ _ _   _ _ _ _   0969',

              // validation: FormValidators.validateFirstName,
              textAlignVertical: TextAlignVertical.center,
              controller: _cardnumbercontroller,
              height: 50,
              onChanged: (value) {
                setState(() {});
              },
              border: InputBorder.none,
            ),
            SizedBox(height: screenHeight * 0.02),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Expire Date", style: AppTextStyle.labelText),
                      SizedBox(height: 10),
                      TextFeildStyle(
                        hintText: '09/28',
                        // validation: FormValidators.validateFirstName,
                        textAlignVertical: TextAlignVertical.center,
                        controller: _expiredateController,
                        height: 50,
                        onChanged: (value) {
                          setState(() {});
                        },
                        border: InputBorder.none,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: screenWidth * 0.05),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("CVV", style: AppTextStyle.labelText),
                      SizedBox(height: 10),
                      TextFeildStyle(
                        hintText: '●●●',
                        // validation: FormValidators.validateFirstName,
                        textAlignVertical: TextAlignVertical.center,
                        controller: _cvvController,
                        height: 50,
                        onChanged: (value) {
                          setState(() {});
                        },
                        border: InputBorder.none,
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: screenHeight * 0.03),
            isLoading
                ? CircularProgressIndicator(
                    color: primaryColor,
                  )
                : CustomButton(
                    text: "Add Card",
                    onPressed: () async {
                      if (_namecontroller.text.isEmpty ||
                          _cardnumbercontroller.text.isEmpty ||
                          _expiredateController.text.isEmpty ||
                          _cvvController.text.isEmpty) {
                        showErrorMessage(context, "All fields are required.");
                        return;
                      }

                      try {
                        final snapshot = await usersCollection
                            .doc(userId)
                            .collection('Payment Methods')
                            .get();

                        if (snapshot.docs.isEmpty) {
                          await usersCollection
                              .doc(userId)
                              .collection('Payment Methods')
                              .add({
                            'cardNumber': _cardnumbercontroller.text,
                            'expiryDate': _expiredateController.text,
                            'cvv': _cvvController.text,
                            'cardholderName': _namecontroller.text,
                          });
                        } else {
                          await usersCollection
                              .doc(userId)
                              .collection('Payment Methods')
                              .add({
                            'cardNumber': _cardnumbercontroller.text,
                            'expiryDate': _expiredateController.text,
                            'cvv': _cvvController.text,
                            'cardholderName': _namecontroller.text,
                          });
                        }

                        _namecontroller.clear();
                        _cardnumbercontroller.clear();
                        _expiredateController.clear();
                        _cvvController.clear();

                        Navigator.pop(context);
                        _fetchPaymentMethods();
                        setState(() {
                          card = true;
                        });

                        showSucessMessage(context, "Card added successfully.");
                      } catch (e) {
                        showErrorMessage(context, "Failed to add card: $e");
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

class SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'lib/assets/images/success.png',
            height: screenHeight * 0.17,
          ),
          SizedBox(height: screenHeight * 0.02),
          Text('Order placed', style: AppTextStyle.pageHeadingSemiBold),
          SizedBox(height: screenHeight * 0.01),
          Text('Your order has been placed, Please enjoy our service !',
              textAlign: TextAlign.center, style: AppTextStyle.hintText),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          ),
          height: MediaQuery.of(context).size.height / 13,
          width: MediaQuery.of(context).size.width * 0.97,
          child: CustomButton(
              text: 'Track your order',
              onPressed: () {
                nextPage(context, TrackingPage());
              })),
    );
  }
}
