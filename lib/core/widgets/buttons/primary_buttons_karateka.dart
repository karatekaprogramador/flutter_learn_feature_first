import 'package:flutter/material.dart';

class PrimaryButtonsKarateka extends StatelessWidget {
  final Widget text;
  final VoidCallback onPressed;
  const PrimaryButtonsKarateka({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: text,
    );
  }
}