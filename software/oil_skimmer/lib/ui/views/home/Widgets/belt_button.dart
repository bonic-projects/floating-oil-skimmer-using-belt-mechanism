import 'package:flutter/material.dart';

class BeltButton extends StatelessWidget {
  final void Function() ontap;
  final String text;
  final String buttonName;
  final IconData icon;

  const BeltButton({
    Key? key,
    required this.ontap,
    required this.text,
    required this.buttonName,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(),
      onPressed: ontap,
      icon: Icon(icon),
      label: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            buttonName,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
