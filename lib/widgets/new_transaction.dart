import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;
  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;
  DateTime _today = DateTime.now();

  void _submitData() {
    final titleEntered = _titleController.text;
    final amountEntered = double.parse(_amountController.text);
    final dateEntered = _selectedDate == null ? _today : _selectedDate;

    if (titleEntered.isEmpty || amountEntered <= 0) {
      return;
    } else {
      widget.addTx(
        titleEntered,
        amountEntered,
        dateEntered,
      );

      Navigator.of(context).pop();
    }
  }

  void _openDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now())
        .then(
      (datePicked) {
        datePicked == null
            ? setState(() {
                _selectedDate = DateTime.now();
              })
            : setState(() {
                _selectedDate = datePicked;
              });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          TextField(
            decoration:
                InputDecoration(labelText: 'Amount', hintText: 'numbers only'),
            controller: _amountController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onSubmitted: (_) => _submitData(),
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Title',
              hintText: 'what did you buy?',
            ),
            controller: _titleController,
            //onSubmitted: (_) => _submitData(),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: Text(_selectedDate == null
                      ? 'Date: ${DateFormat.yMd().format(_today)}'
                      : 'Date: ${DateFormat.yMd().format(_selectedDate)}'),
                  fit: FlexFit.tight,
                ),
                Center(
                  child: FlatButton(
                    onPressed: () {
                      _openDatePicker();
                    },
                    child: Text(
                      'Select Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    textColor: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
          RaisedButton(
            onPressed: _submitData,
            child: Text(
              'Add Transaction',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
