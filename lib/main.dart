import 'package:flutter/material.dart';
import 'package:dotebook/homeScreen.dart';
import 'package:dotebook/submitScreen.dart';
import 'package:dotebook/summaryScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/submit': (context) => SubmitScreen(),
        '/summary': (context) => SummaryScreen(),
      },
    );
  }
}

