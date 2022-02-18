import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Picker extends StatefulWidget {
  final Function callback;
  final bool isHours;
  final int time;

  Picker(this.callback, this.isHours, this.time);

  @override
  _PickerState createState() => _PickerState();
}

class _PickerState extends State<Picker> {
  late Text text;
  late String yourParam;
  var arr = <Text>[];
  var selectedValue;

  void initState() {
    arr = [];
    if (widget.isHours) {
      for (var i = 0; i < 24; i++) {
        if (i + widget.time <= 23) {
          if (i + widget.time < 10) {
            arr.add(Text('0${i + widget.time}'));
          } else {
            arr.add(Text('${i + widget.time}'));
          }
        } else {
          if (((i + widget.time) - 24) < 10) {
            arr.add(Text('0${i + widget.time - 24}'));
          } else {
            arr.add(Text('${i + widget.time - 24}'));
          }
        }
      }
    } else {
      for (var i = 0; i < 60; i++) {
        if (i + widget.time <= 59) {
          if (i + widget.time < 10) {
            arr.add(Text('0${i + widget.time}'));
          } else {
            arr.add(Text('${i + widget.time}'));
          }
        } else {
          if (((i + widget.time) - 60) < 10) {
            arr.add(Text('0${i + widget.time - 60}'));
          } else {
            arr.add(Text('${i + widget.time - 60}'));
          }
        }
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Container(
      width: mediaQuery.size.width / 7,
      child: CupertinoPicker(
        backgroundColor: Colors.white,
        onSelectedItemChanged: (value) {
          setState(() {
            text = arr[value];
            selectedValue = text.data;
            this.widget.callback(selectedValue);
          });
        },
        itemExtent: 32.0,
        children: arr,
        looping: true,
      ),
    );
  }
}
