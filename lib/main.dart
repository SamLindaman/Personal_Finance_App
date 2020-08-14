import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './widgets/budget.dart';
import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';

import './models/transactions.dart';
import './models/database_helper.dart';

// ignore: todo
// TODO: Set a weekly budget and color code transaction amounts in the chart

var range = new Random();

Future<void> main() async {
  //Set device orientation so that landscape mode is dissabled
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  //launch app
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
        errorColor: Colors.red[700],
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
  List<Transactions> _transactions = [];

  // gets list of transactions that are within the last week
  List<Transactions> get _recentTransactions {
    return _transactions.where((tra) {
      return tra.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  // Call this to use the database
  Future<void> fetchAndSetTransactions() async {
    final dataList = await DatabaseHelper.getTransactionFromDB('transactions');
    _transactions = dataList
        .map((e) => Transactions(
            id: e['_id'],
            title: e['title'],
            amount: e['amount'],
            expenseType: e['expenseType'],
            date: DateTime.parse(e['date'])))
        .toList();
    //Set State is used for populating the list on initial build
    setState(() {});
  }

  // Saves new transaction to the database, as well as adding it to the temporary
  // list of transactions that is used to update the transactions_list widget
  // to display the transaction cards on the screen.

  Future<void> _addNewTransaction(
      String newTitle, double newAmount, DateTime datePicked, int exp) async {
    int newId = range.nextInt(900000) + 100000;
    DatabaseHelper.insert(
      'transactions',
      {
        '_id': newId,
        'title': newTitle,
        'amount': newAmount,
        'expenseType': exp,
        'date': datePicked.toIso8601String(),
      },
    );
    print('inserted $newTitle to db');

    final newTx = Transactions(
      title: newTitle,
      amount: newAmount,
      date: datePicked,
      id: newId,
      expenseType: exp,
    );

    setState(() {
      _transactions.add(newTx);
    });
  }

  // remove transaction from the database as well as from the temp transaction
  // list and update the screen to no longer display this transaction
  void _deleteTransaction(int id) async {
    await DatabaseHelper.delete(id);
    print('deleted transaction with id: $id');

    setState(() {
      _transactions.removeWhere((element) => element.id == id);
    });
  }

  // call this function to open the bottom slider sheet and display the New Transaction
  // widget within this sheet to add a new transaction
  void startAddNewTranaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return NewTransaction(_addNewTransaction);
      },
    );
  }

  // call this function to display the bottom slider sheet and show the
  // Budget widget within this sheet to save a new budget value
  void _startSaveBudget(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return Budget();
      },
    );
  }

  // BUILD
  @override
  Widget build(BuildContext context) {
    //get info from database and fill _transactions list
    fetchAndSetTransactions();

    //create the App Bar in a variable to be called in the scaffold
    final _appBarVar = AppBar(
      leading: IconButton(
          icon: Icon(Icons.attach_money),
          onPressed: () => _startSaveBudget(context)),
      title: Text('Personal Finance'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => startAddNewTranaction(context),
        ),
      ],
    );

    // Layout of the screen
    return Scaffold(
      appBar: _appBarVar,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(child: Chart(_transactions)),
            Container(
              child: TransactionList(_recentTransactions, _deleteTransaction),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(height: 1),
        color: Theme.of(context).primaryColor,
      ),
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
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
