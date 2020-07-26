import 'package:shared_preferences/shared_preferences.dart';

class BudgetModel {
  static Future<double> budgetModel = readBudget();

  static Future<double> readBudget() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.containsKey('my_double_key')
        ? print('contains key')
        : print('missing key');
    var _budgetFuture = prefs.getDouble('my_double_key') ?? 1000.0;
    return _budgetFuture;
  }
}
