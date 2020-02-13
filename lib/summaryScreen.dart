import 'package:flutter/material.dart';
import 'package:dotebook/util.dart';

class SummaryScreen extends StatefulWidget {
  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  static List<DoteParam> doteSummary = []; // offload this to hardware memory in future

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
          doteSummary.isEmpty ? Text('Empty Dote', style: Theme.of(context).textTheme.display1) :
          ListView.builder(
              itemCount: doteSummary.length,
              itemBuilder: (BuildContext ctxt, int index) {
                DoteParam p = doteSummary.elementAt(index);
                return Card (
                  child: Text('\$'+p.price+' : '+p.title+'\n'+p.desc,
                      style: Theme.of(context).textTheme.display1),
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
                    doteSummary.add(onValue);
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