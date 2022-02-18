import 'package:ami/models/activity.dart';
import 'package:ami/providers/activities_provider.dart';
import 'package:ami/screens/edit_screen.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class CommonPicker extends StatefulWidget {
  final MediaQueryData size;
  final Activity activity;
  CommonPicker(this.size, this.activity);
  @override
  _CommonPickerState createState() => _CommonPickerState();
}

class _CommonPickerState extends State<CommonPicker> {
  var isNight = false;
  var hour1;
  var minute1;
  var hour2;
  var minute2;
  var nightStart1;
  var nightEnd1;
  late Color color;

  final month = DateTime.now().month < 10
      ? '0${DateTime.now().month}'
      : DateTime.now().month;
  final day =
      DateTime.now().day < 10 ? '0${DateTime.now().day}' : DateTime.now().day;

  timeConverter(double time) {
    int hours = time ~/ (1 / 24);
    String strHours = hours.toString();
    if (strHours.length < 2) {
      strHours = '0' + strHours;
    }
    int minutes = ((time % (1 / 24)) * 1442).toInt();
    String strMinutes = minutes.toString();
    if (strMinutes.length < 2) {
      strMinutes = '0' + strMinutes;
    }
    return [strHours, strMinutes];
  }

  toColor(colorString) {
    String valueString = colorString.split('(0x')[1].split(')')[0];
    int value = int.parse(valueString, radix: 16);
    return Color(value);
  }

  @override
  void initState() {
    this.hour1 = timeConverter(widget.activity.start.toDouble())[0].toString();
    this.minute1 =
        timeConverter(widget.activity.start.toDouble())[1].toString();
    this.hour2 = timeConverter(widget.activity.end.toDouble())[0].toString();
    this.minute2 = timeConverter(widget.activity.end.toDouble())[1].toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Card(
        margin: EdgeInsets.only(right: 10),
        elevation: 0.0,
        child: ListTile(
          tileColor: Provider.of<Activities>(this.context, listen: false)
                  .isCurrentTime(widget.activity.start, widget.activity.end)
              ? toColor(widget.activity.color)
              : Colors.white,
          leading: Transform.scale(
            scale: 1.5,
            child: Checkbox(
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              value: widget.activity.isDone == 1 ? true : false,
              onChanged: (_) =>
                  Provider.of<Activities>(this.context, listen: false)
                      .editActivity(
                          widget.activity.id,
                          widget.activity.name,
                          widget.activity.start,
                          widget.activity.end,
                          toColor(widget.activity.color),
                          widget.activity.isDone == 0 ? 1 : 0,
                          widget.activity.date),
            ),
          ),
          title: Text(
            widget.activity.name,
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          subtitle: widget.activity.start != 2
              ? widget.activity.end == 2
                  ? Text(
                      '${timeConverter(widget.activity.start.toDouble())[0]}:${timeConverter(widget.activity.start.toDouble())[1]}',
                      style: TextStyle(
                        color: Provider.of<Activities>(this.context,
                                    listen: false)
                                .isCurrentTime(
                                    widget.activity.start, widget.activity.end)
                            ? Colors.white
                            : Colors.black,
                        fontSize: 13,
                      ))
                  : Text(
                      '${timeConverter(widget.activity.start.toDouble())[0]}:${timeConverter(widget.activity.start.toDouble())[1]} - ${timeConverter(widget.activity.end.toDouble())[0]}:${timeConverter(widget.activity.end.toDouble())[1]}',
                      style: TextStyle(
                          color: Provider.of<Activities>(this.context,
                                      listen: false)
                                  .isCurrentTime(widget.activity.start,
                                      widget.activity.end)
                              ? Colors.white
                              : Colors.black,
                          fontSize: 13))
              : Text(
                  '',
                ),
          trailing: Container(
            width: MediaQuery.of(context).size.width / 5,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: Provider.of<Activities>(this.context, listen: false)
                            .isEditable
                        ? Image.asset(
                            'assets/images/vector.png',
                            width: MediaQuery.of(context).size.width / 15,
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width / 15,
                          ),
                    onTap: () => showModalBottomSheet(
                        elevation: 20.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
                        ),
                        context: context,
                        builder: (BuildContext context) {
                          return EditScreen(widget.activity);
                        }),
                    // onTap: () =>
                    //     Provider.of<Activities>(this.context, listen: false)
                    //         .returnEdit(widget.activity),
                  ),
                  if (Provider.of<Activities>(this.context, listen: false)
                      .isEditable)
                    GestureDetector(
                      child: Image.asset(
                        widget.activity.start == 2
                            ? 'assets/images/yes.png'
                            : 'assets/images/no.png',
                        width: MediaQuery.of(context).size.width / 15,
                      ),
                    ),
                ]),
          ),
        ),
      ),
    );
  }
}
