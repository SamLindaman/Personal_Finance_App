import 'package:flutter/material.dart';

import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transactions.dart';
import './widgets/chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Finanace',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.grey[200],
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [];

  // gets list of transactions that are within the last week
  List<Transaction> get _recentTransactions {
    return _transactions.where((tra) {
      return tra.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(String newTitle, double newAmount) {
    final newTx = Transaction(
        title: newTitle,
        amount: newAmount,
        date: DateTime.now(),
        id: DateTime.now().toString());

    setState(() {
      _transactions.add(newTx);
    });
  }

  void startAddNewTranaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return NewTransaction(_addNewTransaction);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Finance'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => startAddNewTranaction(context),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Chart(_transactions),
          TransactionList(_recentTransactions),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => startAddNewTranaction(context),
      ),
    );
  }
}
