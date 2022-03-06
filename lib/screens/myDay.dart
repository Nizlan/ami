import 'package:ami/enums/day_change_type.dart';
import 'package:ami/providers/activities_provider.dart';
import 'package:ami/utils/present_date_picker.dart';
import 'package:ami/widgets/diagram/day_container.dart';
import 'package:ami/widgets/drag_and_drop.dart';
import 'package:ami/widgets/nested_button.dart';
import 'package:ami/widgets/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/activity.dart';
import '../utils/sort_functions.dart';

class MyDay extends StatefulWidget {
  @override
  _MyDayState createState() => _MyDayState();
}

class _MyDayState extends State<MyDay> {
  late Future<void> fetchAndSetFuture;

  @override
  void initState() {
    fetchAndSetFuture =
        Provider.of<Activities>(context, listen: false).fetchAndSet().then((_) {
      Provider.of<Activities>(context, listen: false).initializeNight();
    }).then((_) => Provider.of<Activities>(context, listen: false).getNight());
    super.initState();
  }

  late MediaQueryData mediaQuery;
  late int selectedValue;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FutureBuilder<void>(
        future: fetchAndSetFuture,
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : Consumer<Activities>(
                builder: (context, activities, ch) => Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 25,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: mediaQuery.size.height / 15),
                      child: Row(
                        children: [
                          Flexible(
                              flex: 1, child: Center(child: SettingsPage())),
                          Flexible(
                            flex: 1,
                            child: Center(
                              child: Text(
                                  Provider.of<Activities>(this.context,
                                          listen: false)
                                      .time,
                                  style: TextStyle(fontSize: 30)),
                            ),
                          ),
                          Spacer(
                            flex: 1,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DayContainer(
                            mediaQuery,
                            activities.activities.length != 0
                                ? activities.activities[0].id != ''
                                    ? sortForArc(activities.activities)
                                    : []
                                : [],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 15,
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width / 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(
                            flex: 3,
                          ),
                          InkWell(
                            onTap: () => Provider.of<Activities>(this.context,
                                    listen: false)
                                .editDate(DayChangeType.yesterday),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Icon(Icons.arrow_back_ios),
                            ),
                          ),
                          TextButton(
                            onPressed: () => presentDatePicker(context),
                            child: Text(
                              Provider.of<Activities>(this.context,
                                      listen: true)
                                  .getDateView(),
                              style: TextStyle(fontSize: 32),
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () => Provider.of<Activities>(this.context,
                                    listen: false)
                                .editDate(DayChangeType.tomorrow),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                          Spacer(
                            flex: 17,
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 4),
                            child: GestureDetector(
                              child: Image(
                                width: MediaQuery.of(context).size.width / 15,
                                image: AssetImage('assets/images/vector.png'),
                              ),
                              onTap: () => Provider.of<Activities>(this.context,
                                      listen: false)
                                  .changeEditable(),
                            ),
                          ),
                          Spacer(
                            flex: 3,
                          ),
                        ],
                      ),
                    ),
                    activities.activities.length != 0
                        ? activities.activities[0].id != ''
                            ? DragAndDrop()
                            : CircularProgressIndicator()
                        : SizedBox(),
                  ],
                ),
              ),
      ),
      floatingActionButton: NestedButtons(),
    );
  }
}
