import 'package:flutter/material.dart';

import 'user_transactions.dart';

class NewTransaction extends StatelessWidget {
  final Function addTx;
  NewTransaction(this.addTx);

  final titleController = TextEditingController();
  final amountController = TextEditingController();

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
          ),
          TextField(
            decoration:
                InputDecoration(labelText: 'Amount', hintText: 'numbers only'),
            controller: amountController,
          ),
          FlatButton(
            onPressed: () {
              addTx(
                titleController.text,
                double.parse(amountController.text),
              );
            },
            child: Text('Add Transaction'),
            textColor: Colors.purple,
          ),
        ],
      ),
    );
  }
}
