import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthTextFormField extends StatelessWidget {
  final ValueKey formKey;
  final String decorationLabel;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obsecure;
  final TextEditingController controller;

  const AuthTextFormField({super.key,
    required this.formKey,
    required this.decorationLabel,
    required this.validator,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obsecure = false
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      key: formKey,
      controller: controller,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
          labelText: decorationLabel,
          labelStyle: theme.textTheme.bodyMedium
      ),
      keyboardType: keyboardType,
      validator: validator,
      obscureText: obsecure,
    );
  }
}