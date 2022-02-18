import 'dart:ui';

import 'package:ami/models/button_type.dart';
import 'package:ami/screens/add_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NestedButtons extends StatefulWidget {
  const NestedButtons({Key? key}) : super(key: key);

  @override
  _NestedButtonsState createState() => _NestedButtonsState();
}

class _NestedButtonsState extends State<NestedButtons> {
  bool isOpen = false;
  double sigmaX = 0;
  double sigmaY = 0;

  void changeIsOpen() {
    setState(() {
      if (isOpen) {
        sigmaX = 0;
        sigmaY = 0;
      } else {
        sigmaX = 5;
        sigmaY = 5;
      }
      isOpen = !isOpen;
    });
  }

  void showModalSheet(var screen) => showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      elevation: 20.0,
      context: context,
      builder: (BuildContext context) {
        return screen;
      });
  Widget nestedButton(
      var screen, double scale, bool isMainButton, Widget icon, String text) {
    return Container(
      width: 150,
      child: Row(
        children: [
          Expanded(
              child: Text(
            text,
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.end,
          )),
          SizedBox(
            width: 10,
          ),
          Transform.scale(
            alignment: Alignment.topCenter,
            scale: scale,
            child: FloatingActionButton(
              onPressed: () {
                isMainButton
                    ? changeIsOpen()
                    : {
                        changeIsOpen(),
                        showModalSheet(screen),
                      };
              },
              child: Transform.scale(scale: 2, child: icon),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: sigmaX,
        sigmaY: sigmaY,
      ),
      child: Container(
        height: 200,
        padding: EdgeInsets.fromLTRB(0, 0, 10, 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          verticalDirection: VerticalDirection.up,
          children: [
            nestedButton(null, 1.2, true,
                isOpen ? Icon(Icons.keyboard_arrow_down) : Icon(Icons.add), ''),
            if (isOpen)
              nestedButton(
                  AddScreen(buttonType: ButtonType.task),
                  1.0,
                  false,
                  SvgPicture.asset(
                    'assets/images/icon_task.svg',
                    width: 15,
                    height: 15,
                  ),
                  'Задача'),
            if (isOpen)
              nestedButton(
                  AddScreen(buttonType: ButtonType.activity),
                  1.0,
                  false,
                  SvgPicture.asset(
                    'assets/images/icon_activity.svg',
                    width: 15,
                    height: 15,
                  ),
                  'Активность'),
          ],
        ),
      ),
    );
  }
}
