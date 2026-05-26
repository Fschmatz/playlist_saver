import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool required;
  final int maxLines;
  final int maxLength;
  final bool fieldValidator;
  final String errorMsg;
  final bool autofocus;
  final Function(String)? onSubmitted;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.required,
    required this.maxLines,
    required this.maxLength,
    required this.fieldValidator,
    required this.errorMsg,
    this.autofocus = false,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: TextField(
        autofocus: autofocus,
        minLines: 1,
        maxLines: maxLines,
        maxLength: maxLength,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        textCapitalization: TextCapitalization.sentences,
        keyboardType: TextInputType.text,
        controller: controller,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          helperText: required ? "* Required" : "",
          labelText: label,
          counterText: "",
          border: const OutlineInputBorder(),
          errorText: fieldValidator ? null : errorMsg,
        ),
      ),
    );
  }
}
