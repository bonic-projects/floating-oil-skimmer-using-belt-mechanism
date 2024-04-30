import 'package:flutter/material.dart';

class StopButton extends StatelessWidget {
  final void Function() onTap;
  const StopButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        color: Colors.red[900],
        child: const Center(
          child: Text(
            "Stop",
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
        ),
      ),
    );
  }
}
