import 'package:ami/enums/button_type.dart';
import 'package:ami/providers/activities_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/activity.dart';
import '../../utils/time_view_convert.dart';
import '../pick_time.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int hour1 = 0;
  int minute1 = 0;
  int hour2 = 0;
  int minute2 = 0;
  void callbackh1(int time) {
    setState(() {
      this.hour1 = time;
    });
  }

  void callbackm1(int time) {
    setState(() {
      this.minute1 = time;
    });
  }

  void callbackh2(int time) {
    setState(() {
      this.hour2 = time;
    });
  }

  void callbackm2(int time) {
    setState(() {
      this.minute2 = time;
    });
  }

  @override
  void initState() {
    Night night = Provider.of<Activities>(this.context, listen: false).night;
    Map<String, int> start = timeRelativeToAbsolute(night.start.toDouble());
    Map<String, int> end = timeRelativeToAbsolute(night.end.toDouble());
    hour1 = start['hour']!;
    minute1 = start['minute']!;
    hour2 = end['hour']!;
    minute2 = end['minute']!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  content: PickTime(
                    callbackh1: callbackh1,
                    callbackm1: callbackm1,
                    callbackh2: callbackh2,
                    callbackm2: callbackm2,
                    timeType: ButtonType.activity,
                    name: 'Выберите ночное время',
                    h1: hour1,
                    m1: minute1,
                    h2: hour2,
                    m2: minute2,
                  ),
                  actions: [
                    ElevatedButton(
                        child: Text("Принять"),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                          Provider.of<Activities>(this.context, listen: false)
                              .setNight(
                            timeAbsoluteToRelative(hour1, minute1),
                            timeAbsoluteToRelative(hour2, minute2),
                          );
                        }),
                  ],
                ),
              ),
            },
        child: Container(
          child: Image.asset(
            'assets/images/sleep.png',
            scale: 2.0,
          ),
        ));
  }
}
