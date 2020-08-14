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
  int expenseType = 0;
  DateTime _selectedDate;
  DateTime _today = DateTime.now();

  void _submitData() {
    final titleEntered = _titleController.text;
    final amountEntered = double.parse(_amountController.text);
    final dateEntered = _selectedDate == null ? _today : _selectedDate;

    if (titleEntered.isEmpty || amountEntered <= 0) {
      return;
    } else {
      widget.addTx(titleEntered, amountEntered, dateEntered, expenseType);
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

  Widget buildExpenseTypeButton(BuildContext ctx, String title, Color color1,
      Color backgroudColor, int e) {
    return Card(
      color: color1,
      elevation: 10,
      shadowColor: color1,
      child: Container(
        height: 40,
        margin: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        color: Theme.of(context).accentColor,
        child: FlatButton(
          color: backgroudColor,
          hoverColor: color1,
          focusColor: color1,
          onPressed: () {
            expenseType = e;
          },
          child: Text(title),
          textColor: Colors.black87,
          disabledColor: Theme.of(context).accentColor,
        ),
      ),
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
            height: 15,
            width: double.infinity,
          ),
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  buildExpenseTypeButton(
                      context, 'Food', Colors.green, Colors.green[100], 1),
                  buildExpenseTypeButton(
                      context, 'Alcohol', Colors.black54, Colors.black12, 2),
                  buildExpenseTypeButton(
                      context, 'Necessity', Colors.amber, Colors.amber[200], 3),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(width: 10),
                  buildExpenseTypeButton(
                      context, 'Fun', Colors.blue, Colors.blue[200], 4),
                  buildExpenseTypeButton(context, 'Other',
                      Theme.of(context).primaryColor, Colors.purple[200], 0),
                  Container(width: 10),
                ],
              )
            ],
          ),
          Container(
            padding: EdgeInsets.only(left: 5, right: 5, top: 10),
            child: Row(
              children: <Widget>[
                Container(width: 10),
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
