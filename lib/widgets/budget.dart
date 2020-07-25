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
    prefs.containsKey('my_double_key')
        ? print('contains key')
        : print('missing key');
    var _budgetFuture = prefs.getDouble('my_double_key') ?? 1000.0;
    return _budgetFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FutureBuilder<double>(
          future: _readBudget(),
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
                              labelText: 'Set Budget',
                              hintText: 'current: ${snapshot.data}',
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
                              widget.save(amountEntered);
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
