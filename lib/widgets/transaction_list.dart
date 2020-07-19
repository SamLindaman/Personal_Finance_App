import 'package:PersonalFinance/models/transactions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  TransactionList(this.transactions);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? Column(
            children: <Widget>[
              Container(
                height: 300,
                child: Image.asset(
                  'assets/images/emptyList.png',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                "List is empty!\nAdd a transaction by tapping the \'+\' ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          )
        : Container(
            height: 450,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  elevation: 3,
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Text(
                          '\$${transactions[index].amount.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Theme.of(context).primaryColor),
                        ),
                        padding: EdgeInsets.all(15),
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                        decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          border: Border.symmetric(
                            horizontal: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Text(
                              transactions[index].title,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            DateFormat.yMMMMEEEEd()
                                .format(transactions[index].date),
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              itemCount: transactions.length,
            ),
          );
  }
}
