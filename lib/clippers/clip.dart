import 'package:flutter/material.dart';

class SemiCircleClipper extends CustomClipper<Path> {
  const SemiCircleClipper({
    this.direction = 1,
  });

  /// Displays the vertical direction of clipping.
  ///
  /// Positive value means top and negative is for bottom.
  final int direction;

  @override
  Path getClip(Size size) {
    final path = Path();
    if (this.direction != 0) {
      final double height = this.direction > 0 ? 0.0 : size.height;
      path.moveTo(0.0, height);
      path.lineTo(size.width, height);
      path.lineTo(size.width, size.height / 2);
      path.lineTo(0.0, size.height / 2);
      path.close();
    }
    return path;
  }

  @override
  bool shouldReclip(SemiCircleClipper oldClipper) => false;
}
