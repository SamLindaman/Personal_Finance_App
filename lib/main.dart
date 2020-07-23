import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transactions.dart';
import './models/database_helper.dart';

var range = new Random();

void main() {
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

  Future<void> fetchAndSetTransactions() async {
    final dataList = await DatabaseHelper.getTransactionFromDB('transactions');
    _transactions = dataList
        .map((e) => Transactions(
            id: e['_id'],
            title: e['title'],
            amount: e['amount'],
            date: DateTime.parse(e['date'])))
        .toList();
    //Set State is used for populating the list on initial build
    setState(() {});
  }

  Future<void> _addNewTransaction(
      String newTitle, double newAmount, DateTime datePicked) async {
    int newId = range.nextInt(900000) + 100000;
    DatabaseHelper.insert(
      'transactions',
      {
        '_id': newId,
        'title': newTitle,
        'amount': newAmount,
        'date': datePicked.toIso8601String()
      },
    );
    print('inserted $newTitle to db');

    final newTx = Transactions(
      title: newTitle,
      amount: newAmount,
      date: datePicked,
      id: newId,
    );

    //await dbHelper.insert(newTx);
    //print('inserted ${newTx.title}');
    setState(() {
      _transactions.add(newTx);
    });
  }

  void _deleteTransaction(int id) async {
    await DatabaseHelper.delete(id);
    print('deleted transaction with id: $id');

    setState(() {
      _transactions.removeWhere((element) => element.id == id);
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
    //get info from database and fill _transactions list
    fetchAndSetTransactions();
    final _appBarVar = AppBar(
      title: Text('Personal Finance'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => startAddNewTranaction(context),
        ),
      ],
    );

    return Scaffold(
      appBar: _appBarVar,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
                height: (MediaQuery.of(context).size.height -
                        _appBarVar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    0.27,
                child: Chart(_transactions)),
            Container(
                height: (MediaQuery.of(context).size.height -
                        _appBarVar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    0.73,
                child:
                    TransactionList(_recentTransactions, _deleteTransaction)),
          ],
        ),
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
