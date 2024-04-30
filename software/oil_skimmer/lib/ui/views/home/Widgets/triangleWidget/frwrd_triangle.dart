import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ForwardTriangle extends StatelessWidget {
  // final Icon icon;
  final void Function() onTap;
  const ForwardTriangle({
    super.key,
    required this.onTap,
    // required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      child: Stack(
        children: [
          ClipPath(
            clipper: _Triangle(),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black), color: Colors.black),
              width: 50,
              height: 50,
              //child: Center(child: icon),
            ),
          ),
          //  Positioned(
          //     left: 23,
          //     top: 58,
          //     child: Text(
          //       direction,
          //       style: const TextStyle(color: Colors.black),
          //     ))
        ],
      ),
    );
  }
}

class _Triangle extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
