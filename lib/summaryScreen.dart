import 'package:flutter/material.dart';
import 'package:dotebook/util.dart';

class SummaryScreen extends StatefulWidget {
  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  String _title = '';
  List<DoteParam> doteSummary = [];

  Future<DoteParam> _getSubmitInfo(BuildContext context) async {
    final result = await Navigator.pushNamed(context, '/submit');
    return result;
  }

  @override
  Widget build(BuildContext context) {
    //final SubmitArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Dote Summary'),
      ),
      body: Center (
        child: Text(
          doteSummary.isEmpty ? 'Empty Dote' :
          doteSummary.elementAt(doteSummary.length-1).desc,
          style: Theme.of(context).textTheme.display1,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _getSubmitInfo(context).then((onValue) {
            setState(() {
              doteSummary.add(onValue);
            });
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}