import '../models/activity.dart';

int sortFunction(a, b) {
  if (a == 2 && b == 2 || a != 2 && b != 2) {
    return 0;
  } else if (a == 2 && b != 2) {
    return 1;
  } else {
    return -1;
  }
}

List<Activity> sortForArc(activity) {
  activity.sort((a, b) => sortFunction(a.end, b.end));
  return activity;
}
