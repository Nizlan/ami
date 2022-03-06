import 'dart:math';

import 'package:ami/models/activity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Images extends StatefulWidget {
  final Activity activity;
  final double size;
  final double rotation;
  final String emoji;
  Images(this.activity, this.size, this.rotation, this.emoji);
  @override
  _ImagesState createState() => _ImagesState();
}

class _ImagesState extends State<Images> {
  late List<String> _time;
  late double _angle;
  late double _shift;
  static double emojiSide = 40;
  @override
  void initState() {
    _time = DateFormat('HH:mm').format(DateTime.now()).split(':');
    _angle = int.parse(_time[0]) / 24 + int.parse(_time[1]) / 60 / 24;
    _shift = _angle * pi * 2;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Positioned(
        left: (2 * pi * (widget.activity.start + widget.rotation - _angle)) > 0
            ? (widget.size - emojiSide) / 2 +
                (widget.size - emojiSide) /
                    2 *
                    sin(2 *
                        pi *
                        (widget.activity.start + widget.rotation - _angle))
            : (widget.size - emojiSide) / 2 +
                (widget.size - emojiSide) /
                    2 *
                    sin(2 *
                            pi *
                            (widget.activity.start + widget.rotation - _angle) +
                        pi * 2),
        top: (widget.size - emojiSide) / 2 -
            (widget.size - emojiSide) /
                2 *
                cos(2 *
                    pi *
                    (widget.activity.start + widget.rotation - _angle)),
        child: Container(
          alignment: Alignment.center,
          height: emojiSide,
          width: emojiSide,
          child: Text(
            widget.emoji,
            style: TextStyle(fontSize: 30),
          ),
        ),
      ),
    );
  }
}
