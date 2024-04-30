import 'package:flutter/material.dart';

class DownwardTriangle extends StatelessWidget {
  final void Function() onTap;
//  final Icon icon;
  const DownwardTriangle({super.key, required this.onTap, });

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
              // child: Center(
              //   child: icon,
              // ),
            ),
          ),
          //  Positioned(
          //     left: 20,
          //     top: 15,
          //     // child: Text(
          //     //   direction,
          //     //   style: const TextStyle(color: Colors.black),
          //     // ),
          //     )
        ],
      ),
    );
  }
}

class _Triangle extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
