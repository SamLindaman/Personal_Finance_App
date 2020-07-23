import 'package:PersonalFinance/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transactions.dart';

class Chart extends StatelessWidget {
  final List<Transactions> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(
      7,
      (index) {
        final weekDay = DateTime.now().subtract(Duration(days: index));

        double totalSum = 0.0;
        for (int i = 0; i < recentTransactions.length; i++) {
          if (recentTransactions[i].date.day == weekDay.day &&
              recentTransactions[i].date.month == weekDay.month &&
              recentTransactions[i].date.year == weekDay.year) {
            totalSum += recentTransactions[i].amount;
          }
        }

        return {
          'day': DateFormat.E().format(weekDay).substring(0, 1),
          'amount': totalSum
        };
      },
    ).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(
      0.0,
      (sum, element) {
        return sum + element['amount'];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(15),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: groupedTransactionValues.map((e) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  e['day'],
                  e['amount'],
                  totalSpending == 0
                      ? 0.0
                      : (e['amount'] as double) / totalSpending),
            );
          }).toList(),
        ),
      ),
    );
  }
}
