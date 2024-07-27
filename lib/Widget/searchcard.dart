import 'package:flutter/material.dart';
import 'package:meatly/utilities/colors.dart';
import 'package:meatly/utilities/textstyles.dart';

class CustomSearchCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final double price;

  const CustomSearchCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align content to the top
            children: [
              Container(
                width: MediaQuery.of(context).size.width *
                    0.3, // Adjust width proportionally
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.white,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 0.0,
                      offset: Offset(0.0, 0.0),
                    ),
                  ],
                ),
                child: AspectRatio(
                  aspectRatio: 1, // Maintain aspect ratio for the image
                  child: Image.asset(
                    imageUrl,
                    fit: BoxFit.cover, // Cover the container
                  ),
                ),
              ),
              SizedBox(width: 10), // Add spacing between image and text
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        title,
                        style: AppTextStyle.text,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      Text(
                        description,
                        style: AppTextStyle.textgrey.copyWith(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      Text(
                        "\$${price}",
                        style: AppTextStyle.priceText,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: Color(0xffBDBDBD),
          ),
        ],
      ),
    );
  }
}
