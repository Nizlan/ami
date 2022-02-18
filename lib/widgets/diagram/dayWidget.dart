import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DayWidget extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    var radius = min(centerX, centerY) * 0.72;
    var triangleVar = radius / 120;
    final circlePaint = Paint()
      ..color = Color.fromRGBO(0, 188, 180, 1.0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30.0;
    final trianglePaint = Paint()
      ..color = Color.fromRGBO(233, 118, 91, 1.0)
      ..style = PaintingStyle.fill
      ..strokeWidth = 30.0;
    Path getTrianglePath(double x, double y) {
      return Path()
        ..moveTo(centerX * 0.95, y * triangleVar / 4)
        ..lineTo(centerX, y * triangleVar / 5)
        ..lineTo(centerX * 1.05, y * triangleVar / 4)
        ..lineTo(0, y * triangleVar / 4);
    }

    canvas.drawCircle(center, radius, circlePaint);
    canvas.drawPath(getTrianglePath(size.width, size.height), trianglePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
