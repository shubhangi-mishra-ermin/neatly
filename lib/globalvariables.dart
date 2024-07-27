import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:meatly/screens/cart&checkout/widget/cartitem.dart';
import 'package:meatly/utilities/colors.dart';

RxBool isLoading = false.obs;
  List<CartItem> cartItems = [];

void showErrorMessage(BuildContext context, String message,
    {int durationInSeconds = 4}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: Duration(seconds: durationInSeconds),
    backgroundColor: const Color(0xffFFD5D6),
    padding: const EdgeInsets.all(25),
    content: Text(
      message,
      style: TextStyle(
        fontSize: 14,
        color: errorColor,
      ),
    ),
  ));
}

Future? nextPage(BuildContext context, Widget page) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
  // return Get.to(page, transition: Transition.rightToLeft);
}

// Future? nextPageFade(Widget page) {
//   return Get.to(page, transition: Transition.fade);
// }

void showSucessMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        padding: const EdgeInsets.all(25),
        // margin: const EdgeInsets.all(10),
        backgroundColor: const Color(0xffD1FFE1),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 14,
            color: sucessColor,
          ),
        )),
  );
}
