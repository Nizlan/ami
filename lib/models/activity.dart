abstract class BasicActivity {
  final String id;
  final num start;
  final num end;
  final String color;
  BasicActivity({
    required this.id,
    required this.start,
    required this.end,
    required this.color,
  });
}

class Night extends BasicActivity {
  Night(
      {required String id,
      required num start,
      required num end,
      required String color})
      : super(id: id, start: start, end: end, color: color);
}

class Activity extends BasicActivity {
  final String name;
  final int? isDone;
  final String date;
  int? serial;
  final String emoji;

  Activity(
      {required String id,
      required this.name,
      required num start,
      required num end,
      required String color,
      required this.isDone,
      required this.date,
      this.serial,
      required this.emoji})
      : super(id: id, start: start, end: end, color: color);
}
