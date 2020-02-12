import 'package:flutter/material.dart';
import 'package:dotebook/util.dart';

class SummaryScreen extends StatefulWidget {
  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  String _title = '';
  List<DoteParam> doteSummary = []; // offload this to hardware memory in future

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
        child:
          doteSummary.isEmpty ? Text('Empty Dote', style: Theme.of(context).textTheme.display1) :
        Text(
          'Not empty',
          style: Theme.of(context).textTheme.display1,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _getSubmitInfo(context).then((onValue) {
            setState(() {
              if (onValue != null)
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