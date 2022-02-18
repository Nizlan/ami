import 'package:ami/models/activity.dart';
import 'package:ami/providers/activities_provider.dart';
import 'package:ami/widgets/diagram/images.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'activity_arc.dart';
import 'dayWidget.dart';

class DayContainer extends StatefulWidget {
  final MediaQueryData mediaQuery;
  final List<Activity> activities;
  DayContainer(this.mediaQuery, this.activities);
  @override
  _DayContainerState createState() => _DayContainerState();
}

class _DayContainerState extends State<DayContainer> {
  double multiplier = 2.7;

  toColor(colorString) {
    print(colorString);
    String valueString = colorString.split('(0x')[1].split(')')[0];
    int value = int.parse(valueString, radix: 16);
    return Color(value);
  }

  double size = 330;
  listEl(Activity act) {
    if (act.start != 2) {
      return CustomPaint(
        painter: ActivityArc(
            act.start.toDouble(),
            act.end.toDouble(),
            toColor(act.color),
            Provider.of<Activities>(this.context, listen: false).rotation),
        size: Size(size, size),
      );
    } else {
      return SizedBox();
    }
  }

  imageList(Activity act) {
    if (act.start != 2) {
      return Images(act, size,
          Provider.of<Activities>(this.context, listen: false).rotation);
    } else {
      return SizedBox();
    }
  }

  // midnight() {
  //   return CustomPaint(
  //     painter: ActivityArc(0.1, 0.5, Colors.black,
  //         Provider.of<Activities>(this.context, listen: false).rotation),
  //     size: Size(size, size),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        child: InteractiveViewer(
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                painter: DayWidget(),
                size: Size(size, size),
              ),
              Container(
                  height: size,
                  width: size,
                  child: Stack(children: [
                    listEl(Provider.of<Activities>(this.context, listen: false)
                        .night),
                    for (var act in widget.activities) listEl(act),
                    for (var act in widget.activities) imageList(act),
                  ])),
              Positioned(
                child: Listener(
                  onPointerMove: (PointerEvent event) {
                    if (event.position.dy < size / 2 &&
                        event.position.dx < size / 2) {
                      Provider.of<Activities>(this.context, listen: false)
                          .updateRotation(Provider.of<Activities>(this.context,
                                      listen: false)
                                  .rotation +
                              event.delta.dx / (size * multiplier) -
                              event.delta.dy / (size * multiplier));
                      Provider.of<Activities>(this.context, listen: false)
                          .addTime(Provider.of<Activities>(this.context,
                                  listen: false)
                              .rotation);
                    } else if (event.position.dy < size / 2 &&
                        event.position.dx > size / 2) {
                      Provider.of<Activities>(this.context, listen: false)
                          .updateRotation(Provider.of<Activities>(this.context,
                                      listen: false)
                                  .rotation +
                              event.delta.dx / (size * multiplier) +
                              event.delta.dy / (size * multiplier));
                      Provider.of<Activities>(this.context, listen: false)
                          .addTime(Provider.of<Activities>(this.context,
                                  listen: false)
                              .rotation);
                    } else if (event.position.dy > size / 2 &&
                        event.position.dx > size / 2) {
                      Provider.of<Activities>(this.context, listen: false)
                          .updateRotation(Provider.of<Activities>(this.context,
                                      listen: false)
                                  .rotation -
                              event.delta.dx / (size * multiplier) +
                              event.delta.dy / (size * multiplier));
                      Provider.of<Activities>(this.context, listen: false)
                          .addTime(Provider.of<Activities>(this.context,
                                  listen: false)
                              .rotation);
                    } else if (event.position.dy > size / 2 &&
                        event.position.dx < size / 2) {
                      Provider.of<Activities>(this.context, listen: false)
                          .updateRotation(Provider.of<Activities>(this.context,
                                      listen: false)
                                  .rotation -
                              event.delta.dx / (size * multiplier) -
                              event.delta.dy / (size * multiplier));
                      Provider.of<Activities>(this.context, listen: false)
                          .addTime(Provider.of<Activities>(this.context,
                                  listen: false)
                              .rotation);
                    }
                  },
                  child: Container(
                    width: size,
                    height: size,
                    child: Text(''),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
