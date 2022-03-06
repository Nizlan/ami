import 'package:ami/utils/emoji_picker.dart';
import 'package:ami/utils/time_view_convert.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'package:ami/enums/button_type.dart';
import 'package:ami/providers/activities_provider.dart';
import 'package:ami/widgets/color_picker.dart';
import 'package:ami/widgets/pick_time.dart';

class AddScreen extends StatefulWidget {
  final ButtonType buttonType;
  AddScreen({
    Key? key,
    required this.buttonType,
  }) : super(key: key);
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  Color color = Colors.white;
  int hour1 = 0;
  int minute1 = 0;
  int hour2 = 0;
  int minute2 = 0;
  var nightStart1;
  var nightEnd1;
  var isTime = false;
  late bool isAllowed;
  var uuid = Uuid();
  String emoji = '🐵';
  final _textController = TextEditingController();
  void callbackColor(Color color) {
    setState(() {
      this.color = color;
    });
  }

  month(DateTime date) {
    return date.month < 10 ? '0${date.month}' : date.month;
  }

  day(DateTime date) {
    return date.day < 10 ? '0${date.day}' : date.day;
  }

  timeConverter(double time) {
    int hours = time ~/ (1 / 24);
    int minutes = ((time % (1 / 24)) * 1442).toInt();
    return [hours, minutes];
  }

  toColor(colorString) {
    String valueString = colorString.split('(0x')[1].split(')')[0];
    int value = int.parse(valueString, radix: 16);
    return Color(value);
  }

  void callbackh1(int time) {
    setState(() {
      hour1 = time;
    });
  }

  void callbackm1(int time) {
    setState(() {
      minute1 = time;
    });
  }

  void callbackh2(int time) {
    setState(() {
      hour2 = time;
    });
  }

  void callbackm2(int time) {
    setState(() {
      minute2 = time;
    });
  }

  void dateCallback(DateTime date) {
    setState(() {
      Provider.of<Activities>(this.context, listen: true).date.date = date;
    });
  }

  void _presentDatePicker() {
    showDatePicker(
            helpText: '',
            context: context,
            locale: const Locale("ru", "RU"),
            initialDate: Provider.of<Activities>(this.context, listen: false)
                .initialDate,
            firstDate: DateTime(2020),
            lastDate: DateTime.now().add(const Duration(days: 365)))
        .then((pickedDate) {
      if (pickedDate != null) {
        Provider.of<Activities>(this.context, listen: false)
            .updateDate(pickedDate);
      }
    });
  }

