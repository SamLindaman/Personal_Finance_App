import 'package:PersonalFinance/models/transactions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transactions.dart';

// ignore: must_be_immutable
class TransactionList extends StatelessWidget {
  final List<Transactions> transactions;
  Function deleteTx;
  Color color1;

  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? Column(
            children: <Widget>[
              Container(
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
        : SingleChildScrollView(
            child: Container(
              height: (MediaQuery.of(context).size.height -
                  20 -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                physics: ScrollPhysics(),
                itemBuilder: (context, index) {
                  if (transactions[index].expenseType == 1) {
                    color1 = Colors.green;
                  } else if (transactions[index].expenseType == 2) {
                    color1 = Colors.black87;
                  } else if (transactions[index].expenseType == 3) {
                    color1 = Colors.amber;
                  } else if (transactions[index].expenseType == 4) {
                    color1 = Colors.blue;
                  } else {
                    color1 = Theme.of(context).primaryColor;
                  }
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 7),
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Text(
                            '\$${transactions[index].amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: color1,
                            ),
                          ),
                          padding: EdgeInsets.all(15),
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                          decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            border: Border.symmetric(
                              horizontal: BorderSide(color: color1, width: 2),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  transactions[index].title,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                DateFormat.yMMMMEEEEd()
                                    .format(transactions[index].date),
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete_forever,
                            color: color1,
                          ),
                          onPressed: () {
                            deleteTx(transactions[index].id);
                          },
                        )
                      ],
                    ),
                  );
                },
                itemCount: transactions.length,
              ),
            ),
          );
  }
}
