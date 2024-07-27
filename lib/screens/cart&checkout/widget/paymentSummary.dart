import 'package:flutter/material.dart';
import 'package:meatly/utilities/colors.dart';
import 'package:meatly/utilities/textstyles.dart';

class PaymentSummaryCard extends StatefulWidget {
  final double deliveryCharges;
  final double itemTotal;
  final double taxes;
  final double total;

  const PaymentSummaryCard(
      {Key? key,
      required this.itemTotal,
      required this.deliveryCharges,
      required this.taxes,
      required this.total})
      : super(key: key);

  @override
  _PaymentSummaryCardState createState() => _PaymentSummaryCardState();
}

class _PaymentSummaryCardState extends State<PaymentSummaryCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.white,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 2.0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildRow("Total Items (2)", "\$${widget.itemTotal}"),
            _buildRow("Delivery", "${widget.deliveryCharges}"),
            _buildRow("Taxes", "\$${widget.taxes}"),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: AppTextStyle.priceText,
                ),
                Text(
                  '\$${widget.total + widget.taxes + widget.deliveryCharges}',
                  style: AppTextStyle.priceText,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRow(
    String leftText,
    String rightText,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          leftText,
          style: AppTextStyle.hintText.copyWith(fontWeight: FontWeight.w500),
        ),
        Text(
          rightText,
          style: AppTextStyle.labelText,
        ),
      ],
    );
  }
}
