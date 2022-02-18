import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/activities_provider.dart';

void presentDatePicker(BuildContext context) {
  showDatePicker(
          helpText: '',
          context: context,
          locale: const Locale("ru", "RU"),
          initialDate:
              Provider.of<Activities>(context, listen: false).initialDate,
          firstDate: DateTime(2020),
          lastDate: DateTime.now().add(const Duration(days: 365)))
      .then((pickedDate) {
    if (pickedDate != null) {
      Provider.of<Activities>(context, listen: false).updateDate(pickedDate);
    }
  });
}
