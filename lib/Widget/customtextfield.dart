import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType inputType;
  final bool obscureText;
  final bool enable;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String obscuringCharacter;
  final int maxCharacters;
  final int maxLines;
  final bool counter;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final String? errorText; 

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hint,
    this.inputType = TextInputType.text,
    this.obscureText = false,
    this.enable = true,
    this.prefixIcon,
    this.suffixIcon,
    this.obscuringCharacter = '•',
    this.maxCharacters = 1000,
    this.maxLines = 1,
    this.counter = false,
    this.validator,
    this.onChanged,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          keyboardType: inputType,
          obscureText: obscureText,
          enabled: enable,
          maxLines: maxLines,
          maxLength: counter ? maxCharacters : null,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
          validator: validator,
        ),
        if (errorText != null) 
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              errorText!,
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
