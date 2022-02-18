import 'package:ami/providers/activities_provider.dart';
import 'package:ami/screens/myDay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static Map<int, Color> color = {
    50: Color.fromRGBO(233, 118, 91, 1),
    100: Color.fromRGBO(233, 118, 91, 1),
    200: Color.fromRGBO(233, 118, 91, 1),
    300: Color.fromRGBO(233, 118, 91, 1),
    400: Color.fromRGBO(233, 118, 91, 1),
    500: Color.fromRGBO(233, 118, 91, 1),
    600: Color.fromRGBO(233, 118, 91, 1),
    700: Color.fromRGBO(233, 118, 91, 1),
    800: Color.fromRGBO(233, 118, 91, 1),
    900: Color.fromRGBO(233, 118, 91, 1),
  };
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Activities(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [GlobalMaterialLocalizations.delegate],
        supportedLocales: [const Locale('en'), const Locale('ru')],
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primarySwatch: MaterialColor(0xFFE9765B, color),
          primaryColor: MaterialColor(0xFFE9765B, color),
          fontFamily: 'Bloggersans',
        ),
        initialRoute: '/',
        routes: {
          '/': (ctx) => MyDay(),
        },
      ),
    );
  }
}
