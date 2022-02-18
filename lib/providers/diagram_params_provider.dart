import 'package:ami/models/activity.dart';
import 'package:ami/providers/activities_provider.dart';
import 'package:flutter/cupertino.dart';

class DiagramParams with ChangeNotifier {
  Activities activities;
  DiagramParams({
    required this.activities,
  });
}
