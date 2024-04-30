import 'package:flutter/material.dart';

class BeltButton extends StatelessWidget {
  final void Function() ontap;
  final String text;
  const BeltButton({super.key, required this.ontap, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        text,
        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
      ),
      onPressed: ontap,
    );
  }
}
