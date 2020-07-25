import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String title;
  final double spendingAmount;
  final double spendingPctOfTotal;

  ChartBar(this.title, this.spendingAmount, this.spendingPctOfTotal);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        spendingAmount >= 50
            ? FittedBox(
                child: Text(
                  '\$${spendingAmount.toStringAsFixed(0)}',
                  style: TextStyle(color: Theme.of(context).errorColor),
                ),
              )
            : FittedBox(
                child: Text('\$${spendingAmount.toStringAsFixed(0)}'),
              ),
        SizedBox(height: 5),
        Container(
          height: 50,
          width: 10,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              //if the spending amount for a day is over $50
              //make the error bar red instead of purple.
              spendingAmount >= 50
                  ? FractionallySizedBox(
                      heightFactor: spendingPctOfTotal,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).errorColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    )
                  : FractionallySizedBox(
                      heightFactor: spendingPctOfTotal,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    )
            ],
          ),
        ),
        SizedBox(height: 5),
        spendingAmount <= 50
            ? Text(title)
            : Text(
                title,
                style: TextStyle(color: Theme.of(context).errorColor),
              ),
      ],
    );
  }
}
