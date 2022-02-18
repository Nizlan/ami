import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActivityArc extends CustomPainter {
  final double startActivity;
  final double endActivity;
  final Color color;
  final double rotation;
  const ActivityArc(
      this.startActivity, this.endActivity, this.color, this.rotation);
  @override
  void paint(Canvas canvas, Size size) {
    final activityPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30.0;
    var time = DateFormat('HH:mm').format(DateTime.now()).split(':');
    var angle = int.parse(time[0]) / 24 + int.parse(time[1]) / 60 / 24;
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var shift = angle * pi * 2;
    var center = Offset(centerX, centerY);
    var radius = min(centerX, centerY) * 0.72;
    final rotationStart = startActivity + rotation;
    final rotationEnd = endActivity + rotation;
    endActivity == 2
        ? canvas.drawArc(
            new Rect.fromCenter(
                center: center, width: radius * 2, height: radius * 2),
            (rotationStart * 2 * pi - pi / 2) - shift,
            ((2 * pi * (0.01)) < 0)
                ? (2 * pi * (0.01) + pi * 2)
                : (2 * pi * (0.01)),
            false,
            activityPaint)
        : canvas.drawArc(
            new Rect.fromCenter(
                center: center, width: radius * 2, height: radius * 2),
            (rotationStart * 2 * pi - pi / 2) - shift,
            ((2 * pi * (rotationEnd - rotationStart)) < 0)
                ? (2 * pi * (rotationEnd - rotationStart) + pi * 2)
                : (2 * pi * (rotationEnd - rotationStart)),
            false,
            activityPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
