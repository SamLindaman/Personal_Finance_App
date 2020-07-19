import 'package:flutter/material.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;
  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();

  void submitData() {
    final titleEntered = titleController.text;
    final amountEntered = double.parse(amountController.text);

    if (titleEntered.isEmpty || amountEntered <= 0) {
      return;
    } else {
      widget.addTx(
        titleEntered,
        amountEntered,
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              labelText: 'Title',
              hintText: 'what did you buy?',
            ),
            controller: titleController,
            onSubmitted: (_) => submitData(),
          ),
          TextField(
            decoration:
                InputDecoration(labelText: 'Amount', hintText: 'numbers only'),
            controller: amountController,
            keyboardType: TextInputType.number,
            onSubmitted: (_) => submitData(),
          ),
          FlatButton(
            onPressed: submitData,
            child: Text('Add Transaction'),
            textColor: Colors.purple,
          ),
        ],
      ),
    );
  }
}
