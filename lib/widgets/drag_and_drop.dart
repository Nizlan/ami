import 'package:ami/providers/activities_provider.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'common_picker.dart';

class DragAndDrop extends StatefulWidget {
  const DragAndDrop({Key? key}) : super(key: key);

  @override
  _DragAndDropState createState() => _DragAndDropState();
}

class _DragAndDropState extends State<DragAndDrop> {
  List<DragAndDropList> _contents = [];
  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    Provider.of<Activities>(this.context, listen: false)
        .changePosition(oldItemIndex, newItemIndex);
  }

  _onListReorder(int oldListIndex, int newListIndex) {}

  @override
  Widget build(BuildContext context) {
    return Consumer<Activities>(
      builder: (context, activities, ch) => Container(
          padding: EdgeInsets.zero,
          height: MediaQuery.of(context).size.height / 3.2,
          child: DragAndDropLists(
            lastListTargetSize: 0,
            removeTopPadding: true,
            itemSizeAnimationDurationMilliseconds: 1,
            listPadding: EdgeInsets.zero,
            children: _contents = [
              DragAndDropList(
                canDrag: false,
                children: <DragAndDropItem>[
                  for (var i = 0; i < activities.activities.length; i++)
                    DragAndDropItem(
                      canDrag: activities.activities[i].start == 2,
                      child: CommonPicker(
                          MediaQuery.of(context), activities.activities[i]),
                    ),
                ],
              )
            ],
            onItemReorder: _onItemReorder,
            onListReorder: _onListReorder,
          )),
    );
  }
}
