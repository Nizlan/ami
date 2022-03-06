import 'package:ami/constants/emojis.dart';
import 'package:flutter/material.dart';

class EmojiPicker extends StatefulWidget {
  const EmojiPicker({Key? key}) : super(key: key);

  @override
  State<EmojiPicker> createState() => _EmojiPickerState();
}

class _EmojiPickerState extends State<EmojiPicker> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: Emojis.faces.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
        ),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () => Navigator.pop(context, Emojis.faces[index]),
            child: Container(
                alignment: Alignment.center,
                child: Text(
                  Emojis.faces[index],
                  style: TextStyle(fontSize: 30),
                )),
          );
        });
  }
}
