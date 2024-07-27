import 'package:flutter/material.dart';
import 'package:meatly/utilities/colors.dart';

class CustomTogglebar extends StatefulWidget {
  final bool mobileSelect;
  final Function(bool) onToggle;

  const CustomTogglebar({
    Key? key,
    required this.mobileSelect,
    required this.onToggle,
  }) : super(key: key);

  @override
  _CustomTogglebarState createState() => _CustomTogglebarState();
}

class _CustomTogglebarState extends State<CustomTogglebar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 16,
      decoration: BoxDecoration(
        color: const Color(0xffF0D3D6),
        border: Border.all(
          color: const Color(0xffF0D3D6),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 0.0,
            offset: Offset(0.0, 0.0),
          )
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildToggleButton(
                context: context,
                text: "Phone number",
                isSelected: widget.mobileSelect,
                onTap: () {
                  if (!widget.mobileSelect) {
                    widget.onToggle(true);
                  }
                },
                width: constraints.maxWidth / 2.1,
              ),
              _buildToggleButton(
                context: context,
                text: "Email",
                isSelected: !widget.mobileSelect,
                onTap: () {
                  if (widget.mobileSelect) {
                    widget.onToggle(false);
                  }
                },
                width: constraints.maxWidth / 2.1,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildToggleButton({
    required BuildContext context,
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
    required double width,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
        child: Container(
          height: MediaQuery.of(context).size.height / 19,
          width: width,
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : const Color(0xffF0D3D6),
            border: Border.all(
              color: isSelected ? primaryColor : const Color(0xffF0D3D6),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 0.0,
                offset: Offset(0.0, 0.0),
              )
            ],
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                color: isSelected ? Colors.white : Colors.black,
                letterSpacing: 1,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
