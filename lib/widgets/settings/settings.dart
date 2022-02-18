import 'package:ami/models/button_type.dart';
import 'package:ami/providers/activities_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pick_time.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var hour1 = '0';
  var minute1 = '0';
  var hour2 = '0';
  var minute2 = '0';
  void callbackh1(String time) {
    setState(() {
      this.hour1 = time;
    });
  }

  void callbackm1(String time) {
    setState(() {
      this.minute1 = time;
    });
  }

  void callbackh2(String time) {
    setState(() {
      this.hour2 = time;
    });
  }

  void callbackm2(String time) {
    setState(() {
      this.minute2 = time;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                content: PickTime(
                  callbackh1: callbackh1,
                  callbackm1: callbackm1,
                  callbackh2: callbackh2,
                  callbackm2: callbackm2,
                  timeType: ButtonType.activity,
                  name: 'Выберите ночное время',
                ),
                actions: [
                  ElevatedButton(
                      child: Text("Принять"),
                      onPressed: () {
                        Navigator.of(context).pop(true); // Return value
                      }),
                ],
              ),
            ).then((value) => value
                ? Provider.of<Activities>(this.context, listen: false).setNight(
                    double.parse(hour1) / 24 + double.parse(minute1) / 1440,
                    double.parse(hour2) / 24 + double.parse(minute2) / 1440,
                  )
                : null),
        child: Container(
          child: Image.asset(
            'assets/images/sleep.png',
            scale: 2.0,
          ),
        ));
  }
}
