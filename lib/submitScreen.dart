import 'package:flutter/material.dart';
import 'package:dotebook/util.dart';

class SubmitScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Post"),
      ),
      body: SubmitForm(),
    );
  }
}

class SubmitForm extends StatelessWidget {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListView (
      children: <Widget>[
        Text('Title', style: Theme.of(context).textTheme.display1),
        TextField (
          controller: _titleController,
        ),
        Text('Price', style: Theme.of(context).textTheme.display1),
        TextField (
          controller: _priceController,
        ),
        Text('Description', style: Theme.of(context).textTheme.display1),
        TextField (
          controller: _descController,
          keyboardType: TextInputType.multiline,
        ),
        RaisedButton (
          onPressed: () {
            Navigator.pop(context,
                          DoteParam(_titleController.text,
                                    _priceController.text,
                                    _descController.text));
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}