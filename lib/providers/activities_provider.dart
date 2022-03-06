import 'package:ami/enums/day_change_type.dart';
import 'package:ami/helpers/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../models/activity.dart';
import '../models/date.dart';
import '../utils/time_view_convert.dart';

class Activities with ChangeNotifier {
  List<Activity> _activities = [];
  final commentWidgets = <Widget>[];
  Night night =
      Night(id: 'night', start: 0.9, end: 0.3, color: 'Color(0xff214883)');
  late List<Activity> sortedActivities;
  var time = DateFormat('HH:mm').format(DateTime.now());
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  Date date = Date(
      DateTime.now(), null, DateFormat('yyyy-MM-dd').format(DateTime.now()));
  DateTime initialDate = DateTime.now();
  bool isEditable = false;
  double rotation = 0.0;

  List<Activity> get activities {
    return [..._activities];
  }

  void setActivities(List<Activity> newActivities) {
    _activities = newActivities;
  }

  void initializeNight() async {
    try {
      print('night');
      final nightFromSql = await DBHelper.getData('night');
      if (nightFromSql.length == 0) {
        DBHelper.insert('night', {
          'id': 'night',
          'start': 0.9,
          'end': 0.3,
          'color': 'Color(0xff214883)',
        });
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void setNight(double start, double end) async {
    night = Night(id: night.id, start: start, end: end, color: night.color);
    await DBHelper.update('night', {'start': start, 'end': end}, night.id);
    notifyListeners();
  }

  Future<void> getNight() async {
    final nightFromSql = await DBHelper.getData('night');
    night = Night(
      id: nightFromSql[0]['id'],
      start: nightFromSql[0]['start'],
      end: nightFromSql[0]['end'],
      color: nightFromSql[0]['color'],
    );
    notifyListeners();
  }

  void changeEditable() {
    isEditable = !isEditable;
    notifyListeners();
  }

  presentDatePicker(context, initialDate, dateCallback) async {
    showDatePicker(
            helpText: '',
            context: context,
            locale: const Locale("ru", "RU"),
            initialDate: initialDate,
            firstDate: DateTime.now().subtract(const Duration(days: 5000)),
            lastDate: DateTime.now().add(const Duration(days: 365)))
        .then((pickedDate) {
      if (pickedDate != null) {
        return dateCallback(pickedDate);
      }
    });
    final datalist = await DBHelper.getData('activities');
    _activities = datalist
        .map(
          (activity) => Activity(
              id: activity['id'],
              name: activity['name'],
              start: activity['start'],
              end: activity['end'],
              color: activity['color'],
              isDone: activity['isDone'],
              date: activity['date'],
              serial: 0,
              emoji: activity['emoji']),
        )
        .toList();
    _activities.removeWhere((activity) => (activity.date) != initialDate);
    notifyListeners();
  }

  void sortActivities() {
    _activities.sort((a, b) => b.start.compareTo(a.start));
    // _activities.sort((a, b) => a.serial!.compareTo(b.serial!));
  }

  void sortSerial() {
    _activities.sort((a, b) => a.serial!.compareTo(b.serial!));
    for (int i = 0; i < _activities.length; i++) {
      _activities[i].serial = i;
      DBHelper.update('activities', {'serial': i}, _activities[i].id);
    }
    notifyListeners();
  }

  void addActivity(String id, String name, num start, num end, Color color,
      String date, String emoji) {
    final newActivity = Activity(
        id: id,
        name: name,
        start: start,
        end: end,
        color: color.toString(),
        isDone: 0,
        date: date,
        serial: 0,
        emoji: emoji);
    notifyListeners();
    DBHelper.insert('activities', {
      'id': newActivity.id,
      'name': newActivity.name,
      'start': newActivity.start,
      'end': newActivity.end,
      'color': newActivity.color,
      'isDone': 0,
      'date': newActivity.date,
      'serial': 0,
      'emoji': newActivity.emoji
    });
    fetchAndSet();
  }

  void editActivity(String id, String name, num start, num end, Color color,
      int isDone, String date) {
    DBHelper.update(
        'activities',
        {
          'id': id,
          'name': name,
          'start': start,
          'end': end,
          'color': color.toString(),
          'isDone': isDone,
          'date': date
        },
        id);
    fetchAndSet();
    notifyListeners();
  }

  void deleteActivity(String id) {
    _activities.removeWhere((act) => act.id == id);
    DBHelper.delete(id);
    notifyListeners();
  }

  void calendar(Date date) {
    _activities.removeWhere((activity) => (activity.date) != date.dateView);
  }

  Future<void> fetchAndSet() async {
    try {
      final datalist = await DBHelper.getData('activities');
      _activities = datalist
          .map((activity) => Activity(
              id: activity['id'],
              name: activity['name'],
              start: activity['start'],
              end: activity['end'],
              color: activity['color'],
              isDone: activity['isDone'],
              date: activity['date'],
              serial: activity['serial'],
              emoji: activity['emoji']))
          .toList();
      sortActivities();
      sortSerial();
      calendar(date);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void editDate(DayChangeType change) {
    initializeDateFormatting();
    DateFormat formatterView = DateFormat.MMMd('ru');
    if (change == DayChangeType.yesterday) {
      date.date = date.date.subtract(Duration(days: 1));
      date.dateLocalView = formatterView.format(date.date);
      date.dateView = formatter.format(date.date);
      setActivities([]);
    } else if (change == DayChangeType.tomorrow) {
      date.date = date.date.add(Duration(days: 1));
      date.dateLocalView = formatterView.format(date.date);
      date.dateView = formatter.format(date.date);
      setActivities([
        Activity(
            id: '',
            name: 'name',
            start: 0,
            end: 0,
            color: '',
            isDone: null,
            date: '',
            serial: null,
            emoji: '')
      ]);
    }
    notifyListeners();
    fetchAndSet();
  }

  Future refreshTime() async {
    time = DateFormat('HH:mm').format(DateTime.now());
    rotation = 0.0;
    notifyListeners();
  }

  void addTime(double timeToAdd) {
    Map<String, int> absoluteTime = timeRelativeToAbsolute(timeToAdd);
    var temporaryTime = DateTime.now().subtract(Duration(
        hours: absoluteTime['hour']!, minutes: absoluteTime['minute']!));
    time = DateFormat('HH:mm').format(temporaryTime);
    sortSerial();
    notifyListeners();
  }

  getDateView() {
    initializeDateFormatting();
    DateFormat formatterView = DateFormat.MMMd('ru');
    this.date.dateLocalView == null
        ? this.date.dateLocalView = formatterView.format(DateTime.now())
        : null;
    if (this.date.dateLocalView == formatterView.format(DateTime.now())) {
      this.date.dateLocalView = 'Сегодня';
    }
    return this.date.dateLocalView;
  }

  void updateDate(newDate) {
    DateFormat formatterView = DateFormat.MMMd('ru');
    initialDate = newDate;
    this.date.dateView = formatter.format(newDate);
    this.date.dateLocalView = formatterView.format(newDate);
    this.date.date = newDate;
    calendar(date);
    fetchAndSet();
    // refreshTime();
    notifyListeners();
  }

  Future isAllowed(num activityStart, num activityEnd, id) async {
    var isAllowedVar = true;
    if (activityStart != 2) {
      activities.forEach((element) {
        if (id != element.id) {
          if (activityEnd != 2) {
            if (element.end != 2) {
              if (element.start > element.end) {
                if (activityStart > element.start ||
                    activityEnd > element.start ||
                    activityStart < element.end ||
                    activityEnd < element.end ||
                    (activityStart < element.start &&
                        activityEnd > element.end &&
                        activityStart > activityEnd) ||
                    activityStart == element.start) {
                  isAllowedVar = false;
                }
              } else if (element.start < element.end) {
                if (activityStart > element.start &&
                        activityStart < element.end ||
                    activityEnd < element.end && activityEnd > element.start ||
                    (activityStart < element.start &&
                        activityEnd > element.end) ||
                    activityStart == element.start) {
                  isAllowedVar = false;
                }
              }
            } else {
              if (activityStart < activityEnd) {
                if (activityStart < element.start &&
                    activityEnd > element.start) {
                  isAllowedVar = false;
                }
              }
              if (activityStart > activityEnd) {
                if (activityStart < element.start ||
                    element.start < activityEnd) {
                  isAllowedVar = false;
                }
              }
            }
          } else {
            if (element.end != 2) {
              if (element.start < element.end) {
                if (activityStart > element.start &&
                    activityStart < element.end) {
                  isAllowedVar = false;
                }
              } else {
                if (activityStart > element.start ||
                    activityStart < element.end) {
                  isAllowedVar = false;
                }
              }
            } else {
              if (element.start == activityStart) {
                isAllowedVar = false;
              }
            }
          }
        }
      });
    }
    return isAllowedVar;
  }

  void changePosition(oldIndex, newIndex) {
    if (oldIndex < newIndex) {
      for (var activity in activities) {
        if (activity.serial! >= newIndex) {
          activity.serial = activity.serial! + 1;
        }
      }
      if (newIndex + 1 >= activities.length) {
        activities.add(Activity(
            id: activities[oldIndex].id,
            name: activities[oldIndex].name,
            start: activities[oldIndex].start,
            end: activities[oldIndex].end,
            color: activities[oldIndex].color,
            isDone: activities[oldIndex].isDone,
            date: activities[oldIndex].date,
            serial: newIndex + 1,
            emoji: activities[oldIndex].emoji));
        activities.removeWhere((element) => element.serial == oldIndex);
      } else
        activities[oldIndex].serial = activities[newIndex + 1].serial;
    } else {
      var oldActivity = activities[oldIndex];
      activities.removeAt(oldIndex);
      for (var activity in activities) {
        if (activity.serial! >= newIndex) {
          activity.serial = activity.serial! + 1;
        }
      }
      oldActivity.serial = newIndex;
      activities.add(oldActivity);
    }
    sortSerial();
  }

  Future<void> updateRotation(newRotation) async {
    if (newRotation < 1) {
      newRotation = newRotation + 1;
    }
    if (newRotation > 1) {
      newRotation = newRotation - 1;
    }
    rotation = newRotation;
    notifyListeners();
  }
}
