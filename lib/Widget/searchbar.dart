import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meatly/utilities/textstyles.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final void Function(String)? onTextChanged;

  const CustomSearchBar({
    Key? key,
    this.controller,
    this.hintText = 'Search any product',
    this.onTextChanged,
  }) : super(key: key);

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = widget.controller ?? TextEditingController();
  }

  // @override
  // void dispose() {
  //   _textEditingController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.white,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 2.0,
              offset: Offset(0.0, 0.0),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                size: 24,
                color: Colors.black54,
              ),
              SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    hintStyle: AppTextStyle.hintText,
                    hintText: widget.hintText,
                    border: InputBorder.none,
                  ),
                  onChanged: (text) {
                    if (widget.onTextChanged != null) {
                      widget.onTextChanged!(text);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
