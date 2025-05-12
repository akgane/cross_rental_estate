import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthElevatedButton extends StatelessWidget {
  final String text;
  final ThemeData theme;
  final void Function() onPressed;

  const AuthElevatedButton({super.key,
    required this.text,
    required this.theme,
    required this.onPressed});

  @override
  Widget build(BuildContext context) {

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
