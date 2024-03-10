import 'package:daprot_v1/config/theme/colors_manager.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required TextEditingController controller,
    required this.inputTextSize,
    required this.label,
  }) : _nameController = controller;

  final TextEditingController _nameController;
  final double inputTextSize;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _nameController,
      style: TextStyle(fontSize: inputTextSize),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        floatingLabelStyle: const TextStyle(
          color: ColorsManager.accentColor,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorsManager.primaryColor,
          ),
        ),
      ),
    );
  }
}
