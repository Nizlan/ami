import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Midnight extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var _centerX = size.width / 2;
    var _centerY = size.height / 2;
    var _center = Offset(_centerX, _centerY);
    var _radius = min(_centerX, _centerY) * 0.72;
    var _time = DateFormat('HH:mm').format(DateTime.now()).split(':');
    var _angle = int.parse(_time[0]) / 24 + int.parse(_time[1]) / 60 / 24;
    var _shift = _angle * pi * 2;
    final midnightPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30.0;

    canvas.drawArc(
        new Rect.fromCenter(
            center: _center, width: _radius * 2, height: _radius * 2),
        pi * 3 / 2 + _shift,
        ((2 * pi * (0.01)) < 0)
            ? (2 * pi * (0.01) + pi * 2)
            : (2 * pi * (0.01)),
        false,
        midnightPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