  @override
  void initState() {
    initializeDateFormatting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
      decoration: BoxDecoration(
          color: Color(0xFF00BCB4),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      child: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, Colors.white],
              begin: Alignment.topRight,
              end: Alignment.center,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.width / 30),
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Positioned(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 60, 0),
                            child: TextField(
                              maxLines: 15,
                              style: TextStyle(fontSize: 30),
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              autofocus: true,
                              controller: _textController,
                              onSubmitted: (_) => setState(() {}),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: MediaQuery.of(context).size.width / 15,
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  color: color,
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                height: MediaQuery.of(context).size.width / 10,
                                width: MediaQuery.of(context).size.width / 10,
                              ),
                              onTap: () => showModalBottomSheet(
                                  context: context,
                                  builder: (_) {
                                    return Container(
                                      height: 300,
                                      child:
                                          ColorPickerWidget(this.callbackColor),
                                    );
                                  }),
                            ),
                          ),
                        ),
                        Positioned(
                            top: 80,
                            right: MediaQuery.of(context).size.width / 18,
                            child: GestureDetector(
                              onTap: () => showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return EmojiPicker();
                                },
                              ).then((value) => value != null
                                  ? setState(() {
                                      emoji = value;
                                    })
                                  : null),
                              child: Text(
                                emoji,
                                style: TextStyle(fontSize: 40),
                              ),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                  child: GestureDetector(
                      child: Container(
                        height: 45,
                        width: 45,
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Image.asset(
                          'assets/images/time.png',
                          width: MediaQuery.of(context).size.width / 15,
                          scale: 1.5,
                        ),
                      ),
                      onTap: () => setState(() {
                            isTime = true;
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                content: PickTime(
                                  callbackh1: callbackh1,
                                  callbackm1: callbackm1,
                                  callbackh2: callbackh2,
                                  callbackm2: callbackm2,
                                  name: 'Выберите время',
                                  timeType: widget.buttonType,
                                  h1: 0,
                                  m1: 0,
                                  h2: 0,
                                  m2: 0,
                                ),
                              ),
                            );
                          })),
                ),
                GestureDetector(
                  onTap: () async {
                    isAllowed = isTime
                        ? await Provider.of<Activities>(this.context,
                                listen: false)
                            .isAllowed(
                            timeAbsoluteToRelative(hour1, minute1),
                            widget.buttonType == ButtonType.task
                                ? 2
                                : timeAbsoluteToRelative(hour2, minute2),
                            '${uuid.v1()}',
                          )
                        : await Provider.of<Activities>(this.context,
                                listen: false)
                            .isAllowed(2, 2, '${uuid.v1()}');

                    if (isAllowed) {
                      if (color != Colors.white || !isTime) {
                        if (_textController.text == '') {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Введите название'),
                            ),
                          );
                          return;
                        }
                        if (!isTime) {
                          Navigator.pop(context);
                          Provider.of<Activities>(this.context, listen: false)
                              .addActivity(
                                  '${uuid.v1()}',
                                  _textController.text,
                                  2,
                                  2,
                                  color,
                                  '${Provider.of<Activities>(this.context, listen: false).date.date.year}-${(month(Provider.of<Activities>(this.context, listen: false).date.date))}-${day(Provider.of<Activities>(this.context, listen: false).date.date)}',
                                  emoji);
                        } else if (widget.buttonType == ButtonType.task) {
                          Navigator.pop(context);
                          Provider.of<Activities>(this.context, listen: false)
                              .addActivity(
                                  '${uuid.v1()}',
                                  _textController.text,
                                  timeAbsoluteToRelative(hour1, minute1),
                                  2,
                                  color,
                                  '${Provider.of<Activities>(this.context, listen: false).date.date.year}-${(month(Provider.of<Activities>(this.context, listen: false).date.date))}-${day(Provider.of<Activities>(this.context, listen: false).date.date)}',
                                  emoji);
                          // Provider.of<Activities>(this.context, listen: false)
                          //     .clear();
                        } else if (widget.buttonType == ButtonType.activity) {
                          Navigator.pop(context);
                          Provider.of<Activities>(this.context, listen: false)
                              .addActivity(
                                  '${uuid.v1()}',
                                  _textController.text,
                                  timeAbsoluteToRelative(hour1, minute1),
                                  timeAbsoluteToRelative(hour2, minute2),
                                  color,
                                  '${Provider.of<Activities>(this.context, listen: false).date.date.year}-${(month(Provider.of<Activities>(this.context, listen: false).date.date))}-${day(Provider.of<Activities>(this.context, listen: false).date.date)}',
                                  emoji);
                          // Provider.of<Activities>(this.context, listen: false)
                          //     .clear();
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Выберите цвет'),
                          ),
                        );
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text('Выбранное время недопустимо'),
                        ),
                      );
                    }
                  },
                  child: Container(
                      width: 80,
                      height: 80,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Image.asset('assets/images/arrow.png')),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                  child: GestureDetector(
                    onTap: _presentDatePicker,
                    child: Container(
                      padding: EdgeInsets.all(3),
                      height: 45,
                      width: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            child: Text(
                              Provider.of<Activities>(this.context,
                                      listen: true)
                                  .date
                                  .date
                                  .day
                                  .toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xfffddbb8), fontSize: 16),
                            ),
                          ),
                          Positioned(
                              child: Image.asset('assets/images/calendar.png')),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
