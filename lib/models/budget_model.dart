import 'package:shared_preferences/shared_preferences.dart';

class BudgetModel {
  static Future<double> budgetModel = readBudget();

  static Future<double> readBudget() async {
    final prefs = await SharedPreferences.getInstance();
    var _budgetFuture = prefs.getDouble('my_double_key') ?? 25.0;
    return _budgetFuture;
  }

  static Future<void> saveBudget(double value) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'my_double_key';
    prefs.setDouble(key, value);
  }
}
