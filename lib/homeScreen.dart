import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String _a;
    return Scaffold(
      appBar: AppBar(
        title: Text('Dotebook'),
      ),
      body: Center(
        child: RaisedButton(
            child: Text('Start My Dotebook'),
            onPressed: () {
              Navigator.pushNamed(context, '/summary');
            }
        ),
      ),
    );
  }
}