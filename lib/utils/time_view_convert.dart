Map<String, int> timeRelativeToAbsolute(double time) {
  int hours = time ~/ (1 / 24);
  int minutes = ((time % (1 / 24)) * 1442).toInt();
  return {'hour': hours, 'minute': minutes};
}

double timeAbsoluteToRelative(int hour, int minute) {
  return (hour / 24) + (minute / 1440);
}
