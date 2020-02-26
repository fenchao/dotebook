import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dotebook/util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class SummaryScreen extends StatefulWidget {
  @override
  SummaryScreenState createState() => SummaryScreenState();
}

class SummaryScreenState extends State<SummaryScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<DoteParam> _getSubmitInfo(BuildContext context) async {
    final result = await Navigator.pushNamed(context, '/submit');
    return result;
  }

  @override
  Widget build(BuildContext context) {
    //final SubmitArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Dote Summary'),
      ),
      body: Center (
        child:
          Global.doteSummary.isEmpty ? Text('Empty Dote', style: Theme.of(context).textTheme.display1) :
          ListView.builder(
              itemCount: Global.doteSummary.length,
              itemBuilder: (BuildContext ctxt, int index) {
                DoteParam p = Global.doteSummary.elementAt(index);
                return Card (
                  child: 
                    Row(
                      children: <Widget>[
                        Image.asset(Global.getPath(index, false),
                            height: 100,),
                        Container(
                          child:Text('\$'+p.price+' : '+p.title+'\n'+p.desc,
                              style: Theme.of(context).textTheme.display1),
                        ),
                      ],
                    ),
                );
              }
          ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _getSubmitInfo(context).then((onValue) {
              if (onValue != null) {
                final snackBar = SnackBar(content:
                  Text(onValue.isValid() ? 'Succssfully Added!' : 'Failed: Invalid Inputs'),
                );
                _scaffoldKey.currentState.showSnackBar(snackBar);
                if (onValue.isValid()) {
                  setState(() {
                    Global.doteSummary.add(onValue);
                  });
                }
              }
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}