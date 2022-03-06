import 'package:intl/intl.dart';

isCurrentTime(start, end, double rotation) {
  if (start != 2) {
    var _time = DateFormat('HH:mm').format(DateTime.now()).split(':');
    double _reverseRotation = 1 - rotation;
    double _relativeTimeDirty = int.parse(_time[0]) / 24 +
        int.parse(_time[1]) / 60 / 24 +
        _reverseRotation;
    var _relativeTime =
        _relativeTimeDirty < 1 ? _relativeTimeDirty : _relativeTimeDirty - 1;
    if (end != 2) {
      if (start < end) {
        if (_relativeTime > start && _relativeTime < end) {
          return true;
        }
      } else {
        if (_relativeTime > start || _relativeTime < end) {
          return true;
        }
      }
    } else {
      if (_relativeTime * 0.998 < start && _relativeTime * 1.002 > start) {
        return true;
      }
    }
  }
  return false;
}
