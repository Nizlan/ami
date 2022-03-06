import 'package:ami/enums/button_type.dart';
import 'package:flutter/material.dart';

import 'package:ami/widgets/cupertino_picker.dart';

class PickTime extends StatefulWidget {
  final Function callbackh1;
  final Function callbackm1;
  final Function callbackh2;
  final Function callbackm2;
  final String name;
  final ButtonType timeType;
  final int h1;
  final int m1;
  final int h2;
  final int m2;
  const PickTime(
      {Key? key,
      required this.callbackh1,
      required this.callbackm1,
      required this.callbackh2,
      required this.callbackm2,
      required this.name,
      required this.timeType,
      required this.h1,
      required this.m1,
      required this.h2,
      required this.m2})
      : super(key: key);

  @override
  _PickTimeState createState() => _PickTimeState();
}

class _PickTimeState extends State<PickTime> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Column(
        children: [
          Text(widget.name),
          SizedBox(
            height: 40,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: []),
          Container(
            margin:
                EdgeInsets.only(bottom: MediaQuery.of(context).size.width / 16),
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Picker(widget.callbackh1, true, widget.h1),
                Picker(widget.callbackm1, false, widget.m1),
                widget.timeType == ButtonType.activity
                    ? Row(children: [
                        Text(
                          ':',
                          style: TextStyle(fontSize: 20),
                        ),
                        Picker(widget.callbackh2, true, widget.h2),
                        Picker(widget.callbackm2, false, widget.m2)
                      ])
                    : Container()
              ],
            ),
          )
        ],
      ),
    );
  }
}
