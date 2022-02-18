import 'package:ami/models/activity.dart';
import 'package:ami/providers/activities_provider.dart';
import 'package:ami/providers/diagram_params_provider.dart';
import 'package:ami/widgets/color_picker.dart';
import 'package:ami/widgets/cupertino_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatefulWidget {
  final Activity activity;
  EditScreen(this.activity);
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  var hour1;
  var minute1;
  var hour2;
  var minute2;
  late bool isAllowed;
  late TextEditingController _textController;
  final month = DateTime.now().month < 10
      ? '0${DateTime.now().month}'
      : DateTime.now().month;
  final day =
      DateTime.now().day < 10 ? '0${DateTime.now().day}' : DateTime.now().day;
  toColor(colorString) {
    String valueString = colorString.split('(0x')[1].split(')')[0];
    int value = int.parse(valueString, radix: 16);
    return Color(value);
  }

  timeConverter(double time) {
    int hours = time ~/ (1 / 24);
    int minutes = ((time % (1 / 24)) * 1442).toInt();
    return [hours, minutes];
  }

  late Color color;
  void callbackColor(Color color) {
    setState(() {
      this.color = color;
    });
  }

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
  void initState() {
    this._textController = TextEditingController(text: widget.activity.name);
    this.hour1 = timeConverter(widget.activity.start.toDouble())[0].toString();
    this.minute1 =
        timeConverter(widget.activity.start.toDouble())[1].toString();
    this.hour2 = timeConverter(widget.activity.end.toDouble())[0].toString();
    this.minute2 = timeConverter(widget.activity.end.toDouble())[1].toString();
    color = toColor(widget.activity.color);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Container(
          margin: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.width / 8),
          width: MediaQuery.of(context).size.width,
          child: Stack(alignment: AlignmentDirectional.center, children: [
            Positioned(
              child: GestureDetector(
                child: this._textController.text == ''
                    ? Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 2, color: Colors.black),
                          ),
                        ),
                        child: Text(
                          widget.activity.name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      )
                    : Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 2, color: Colors.black),
                          ),
                        ),
                        child: Text(
                          _textController.text,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                onTap: () => showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                      title: Text(
                        'Изменить название',
                        style: TextStyle(fontSize: 20),
                      ),
                      content: TextField(
                        autofocus: true,
                        controller: _textController,
                        onSubmitted: (_) => setState(() {}),
                      ),
                      actions: []),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                right: MediaQuery.of(context).size.width / 15,
              ),
              alignment: Alignment.centerRight,
              child: GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    color: this.color,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  height: MediaQuery.of(context).size.width / 10,
                  width: MediaQuery.of(context).size.width / 10,
                ),
                onTap: () => showModalBottomSheet(
                    context: context,
                    builder: (_) {
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        child: ColorPickerWidget(this.callbackColor),
                      );
                    }),
              ),
            ),
          ]),
        ),
        Container(
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).size.width / 8),
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              widget.activity.start != 2
                  ? widget.activity.end != 2
                      ? Row(
                          children: [
                            Picker(
                                this.callbackh1,
                                true,
                                timeConverter(
                                    widget.activity.start.toDouble())[0]),
                            Picker(
                                this.callbackm1,
                                false,
                                timeConverter(
                                    widget.activity.start.toDouble())[1]),
                            Text(':'),
                            Picker(
                                this.callbackh2,
                                true,
                                timeConverter(
                                    widget.activity.end.toDouble())[0]),
                            Picker(
                                this.callbackm2,
                                false,
                                timeConverter(
                                    widget.activity.end.toDouble())[1]),
                          ],
                        )
                      : Row(
                          children: [
                            Picker(
                                this.callbackh1,
                                true,
                                timeConverter(
                                    widget.activity.start.toDouble())[0]),
                            Text(':'),
                            Picker(
                                this.callbackm1,
                                false,
                                timeConverter(
                                    widget.activity.start.toDouble())[1]),
                          ],
                        )
                  : Spacer()
            ],
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextButton(
            onPressed: () async {
              isAllowed = await Provider.of<Activities>(this.context,
                      listen: false)
                  .isAllowed(
                      double.parse(hour1) / 24 + double.parse(minute1) / 1440,
                      double.parse(hour2) / 24 + double.parse(minute2) / 1440,
                      widget.activity.id);
              if (isAllowed) {
                Provider.of<Activities>(this.context, listen: false)
                    .editActivity(
                        widget.activity.id,
                        _textController.text != ''
                            ? _textController.text
                            : widget.activity.name,
                        double.parse(hour1) / 24 + double.parse(minute1) / 1440,
                        double.parse(hour2) / 24 + double.parse(minute2) / 1440,
                        color,
                        widget.activity.isDone ?? 0,
                        widget.activity.date);
                Provider.of<Activities>(this.context, listen: false)
                    .fetchAndSet();
                Navigator.pop(context);
              } else {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Выбранный промежуток недопустим'),
                  ),
                );
              }
            },
            child: Text(
              'Изменить',
              style: TextStyle(fontSize: 20),
            ),
          ),
          TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateColor.resolveWith((states) => Colors.red)),
              child: Text(
                'Удалить',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Provider.of<Activities>(this.context, listen: false)
                    .deleteActivity(widget.activity.id);
                Navigator.pop(context);
              })
        ])
      ]),
    );
  }
}
