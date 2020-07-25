import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Budget extends StatefulWidget {
  final Function save;

  Budget(this.save);

  @override
  _BudgetState createState() => _BudgetState();
}

class _BudgetState extends State<Budget> {
  final _budgetController = TextEditingController();

  Future<double> _readBudget() async {
    final prefs = await SharedPreferences.getInstance();
    final budget = prefs.getDouble('my_double_key') ?? 1000.0;
    return budget;
  }

  Future<double> _getBudget() async {
    double budget = await _readBudget();
    return budget;
  }

  @override
  Widget build(BuildContext context) {
    SharedPreferences.setMockInitialValues({});
    final _budget = double.parse(_getBudget().toString());

    return Column(
      children: <Widget>[
        Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 150,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Budget amount',
                    hintText: 'WEEKLY BUDGET',
                  ),
                  controller: _budgetController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              FlatButton(
                child: Text(
                  'Submit',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                onPressed: () {
                  var amountEntered = double.parse(_budgetController.text);
                  if (amountEntered == 0) {
                    return;
                  } else {
                    widget.save(amountEntered);
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          ),
        ),
        Text('Current budget: $_budget'),
        Container(height: (MediaQuery.of(context).size.height / 2) - 150),
      ],
    );
  }
}
