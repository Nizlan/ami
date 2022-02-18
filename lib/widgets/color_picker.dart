import 'package:flutter/material.dart';

import 'package:flex_color_picker/flex_color_picker.dart';

class ColorPickerWidget extends StatefulWidget {
  final Function callback;
  ColorPickerWidget(this.callback);
  @override
  _ColorPickerWidgetState createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  late Color screenPickerColor;
  @override
  void initState() {
    super.initState();
    screenPickerColor = Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return ColorPicker(
      pickersEnabled: {
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: false
      },
      enableShadesSelection: false,
      onColorChanged: (Color color) => setState(() {
        screenPickerColor = color;
        widget.callback(color);
      }),
      color: screenPickerColor,
      heading: Text(
        'Выберите цвет',
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }
}
