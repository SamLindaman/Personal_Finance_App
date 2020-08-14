import '../models/budget_model.dart';
import 'package:flutter/material.dart';

class Budget extends StatefulWidget {
  @override
  _BudgetState createState() => _BudgetState();
}

class _BudgetState extends State<Budget> {
  final _budgetController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FutureBuilder<double>(
          future: BudgetModel.readBudget(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 150,
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Set Daily Budget',
                              hintText:
                                  'current: ${snapshot.data.toStringAsFixed(2)}',
                            ),
                            controller: _budgetController,
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        FlatButton(
                          child: Text(
                            'Submit',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                          onPressed: () {
                            double amountEntered =
                                double.parse(_budgetController.text);
                            if (amountEntered == 0) {
                              return;
                            } else {
                              BudgetModel.saveBudget(amountEntered);
                              Navigator.of(context).pop();
                            }
                          },
                        )
                      ],
                    ),
                  )
                : Container(
                    height: 75,
                    child: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  );
          },
        ),
        Container(height: (MediaQuery.of(context).size.height / 2) - 150),
      ],
    );
  }
}
